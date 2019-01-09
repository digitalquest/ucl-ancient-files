#!/bin/bash

function usage() {
    cat <<-EOHERE
	Usage:

	  copy_live_moodle.sh [--skip-logs]

	Loads a copy of the UCL Moodle live database into a local dev database, as
	specified in first command line argument. Pulls the nightly backup from
	moodle-db-b, filters it for dev/UAT environment and loads it into the
	specified local database. May need the database user to be updated in the
	.sh file, look for the dev_db_user variable.

	Processing performed:

	1. Extracts moodle database from backup using scandump
	2. Optionally excludes data in log tables, supply --skip-logs argument
	   to activate this
	3. Replaces any instances of moodle.ucl.ac.uk with x.moodle-dev.ucl.ac.uk or
	   x.moodle-uat.ucl.ac.uk as specified in second command line argumentA

	Will attempt to create target database if it doesn't exist. If this
	happens it is assumed the dev_db_user specified has enough permissions on this db
	to run the database restore (mdluser_dev and uat both have wildcard permissions
	on moodle_dev* so if the database name begins with this on these hosts this
	should be OK).

	If the local target database exists and is not empty the script will clear it
	(drop all tables) before loading the backup.

	Must be run as ccspsql on a dev or UAT machine. scandump script must be
	present in /data/mysql/backup folder. Will prompt for:

	1. MySQL moodleuser password for local dev database
	2. SSH password for ccspsql if key is not authorised on sevrer containing
	   the database backup
EOHERE
}

# ====== CONFIGURABLE PARAMS =======

backup_host=moodle-db-b.ucl.ac.uk
backup_path=/data/mysql/backup
backup_file_regex='mysqlbackup.dump.backup-(?!till)'
live_db_name=moodle_live
#obtain dev_db_pw and dev_db_user
source ~/.db_backup_credentials

dev_db_host=localhost
dev_db_name=moodle_dev_$(date +"%d%m%Y")

# ==================================

# check we are not on a production box
[[ $(hostname -s) =~ (dev|uat) ]] || {
    echo dev or uat not found in hostname, are you sure you\'re on a dev or uat box?
    exit 1
}

# check running as ccspsql
[[ $(whoami) == ccspsql ]] || {
    echo Must be running as ccspsql
    exit 1
}

# check we have a /data/mysql/backup folder
[[ -d /data/mysql/backup ]] || {
    echo /data/mysql/backup folder not found. Are you sure you\'re on a dev machine?
    exit 1
}

# check scandump is available in the /data/mysql/backup folder
[[ -x /data/mysql/backup/scandump ]] || {
    echo scandump not found or not executable in /data/mysql/backup
    exit 1
}

# check for skip logs
include_logs=1
[[ -n $1 ]] && [[ "$1" == "--skip-logs" ]] && {
    include_logs=0
    shift
}

# get database name
([[ -n $1 ]] && dev_db_name=$1 ) || {
    echo "No database name provided. The script will use \'$dev_db_name\'".
}

# construct dev db credentials conf file as string
dev_credsfile=$(cat <<-EoHERE
[client]
user = ${dev_db_user}
password = ${dev_db_pw}
host = ${dev_db_host}
EoHERE
)

# Test dev password
mysql --defaults-extra-file=<(echo "${dev_credsfile}") <<< ""
[[ $? == 0 ]] || {
    echo Incorrect dev/uat database password or could not connect to database server, please rerun
    exit 1
}
echo Dev password OK

# check if dev db currently exists, if so clear it
if { mysql --defaults-extra-file=<(echo "${dev_credsfile}") <<< "SHOW DATABASES;" | grep -q "${dev_db_name}"; }; then {
    # check if there are any tables to clear
    table_count=$(mysql --defaults-extra-file=<(echo "${dev_credsfile}") <<< "SHOW TABLES FROM ${dev_db_name};" | wc -l)
    if (( ${table_count} > 1 )); then {
       echo Clearing destination database
       drop_query=$(cat <<-EoHERE
	SET SESSION group_concat_max_len=9999999;
	SET FOREIGN_KEY_CHECKS = 0;
	SET @tables = NULL;
	SELECT GROUP_CONCAT(table_schema, '.', table_name) INTO @tables
	  FROM information_schema.tables
	  WHERE table_schema = '${dev_db_name}';
	SET @tables = CONCAT('DROP TABLE ', @tables);
	PREPARE stmt FROM @tables;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	SET FOREIGN_KEY_CHECKS = 1;
EoHERE
        )
        mysql --defaults-extra-file=<(echo "${dev_credsfile}") <<< "${drop_query}"
        [[ $? == 0 ]] || {
            echo Error clearing dev database
            exit 1
        }
    } fi
} else {
    # if database doesn't exist, attempt to create it
    echo Creating new database ${dev_db_name}
    mysql --defaults-extra-file=<(echo "${dev_credsfile}") <<< "CREATE DATABASE ${dev_db_name};"
    [[ $? == 0 ]] || {
        echo Unable to create database ${deb_db_name}
        exit 1
    }
} fi

# grab the backup from server
echo Copying latest backup file from server
latest_backup_file=$(ssh -o LogLevel=ERROR ${backup_host} "echo \$(ls ${backup_path} | grep -P '${backup_file_regex}' | sort | tail -n 1)")
scp -o LogLevel=ERROR ccspsql@${backup_host}:${backup_path}/${latest_backup_file} /data/mysql/backup/
[[ $? == 0 ]] || {
    echo Error copying backup file from ${backup_host}
    exit 1
}
# unzip, extract database with scandump, optionally filter out logs, replace hostames and load into database
echo Loading from backup
if [[ ${include_logs} == 1 ]]; then {
    gzip -d -c /data/mysql/backup/${latest_backup_file} | \
    /data/mysql/backup/scandump --skipuse ${live_db_name} | \
    sed "s/moodle\.ucl\.ac\.uk/${web_hostname}/g" | \
    mysql --defaults-extra-file=<(echo "${dev_credsfile}") -D ${dev_db_name}
} else {
    gzip -d -c /data/mysql/backup/${latest_backup_file} | \
    /data/mysql/backup/scandump --skipuse ${live_db_name} | \
    grep -v "INSERT INTO .mdl_log" | \
    sed "s/moodle\.ucl\.ac\.uk/${web_hostname}/g" | \
    mysql --defaults-extra-file=<(echo "${dev_credsfile}") -D ${dev_db_name}
} fi
[[ $? == 0 ]] || {
echo Error populating dev database
exit 1
}

echo
echo Load completed OK

#save the name of the created/updated database
echo
echo Saving the name of the last database created or updated...
echo "name_of_last_moodle_database=$dev_db_name" > /data/moodle/.name_of_last_moodle_database
echo
echo "All done; script will terminate."

