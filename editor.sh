editor
https://webapps-dev.ucl.ac.uk/phpMyAdmin/

mount -t cifs -o username=$username,password=$password //file03.ucl.ac.uk/vol01$/cceamou ~/ucl/ndrive


smbclient -L cceamou -U file03.ucl.ac.uk/vol01$/cceamou

mount -t cifs //file03.ucl.ac.uk/vol01$/cceamou /home/emeka/ucl/ndrive


svn list -vR https://svn.ucl.ac.uk/repos/isd/moodle30|awk '{if ($3 !="") sum+=$3; i++} END {print "\ntotal size= " sum/1024000" MB" "\nnumber of files= " i/1000 " K"}'

https://svn.ucl.ac.uk/repos/isd/moodle28/

https://svn.ucl.ac.uk/repos/isd/moodle30/

https://svn.ucl.ac.uk/repos/isd/myportfolio15/

https://svn.ucl.ac.uk/repos/isd/opinio/

https://svn.ucl.ac.uk/repos/isd/wiki

https://svn.ucl.ac.uk/repos/isd/wordpress-mu/
 
RemedyForce is accessed at this link
 
https://ucl.my.salesforce.com

This is the link to Lecturecast (Echo 360)
https://lecturecast-admin.ucl.ac.uk:8443

Stats
https://svn.ucl.ac.uk/repos/isd/ats-doc/trunk/LTA_Service_Book_Stats/
 
Creating a dev instance of moodle
https://wiki.ucl.ac.uk/display/ISMoodle/Creating+a+dev+instance+of+moodle
 
Upgrade steps – on the day
https://wiki.ucl.ac.uk/pages/viewpage.action?pageId=61788469

#key Fu4#Nywt
Your personalised connection paths are:

    For Windows:
    \\file03.ucl.ac.uk\vol01$\cceamou\
    For other operating systems (Mac, Linux or Mobile):
    smb://file03.ucl.ac.uk/vol01$/cceamou/


smb://ad.ucl.ac.uk/systems/UCLDesktop/ClusterAvailability

Your personalised connection paths are:

    For Windows:
    \\file03.ucl.ac.uk\grp01$
    For other operating systems (Mac, Linux or Mobile):
    smb://file03.ucl.ac.uk/grp01$

    For Windows:
    \\file03.ucl.ac.uk\grp04$
    For other operating systems (Mac, Linux or Mobile):
    smb://file03.ucl.ac.uk/grp04$

smbclient -L file03.ucl.ac.uk

smbclient \\\\file03.ucl.ac.uk\\vol01$\\cceamou\\

smbmount "\\\\file03.ucl.ac.uk\\vol01$\\cceamou" -U cceamou -c 'mount /home/emeka/ucl/ndrive -u 1000 -g 1000'

smbmount \\\\file03.ucl.ac.uk\\vol01$\\cceamou /home/emeka/ucl/ndrive -o username=cceamou
#
Select Select a shared printer by name and type the following: 
\\print.ad.ucl.ac.uk\print-UCL
Username – ad\<your UCL userID>
##
create database moodle_dev_20160418 default character set utf8 collate utf8_unicode_ci;
use moodle_dev_20160418;
set names 'utf8';
source restore_moodle18apr2016.sql

##
#!/bin/bash
## refresh DEV database: copy live database to dev
# It's important you login as ccspsql. It's not going to work for another user.
# script is intended to be used on moodle-dev.ucl.ac.uk
# change accordingly if you use it elsewhere
#
#define needed constants
NOW=$(date +"%Y%m%d")
FILE="mysqlbackup.dump.backup-$NOW.gz"
TEMP_DIR="/data/mysql/mysql-5.6/backup/temp"
BACKUP_HOST="moodle-db-b.ucl.ac.uk"
BACKUP_DIR="/data/mysql/backup"
MOODLE_SCHEMA="moodle_live"
UNZIPPED_FILE="mysqlbackup.dump.backup-$NOW"
RESTORE_FILE="restore_moodle-$NOW.sql"
SQL_STATEMENT="use moodle_dev_$NOW; set names 'utf8'; source $RESTORE_FILE"
MOODLE_DIR="/data/apache/moodle-vhost/v2810"

cd $TEMP_DIR
# copy recent database backup in current directory
# works because public key of $USER has been copied to $BACKUP_HOST
scp $USER@$BACKUP_HOST:$BACKUP_DIR/$FILE .
#uncompress file
gunzip $FILE
#define name of unzipped file
./scandump --skipuse $MOODLE_SCHEMA < $UNZIPPED_FILE > $RESTORE_FILE 
#source databse credentials
# will set $DBUSER and $DBPASSWORD
. $HOME/.database_credentials

#delete unnecessary file to free up disk space
rm mysqlbackup.dump.backup-*

# create new database
echo "create database moodle_dev_$NOW default character set utf8 collate utf8_unicode_ci" | mysql -u $DBUSER -p$DBPASSWORD
# execute statements

mysql -u $DBUSER -p$DBPASSWORD -e "$SQL_STATEMENT" moodle_dev_$NOW # can last (3 hours)

# find name of old database
OLD_DATABASE=$(grep '$CFG->dbname' $MOODLE_DIR/local_settings.php | cut -d"'" -f2)

#replace name of database in local_settings.php
sed - s/$OLD_DATABASE/moodle_dev_$NOW/g $MOODLE_DIR/local_settings.php

# drop old database
echo "DROP DATABASE IF EXISTS $OLD_DATABASE" | mysql -u $DBUSER -p$DBPASSWORD
##
## End of script
## file is named refresh_db.sh
##

##
## execute the script at 03:00
##
at -f $HOME/refresh_db.sh 03:00 AM


#cd
#touch .database_credentials
#echo "DBUSER='mdluser_dev'" >> .database_credentials
#echo "DBPASSWORD= 'Mdl@dev1'" >> .database_credentials
#chmod 600 .database_credentials

#Da!47_rK
#ssh-keygen -t rsa 
#scp ~/.ssh/id_rsa.pub ccspsql@moodle-db-b.ucl.ac.uk: 
#ssh ccspsql@moodle-db-b.ucl.ac.uk
#cd && chmod 700 .ssh
#cat id_rsa.pub >> ~/.ssh/authorized_keys
#chmod 600 ~/.ssh/authorized_keys
#rm id_rsa.pub

Host

User

IdentityFile

mysql -u $DBUSER -p$DBPASSWORD moodle_dev_$NOW < $RESTORE_FILE

##
# -- Blogs -- #
ssh ccspsql@webapps-db-a.ucl.ac.uk
dbname=wordpress_mu_live
dbuser=wpmu_user
dbpassword='4blg;wpmuklb'
mysql -A -u $dbuser -p$dbpassword $dbname
mysql> select count(*) from wp_users where deleted =0;
+----------+
| count(*) |
+----------+
|     2356 |
+----------+
1 row in set (0.00 sec)

mysql> select count(*) from wp_blogs;
+----------+
| count(*) |
+----------+
|      233 |
+----------+
1 row in set (0.02 sec)

mysql> select path, last_updated from wp_blogs where unix_timestamp(last_updated) > UNIX_TIMESTAMP(LAST_DAY(CURDATE()) + INTERVAL 1 DAY - INTERVAL 1 MONTH) and unix_timestamp(last_updated);
+----------------------------+---------------------+
| path                       | last_updated        |
+----------------------------+---------------------+
| /ucl-migration-conference/ | 2016-05-02 15:44:35 |
| /forensic-sciences/        | 2016-05-02 09:51:40 |
+----------------------------+---------------------+
2 rows in set (0.01 sec)

# -- Moodle -- #
mysql> SELECT     COUNT(*) as num_logins FROM mdl_logstore_standard_log lsl     INNER JOIN mdl_user u         ON lsl.userid = u.id WHERE 1 = 1 AND lsl.timecreated BETWEEN UNIX_TIMESTAMP(DATE_FORMAT(CURDATE() - INTERVAL 1 MONTH, '%Y/%m/01' )) AND (UNIX_TIMESTAMP(DATE_FORMAT(CURDATE(), '%Y/%m/01' )) - 1) AND lsl.`action` = 'loggedin' AND lsl.target = 'user' AND lsl.component = 'core' AND u.auth = 'ldap' LIMIT 1;
+------------+
| num_logins |
+------------+
|     744323 |
+------------+
1 row in set (53 min 23.92 sec)

#==
$LS->dbname    = 'moodle_live';           // database name, eg moodle
$LS->dbuser    = 'moodleuser';            // your database username
$LS->dbpass    = 'kw+2_nE,';              // your database password

DB_USER='moodleuser'
DB_PASSWORD='kw+2_nE,'
mysql -u $DB_USER -p$DB_PASSWORD
#==
$cfg->dbport   = null;
$cfg->dbname   = 'mahara';
$cfg->dbuser   = 'mahara';
$cfg->dbpass   = 'wMXlZbznTukQ';
#=
dbuser=opinio
dbpassword='tr,6_cCt'
#==

docker run --name sam-mysql -e MYSQL_ROOT_PASSWORD=sammy -d mysql:5.7

docker run -it --name webapp --link sam-mysql:mysql --rm -d my-apache-2 sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -u root -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD"'

docker run --name webapp --link sam-mysql:mysql -d my-apache-2

docker exec -it sam-mysql bash



docker run --name app-mysql -e MYSQL_ROOT_PASSWORD=passmysql \
-e MYSQL_DATABASE=webapp \
-e MYSQL_USER=webapp \
-e MYSQL_PASSWORD=webapp \
-v /var/lib/mysql \
-d mysql:5.7 --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci

docker run -it --rm mysql:5.7 --verbose --help
docker run --name sam-mysql -v /home/sammy/dockerbuild/mysql/data:/var/lib/mysql \
-e MYSQL_ROOT_PASSWORD=passmysql -d mysql:5.7

docker exec some-mysql sh -c 'exec mysqldump --all-databases -uroot -p"$MYSQL_ROOT_PASSWORD"' > /some/path/on/your/host/all-databases.sql


#--
FROM httpd:2.4
COPY ./my-httpd.conf /usr/local/apache2/conf/httpd.conf

docker run -it --rm --name my-apache-app -v "$PWD":/usr/local/apache2/htdocs/ httpd:2.4

FROM httpd:2.4
COPY ./public-html/ /usr/local/apache2/htdocs/
docker build -t my-apache2 .
docker run -it --rm --name running-app my-apache2

#-- docker-compose.yml
db:
    image: mysql:latest
    ports:
    - "3306:3306"
    environment:
        MYSQL_ROOT_PASSWORD: symfonyrootpass
        MYSQL_DATABASE: symfony
        MYSQL_USER: symfony
        MYSQL_PASSWORD: symfonypass
worker:
    image: symfony/worker-dev
    ports:
    - "8080:80"
    environment:
        XDEBUG_HOST: 192.168.1.194
        XDEBUG_PORT: 9000
        XDEBUG_REMOTE_MODE: req
    links:
    - db
    volumes:
    - "var/nginx/:/var/log/nginx"
    - symfony-code:/var/www/app-mysql
    #--
    #--
    docker run -d -p 80:80 --name apache-php-app --link db:app-mysql -v "$PWD":/backup my_phpapache
    #docker run -d -p 80:80 --name my-apache-php-app -v "$PWD":/var/www/html php:5.6-apache
    
#--
docker create -v /files --name file_store ubuntu:14.04 /bin/true
#
docker create -v /dbdata --name dbstore mysql:5.7 /bin/true
#
docker run -d --volumes-from dbstore \
-e MYSQL_ROOT_PASSWORD=passmysql \
-e MYSQL_DATABASE=wordpress \
-e MYSQL_USER=wordpress \
-e MYSQL_PASSWORD=wordpress \
--name db1 mysql:5.7
#
docker run -d --volumes-from file_store -p 80:80 --name web1 --link db1:db1 -v "$PWD":/backup my_phpapache
#
define('DB_NAME', getenv('DB1_ENV_MYSQL_DATABASE'));
define('DB_USER', getenv('DB1_ENV_MYSQL_USER'));
define('DB_PASSWORD', getenv('DB1_ENV_MYSQL_PASSWORD'));
define('DB_HOST', getenv('DB1_PORT_3306_TCP_ADDR'). ":". getenv('DB1_PORT_3306_TCP_PORT'));
#--
docker run --rm --volumes-from dbstore -v $(pwd):/backup ubuntu tar cvf /backup/backup.tar /dbdata
#
docker run -v /dbdata --name db2 mysql:5.7 /bin/bash
#
docker run --rm --volumes-from db2 -v $(pwd):/backup ubuntu bash -c "cd /dbdata && tar xvf /backup/backup.tar --strip 1"

#
grep -nr blocktypecategorydesc.resume/view

scp links.txt ccspmdl@moodlevm-nfs.ucl.ac.uk

sed -n -e '/CREATE TABLE.*mytable/,/CREATE TABLE/p' mysql.dump > mytable.dump
sed -n -e '/DROP TABLE.*`mytable`/,/UNLOCK TABLES/p' dump.sql > mytable.sql

#refresh moodle-dev data file
rsync -vaz -e ssh ccspmdl@moodlevm-nfs.ucl.ac.uk:/data/moodle/ /data/moodle/v2810
rsync -vaz -e ssh ccspmdl@moodlevm-nfs.ucl.ac.uk:/data/moodle/ /data/moodle/moodledata


#start opinio
sudo service tomcat7-opinio start

#install wp-cli
 wget -c https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
 chmod +x wp-cli.phar
 mkdir bin
 mv wp-cli.phar bin/wp
 wget -c https://github.com/wp-cli/wp-cli/raw/master/utils/wp-completion.bash
 source ./wp-completion.bash
 vi .bash_profile # add: . ~/wp-completion.bash
 
 ssh ccspmdl@moodle-pp.ucl.ac.uk
 
 ssh ccspsql@moodle-db-pp.ucl.ac.uk

# copy v31 to moodle-pp-[a,b] 
vhost_path="/data/apache/htdocs" 
moodle_dir="v31"
myuser="ccspmdl"
rsync -vaz -e ssh ${vhost_path}/${moodle_dir} ${myuser}@moodle-pp-a.ucl.ac.uk:${vhost_path}/
rsync -vaz -e ssh ${vhost_path}/${moodle_dir} ${myuser}@moodle-pp-b.ucl.ac.uk:${vhost_path}/
rsync -vaz -e ssh ${vhost_path}/${moodle_dir} ${myuser}@moodle-admin-pp.ucl.ac.uk:${vhost_path}/
#pdhEn!cs
# from my laptop:
#rsync -vaz -e ssh ${myuser}@moodle-pp-c.ucl.ac.uk:${vhost_path}/${moodle_dir} ${myuser}@moodle-pp-a.ucl.ac.uk:${vhost_path}/


mysqlimport --columns=username moodle_live RoleAccounts.txt 
mysql -u $DB_USER -p$DB_PASS -e "$my_query" moodledb
#
tee /home/ubuntu/workspace/role_accounts_output.txt

DROP TABLE IF EXISTS `role_accounts`;
CREATE TEMPORARY TABLE `role_accounts` (
  `id` bigint(10) NOT NULL AUTO_INCREMENT,
  `username` varchar(100) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Temporary table with the usernames used by role accounts';

LOAD DATA INFILE '/home/ubuntu/workspace/role_accounts.txt' INTO TABLE role_accounts (username);

SELECT u.username, u.deleted, u.suspended, u.lastaccess, u.lastlogin
FROM mdl_user AS u
WHERE u.username IN (select role_accounts.username from role_accounts);

DROP TABLE IF EXISTS `role_accounts`;
#
########################
#
tee /data/mysql/backup/role_accounts_output.txt

DROP TABLE IF EXISTS `role_accounts`;
CREATE TEMPORARY TABLE `role_accounts` (
  `id` bigint(10) NOT NULL AUTO_INCREMENT,
  `username` varchar(100) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Temporary table with the usernames used by role accounts';

LOAD DATA INFILE '/data/mysql/backup/role_accounts.txt' INTO TABLE role_accounts (username);

SELECT u.username, u.deleted, u.suspended, u.lastaccess, u.lastlogin
FROM mdl_user AS u
WHERE u.username IN (select role_accounts.username from role_accounts);

DROP TABLE IF EXISTS `role_accounts`;
#
mysql -u '' -p'' moodle_schema < role_accounts.sql

## mysqlimport --columns=username $moodle_schema  "$HOME/workspace/role_accounts.txt"

#moodle_schema="moodle_dev_20160603"
moodle_schema="test"
. $HOME/.database_credentials 
mysql -u $DB_USER -p$DB_PASSWORD $moodle_schema < create.sql >> role_accounts_output.txt
mysqlimport -u $DB_USER -p$DB_PASSWORD --columns=username --local $moodle_schema  "$HOME/role_accounts.txt"
mysql -u $DB_USER -p$DB_PASSWORD $moodle_schema < select.sql >> role_accounts_output.txt
mysql -u $DB_USER -p$DB_PASSWORD $moodle_schema < drop.sql >> role_accounts_output.txt

for role_name in "$HOME/role_accounts.txt"
do
	my_query="
	SELECT u.username, u.deleted, u.suspended, u.lastaccess, u.lastlogin
    FROM mdl_user AS u
    WHERE u.username = $role_name
	"
	mysql -u $DB_USER -p$DB_PASSWORD -e "$my_query" $moodle_schema
done

while read role_name; do
	my_query="SELECT username, deleted, suspended, lastaccess, lastlogin FROM mdl_user WHERE username = '$role_name';"
	echo $my_query | mysql -u $DB_USER -p$DB_PASSWORD $moodle_schema
done <$HOME/role_accounts.txt


while read role_name; do
my_query="SELECT u.username, u.firstname, u.lastname, u.deleted, u.suspended, 
DATE_FORMAT(FROM_UNIXTIME(u.lastaccess), '%e %b %Y') AS 'last access',
DATE_FORMAT(FROM_UNIXTIME(u.lastlogin), '%e %b %Y') AS 'last login'
FROM mdl_user AS u
WHERE username = '$role_name';"
echo $my_query | mysql -u $DB_USER -p$DB_PASSWORD $moodle_schema
done <$HOME/role_accounts.txt

##
while read role_name; do
	echo " ' $role_name ' "
	#echo "INSERT INTO role_accounts (username) VALUES ($role_name)"
done <$HOME/role_accounts.txt
##

FROM_ UNIXTIME (lastaccess)
DATE_FORMAT(lastaccess, '%Y/%m/%d')

mysql -u $DB_USER -p$DB_PASSWORD -e "$my_query" $moodle_schema

##
##
##
SELECT r.name,l.action, COUNT( l.userid ) AS counter
FROM `mdl_log` AS l
JOIN `mdl_role_assignments` AS ra ON l.userid = ra.userid
JOIN mdl_role AS r ON ra.roleid = r.id
WHERE ra.roleid IN (3,4,5)
GROUP BY roleid,l.action
ORDER BY counter DESC;

SELECT id, contenthash, contextid, component, filearea, itemid, filepath, filename, userid, timecreated, timemodified, referencefileid FROM mdl_files limit 4;

SELECT * FROM mdl_context limit 5;

select f.filename, f.userid, u.firstname, u.lastname, co.contextlevel, co.instanceid, cu.shortname,
DATE_FORMAT(FROM_UNIXTIME(`f.timecreated`), '%e %b %Y') AS 'time created'
from mdl_files as f, mdl_context as co, mdl_course as cu, mdl_user as u
where f.contextid = co.id
and co.instanceid = cu.id
and f.userid = u.id
and co.contextlevel = 50
limit 5
;

SELECT * FROM mdl_files
WHERE timemodified < UNIX_TIMESTAMP(CURDATE() - INTERVAL 1 YEAR)
AND component ="backup"
AND filename like "%.mbz"
ORDER BY filesize
limit 10
;

select DATE_FORMAT(CURDATE() - INTERVAL 1 YEAR);

select CURDATE();

##

cd svnrepos/moodle28/trunk
svn update
svn status
cd ../..
#
cp -r moodle28/trunk moodle_pp_30
cd moodle_pp_30/
#
#START git SEQUENCE
#
git init
git config --global user.name "Sam Moulem"
git config --global user.email "s.moulem@ucl.ac.uk"
git add --all .
git commit -m "first commit with v2.8.12 taken from svn repo"
git remote add upstream https://github.com/moodle/moodle.git
git remote add dcs_my_moodle git@git.dcs.ucl.ac.uk:cceamou/my_moodle.git
#
git checkout -b UCL_STABLE
git push -u dcs_my_moodle UCL_STABLE
#
git branch --delete master # delete master branch
#
TARGET_BRANCH="MOODLE_30_STABLE"
TARGET_TAG="v3.1.0" # 'v3.0.1' is the tag that identifies release 3.0.1
git checkout --orphan MOODLE_30_GITHUB
git rm -rf .
git pull --tags upstream $TARGET_BRANCH
git reset --hard $TARGET_TAG

git merge --strategy=recursive --strategy-option=ours UCL_STABLE
#
git status #change as needed
git add <file>
#
git commit -m "after upgrade to $TARGET_BRANCH"
# push our newly merged local branch to remote branch MOODLE_26_STABLE on origin
git push -u dcs_my_moodle MOODLE_30_GITHUB:UCL_STABLE

# branch is renamed (branch is moved)
git branch -m UCL_STABLE UCL_2812
# current branch is renamed
git branch -m UCL_STABLE
#
#END git SEQUENCE
#
php admin/cli/upgrade.php
php admin/cli/maintenance.php --disable



cd /data/mysql/backup/
. $HOME/.database_credentials
mysqldump -u $DB_USER -p$DB_PASSWORD -C -Q -e --create-options moodle_dev_20160603 > moodle_uat_database.sql

## MERGING WITH GIT
mkdir svnrepos
cd svnrepos/
mkdir moodle28
cd moodle28/
svn co --username=cceamou --force-interactive https://svn.ucl.ac.uk/repos/isd/moodle28/trunk/
cd ..

git clone --branch MOODLE_28_STABLE --depth 10 https://github.com/moodle/moodle.git
cd moodle
git reset --hard v2.8.10
git checkout -b ucl_stable
shopt -u dotglob
rm -f *; rm -rf *
rm .csslintrc .jshintrc .shifter.json
git add --all .
git commit -m "emptying the directory"
rsync -vazh --exclude='.svn' ../moodle28/trunk .
git add --all .
git commit -m "add Moodle@UCL copied from svn"
git checkout MOODLE_28_STABLE
git merge --strategy=recursive --strategy-option=ours ucl_stable
##

sshfs ccspmdu@moodle-uat.ucl.ac.uk:/data/ $HOME/ucl/moodleuat
fusermount -u /home/emeka/ucl/moodleuat

## WORDPRESS UPDATE/UPGRADE
#Prevent access to Blogs
#path_to_blog="/data/apache/vhost/live/blogs"
#path_to_blog="/data/apache/vhost/dev/blogs"
path_to_blog="/data/apache/vhost/uat/blogs"
blog_parent="/data/apache/vhost/uat"
version="4.5.2"
svn_local_copy="svn_repo_for_blogs"
NOW=$(date +"%Y%m%d")

cd $path_to_blog
#cp .htaccess htaccess.live
cp .htaccess.maint .htaccess

#Backup the WordPress database
#wp db export --add-drop-table /data/mysql/mysql-5.6/backup/wordpress_mu_live_${NOW}
wp db export --add-drop-table $path_to_blog/wordpress_mu_live_${NOW}.sql
# export and compress wordpress database:
#wp db export --add-drop-table - | zip wordpress_db_$(date +"%Y%m%d") -
#scp ccsplta@wwwapps-uat.ucl.ac.uk:/data/apache/vhost/uat/blogs/wordpress_db_20161021.zip .
###Backup up WordPress code and content
#wp db export --add-drop-table /data/ccsplta/wordpress_db_$(date +"%Y%m%d").sql \
#zip /data/ccsplta/wordpress_db_$(date +"%Y%m%d").sql
#Make sure you can read everything in this folder
cd $path_to_blog
find . -name blah # If you see any 'Permission denied' these files or folders are still not accessible
#
rsync -vazh --exclude wordpress_mu_live_${NOW}.sql $path_to_blog/ ${path_to_blog}/blogs_backup_${NOW}

#UPGRADE/UPDATE

cd $path_to_blog

wp core update --version=$version #update wordpress core

wp core update-db --dry-run # do a dry run
wp core update-db # update database
#PLUGINS
#wp plugin update --dry-run --all --version=$version # do a dry run
#wp plugin update --all --version=$version # update plugins
# plugin have to be done one by one with a specific version
# go to https://blogs-uat.ucl.ac.uk/wp-admin/network/update-core.php
# and see which plugin needs updating and to what version
wp plugin update --dry-run --version=3.1.11 akismet
wp plugin update --dry-run --version=4.4.2 contact-form-7  
wp plugin update --dry-run --version=6.4.9.7 google-analyticator  
wp plugin update --dry-run --version=2.7.2 wysija-newsletters  
wp plugin update --dry-run --version=5.3.3 addthis  
#wp plugin update --dry-run --version=10.21 subscribe2 #compatibility unknown
wp plugin update --dry-run --version=1.0 m-wp-popup  
wp plugin update --dry-run --version=4.1.4 wptouch  
wp plugin update --dry-run --version=3.3.1 wordpress-seo  
#
wp plugin update --version=4.4.2 contact-form-7  
wp plugin update --version=6.4.9.7 google-analyticator  
wp plugin update --version=1.0 m-wp-popup  
wp plugin update --version=3.3.1 wordpress-seo  
wp plugin update --version=5.3.3 addthis  
#subscribe2 #compatibility unknown
wp plugin update --version=2.7.2 wysija-newsletters  
wp plugin update --version=4.1.5 wptouch
wp plugin update --version=3.3.1 wordpress-seo
# THEMES
#wp theme update --dry-run --all --version=$version # do a dry run
#wp theme update --all --version=$version # update themes

#TESTING
#from the web interface

#change htaccess
cp htaccess.live .htaccess

#COMMIT CODE TO SVN REPO
cd $path_to_blog
mkdir $svn_local_copy
cd $svn_local_copy
#check out the code
#svn co --username=ccsplta --force-interactive https://svn.ucl.ac.uk/repos/isd/wordpress-mu/trunk/
#svn co --username=cceamou https://svn.ucl.ac.uk/repos/isd/wordpress-mu/trunk/
svn co --username=cceamou https://svn.ucl.ac.uk/repos/isd/wordpress-mu
#delete all content except '.svn'
cd wordpress-mu/trunk
rm -f *
rm -rf -- $(ls -la |grep -v .svn)
#copy the newly updated code
# exclude some directories to avoid a recursive loop :(
rsync -vazh --exclude $svn_local_copy --exclude wordpress_mu_live_${NOW}.sql --exclude blogs_backup_${NOW} $path_to_blog/ . 
#rsync -vazh --exclude svn_repo_for_blogs --exclude wordpress_mu_live_20160615.sql --exclude blogs_backup_20160615 /data/apache/vhost/uat/blogs/ .
--
#cd $svn_local_copy/wordpress-mu
svn status
svn update
svn add wp-includes
#svn add wp-content
svn add wp-admin
svn status
svn commit -m "update core WordPress to $version"
##

wp plugin list #All installed plugins
wp plugin list --status=active --format=json #All plugins activated sitewide
wp plugin list --status=inactive --format=json #All plugins inactive sitewide
# List plugins on each site in a network
wp site list --field=url | xargs -n 1 -I % wp plugin list --url=%

#--
#cd ../..
cd $path_to_blog
git init
git config --global user.name "ccsplta"
git config --global user.email "ccsplta@ucl.ac.uk"
cat << EOF > .gitignore
# backup files #
###################
blogs_backup_*
svn_repo_for_blogs
wordpress_mu_live_*.sql

# not needed #
###################
wp-content
EOF
git add --all .
git commit -m "First commit - update core WordPress to $version"
git remote add origin git@git.dcs.ucl.ac.uk:lta/wordpress-mu.git 
ssh-keygen -t rsa
# copy key to gitlab cat ~/.ssh/id_rsa.pub
git push -u origin master


###
###
moosh role-create -d "Role description" -a student -n "Role name" newstudentrole
###role-update-capability
#Use: -i "roleid" or "role_short_name" with "role capability" and "capability setting" (inherit|allow|prevent|prohibit) and finally, "contextid" (where 1 is system wide)
#moosh role-update-capability -i 5 mod/forumng:grade allow 1
moosh role-update-capability student mod/forumng:grade allow 1
#moosh role-update-capability -i 3 mod/forumng:grade prevent 1
moosh role-update-capability editingteacher mod/forumng:grade prevent 1
https://github.com/tmuras/moosh/blob/master/Moosh/Command/Moodle23/Role/RoleCreate.php
https://github.com/moodle/moodle/blob/6a74e76fb8f35b56691bf5c9d07e5e2dfcb01c10/lib/accesslib.php
https://github.com/moodle/moodle/blob/aeccf4bd944167f06e1cbe089af040174ef412f1/lib/dml/pdo_moodle_database.php
###
###
# commit to dcs repository
git init
git config --global color.ui true
git config user.name "ccsplta Blogs"
git config user.email "ccsplta@ucl.ac.uk"
git add --all .
git commit -m "Update to 4.5.2 - Not sure all the plugins have the latest version"
git checkout -b UAT_STABLE
git branch -D master
git remote add dcs git@git.dcs.ucl.ac.uk:/lta/wordpress-mu.git
git push -u dcs UAT_STABLE
# clean up
rm -rf blogs_backup_20160615
rm -rf svn_repo_for_blogs
rm f wordpress_mu_live_20160615.sql
# some settings for git
vi git-completion.bash #create git auto completion; get it from github.
#vi .bashrc
#source git-completion.bash
cat << EOF >> .bashrc

# git auto-completion #
###################
source git-completion.bash
EOF


## Blogs Prod. Install wp-cli
ccsplta@wwwapps-a.ucl.ac.uk
cd
cd bin/
wget -c https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
php wp-cli.phar --info
chmod +x wp-cli.phar
ln -s ./wp-cli.phar wp

cd /data/apache/vhost/live/blogs
wp site list --field=url | xargs -n 1 -I % sh -c 'echo %; wp plugin list --url=% --format=csv; echo "****" ' > plugins_list.csv

sshfs ccspmdl@moodle-d.ucl.ac.uk:/ /home/sammy/ucl/moodle
cd ~/ucl/moodle/data/apache/htdocs/moodle_v2812/
cp .htaccess_maint .htaccess
cd
fusermount -u ~/ucl/moodle

sshfs ccspmdl@moodle-e.ucl.ac.uk:/ /home/sammy/ucl/moodle
cd ~/ucl/moodle/data/apache/htdocs/moodle_v2812/
cp .htaccess_maint .htaccess
cd
fusermount -u ~/ucl/moodle

sshfs ccspmdl@moodle-f.ucl.ac.uk:/ /home/sammy/ucl/moodle
cd ~/ucl/moodle/data/apache/htdocs/moodle_v2812/
cp .htaccess_maint .htaccess
cd
fusermount -u ~/ucl/moodle

#
git diff --cached > ../calendar_export_execute.patch
git status
#git reset HEAD calendar/export_execute.php
git checkout -- calendar/export_execute.php

#
wp plugin install wp-pro-quiz --version=0.37 --activate-network #Compatible up to: 4.3.5

#==
# Run the SITS Filter 2 XML export process.
# Puppet Name: Run the SITS Filter 2 XML export process
15 1 * * * /usr/local/bin/sits_filter2_RunSits.sh > /dev/null 2>&1
# Puppet Name: Run the SITS Filter 2 CMIS groups import process
15 2 * * * /usr/local/bin/sits_filter2_RunCmis.sh > /dev/null 2>&1

cat /usr/local/bin/sits_filter2_RunSits.sh
# Run the SITS Filter 2 XML export process.
export PATH="$PATH:/usr/local/sits_filter2/lib/Cake/Console"
cd /usr/local/sits_filter2/app && cake RunSits runCronJob

cat /usr/local/bin/sits_filter2_RunCmis.sh
# Run the SITS Filter 2 CMIS groups import process.
# To be executed each morning by cron (ccspmdl), e.g crontab entry:-
# 15  2  *  *  *  /usr/local/bin/sits_filter2_RunCmis.sh > /dev/null 2>&1
export PATH="$PATH:/usr/local/sits_filter2/lib/Cake/Console"
cd /usr/local/sits_filter2/app && cake RunCmis runCmisCronJob

#==
mysql -h webapps-db.ucl.ac.uk -u mahara -pwMXlZbznTukQ mahara

#= export blogs dev database
wp db export --add-drop-table ./wordpress_mu_dev_$(date +"%Y%m%d").sql

#=
git filter-branch --force --index-filter \
'git rm --cached --ignore-unmatch /home/sammy/repos/v16.04.0/config.php' \
--prune-empty --tag-name-filter cat -- --all

alias bfg='java -jar bfg.jar'
bfg --delete-files config.php  myportfolio.git
cd myportfolio.git
git reflog expire --expire=now --all && git gc --prune=now --aggressive
git push

#== WAMS instance of DEV
path_to_blog="/data/apache/vhost/dev/blogs"
blog_parent="/data/apache/vhost/dev"

unset HISTFILE
cd $blog_parent
mkdir wams
rsync -vaz $path_to_blog/ wams
# create database: different database name but same user and password
cd $path_to_blog
wp db export --add-drop-table $path_to_blog/wordpress_mu_dev_wams.sql
#
cd $blog_parent/wams
echo "create database wams default character set utf8 collate utf8_unicode_ci" | mysql -u wpmu_user -p'uOsKMENRTrNBFBp5' -h webapps-dev.ucl.ac.uk
# edit wp-congig.php ## check stmt below ##
sed -i 's/blogs_dev_44/wams/g' /data/apache/vhost/dev/wams/wp-config.php
#
wp db import $path_to_blog/wordpress_mu_dev_wams.sql
# change site url in table wp-options
# chage site home in table wp-otons
# use better search and replace to parse posts
# test with web browser


#==
moosh -n role-create -d "teach read only" -a editingteacher -n "teach readonly" readonlyteacher
###role-update-capability
moosh role-update-capability readonlyteacher mod/forumng:grade prohibit 1


#####
##### BEGIN MOODLE AUTO MERGE
#####
# clone Moodle, from official repo, with some history
#git clone -b MOODLE_28_STABLE --single-branch https://github.com/moodle/moodle.git ci_moodle
git clone -b MOODLE_28_STABLE --depth 10 https://github.com/moodle/moodle.git ci_moodle
# reset to a specific tag if needed
#git reset --hard v2.8.12 #forgotten
# make sure dot glob is off. We're going to delete everything but want to keep '.git'
shopt -u dotglob
rm -f *
rm -rf *
rm .*
# get code currently in use on UCL server (PROD)
rsync -vaz -e ssh ccspmdl@moodle-admin.ucl.ac.uk:/data/apache/htdocs/moodle_v2812/ .
# commit what has just been copied
git add --all .
git commit -m "add ucl code to moodle history"
# create a new branch. We will use it to merge the Moodle update
git checkout -b ucl_30
# fetch the Moodle update
git fetch origin  MOODLE_30_STABLE
# merge the Moodle update with the UCL code
# -s recursive or --strategy=recursive (see git documentation for possible stratgies)
# -X ours or --strategy-option=theirs (in case of conflicts, priority is given to their branch 
#git merge --strategy=recursive ---strategy-option=theirs FETCH_HEAD
git merge -s recursive -X theirs FETCH_HEAD
#check conflicts
git status
#resolve conflicts as needed
git rm filter/algebra/algebra2tex.pl filter/tex/mimetex.darwin filter/tex/mimetex.exe filter/tex/mimetex.freebsd
git commit -m "ucl code updated to 3.0. Auto merge, double check hacks and plugins"
#check all is well
git status
#check folder to see all is well: ucl's theme, config file, ucltools, one of the hacks

#delete your local folder
current_folder=$PWD
cd ..
rm -rf $current_folder


### create symlink on server

### Finish updtate/upgrade with command line tool


### BEGIN COMMIT TO DCS REPO

# two scenarios are possible 
#scenario 2: if you don't have the repo, you need to clone it
#git clone git@git.dcs.ucl.ac.uk:lta/moodle.git ucl_moodle

cd ucl_moodle
git checkout UCL_STABLE
#scenario 1: if you didn't clone, make sure you have the lastest changes
git pull dcs UCL_STABLE
#copy latest code from server
rsync -vaz -e ssh ccspmdl@moodle-admin.ucl.ac.uk:/data/apache/htdocs/moodle_v30x/ .
#commit and push to repo
git add --all .
git commit -m "Update UCL Moodle to v30x"
#scenario 2: git push -u origin UCL_STABLE
git push -u dcs UCL_STABLE
                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
### END COMMIT TO DCS REPO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
#####
##### END MOODLE AUTO MERGE
#####

### install terminus
curl https://github.com/pantheon-systems/terminus/releases/download/0.11.2/terminus.phar -L -o $HOME/workspace/bin/terminus && chmod +x $HOME/workspace/bin/terminus
terminus auth login --machine-token=<machine token>
#microphoenix - dev site
mysql -u pantheon -p8ed525c2d1c94f0a82770f25e9666d6a -h dbserver.dev.632a0824-d556-4c9b-9c1f-7eebc5253905.drush.in -P 15037 -A pantheon

# tmux when start terminal
#The tmux attach line is to make sure if there is a session it attaches to and if there was no session you will not get the warning about "no session".
tmux attach &> /dev/null
if [[ ! $TERM =~ screen ]] && [ -z $TMUX ]; then
    #exec tmux -2 new -s emul -n sess_a
    #exec tmux
    tmux -2 new -s emul -n sess_a
fi


## create digipress - clone of blogs-dev
#digipres.blogs-dev.ucl.ac.uk  -  http://blogs-dev.ucl.ac.uk/
cd /data/apache/vhost/dev/
rsync -vaz blogs/ digipres-blogs-dev
cd blogs
wp db export --add-drop-table $HOME/digipress_11072016.sql
cd ../digipres-blogs-dev/
#quick check to see if can access the database
mysql -u wpmu_user -puOsKMENRTrNBFBp5 -h webapps-dev.ucl.ac.uk digipres
#
wp db import $HOME/digipress_11072016.sql
#dry run
./replace/srdb.cli.php --dry-run -u wpmu_user -puOsKMENRTrNBFBp5 -h webapps-dev.ucl.ac.uk -n digipres -s blogs-dev.ucl.ac.uk -r digipres.blogs-dev.ucl.ac.uk > replace/searchandreplace.txt
#real
./replace/srdb.cli.php -u wpmu_user -puOsKMENRTrNBFBp5 -h webapps-dev.ucl.ac.uk -n digipres -s blogs-dev.ucl.ac.uk -r digipres.blogs-dev.ucl.ac.uk
#review all the wp_x_options tables with MySQL Workbench
#look for three fields and edit them as needed:
#home, siteurl, fileupload_url
#SELECT option_name, option_value FROM digipres.wp_106_options where option_name in ('home', 'siteurl', 'fileupload_url');




##saved 11 jul 2016
cd repos/
ll
git@git.dcs.ucl.ac.uk:lta/moodle.git uclmoodle
git clone git@git.dcs.ucl.ac.uk:lta/moodle.git uclmoodle
ll
cd uclmoodle/
git log -10 --pretty=online
git log -10 --pretty=oneline
git log --pretty=oneline
ls
vi version.php 
cd ..
ls
ls
ls ucl/
cd ucl/
ls moodle
less server_list 
sshfs ccspmdl@moodle-admin.ucl.ac.uk:/ /home/sammy/ucl/moodle
cd moodle/data/apache/htdocs/
ll
cd moodle
pwd
cd ..
cd moodle
cd uclmoodle/
less version.php 
cd ..
rm -rf uclmoodle/
ls
git clone -b MOODLE_28_STABLE --depth=10 https://github.com/moodle/moodle.git githubmoodle
ls
cd githubmoodle/
git log 
git tag
git tag -n5
git log
git status
ls -a
shopt -u dotglob
rm -f *
ls -a
rm -rf *
ls -a
rm -f .*
ls -a
git status
less version.php 
pwd
cd ..
ls
less ucl/server_list 
ls
rsync -vaz ./moodle_v2812/ /home/sammy/repos/githubmoodle
git status
git ls-files --others --exclude-standard
git ls-files --others --exclude-standard > ../ucl_untracked_files.txt
less ../ucl_untracked_files.txt 
ls -a
git add --all .
git status
git reset HEAD 
git status
git status | grep modified: > ../ucl_modified_files.txt
less ../ucl_modified_files.txt 
git add --all .
git commit -m "UCL Moodle 2.8.12 - taken from moodle-admin on `date`"
git checkout -b UCL_STABLE
git branch -a
git remote add dcs git@git.dcs.ucl.ac.uk:lta/moodle.git
git push -u dcs UCL_STABLE 
git remote -v
mysql -u wpmu_user -puOsKMENRTrNBFBp5 -h webapps-dev.ucl.ac.uk digipres
git fetch --unshallow origin
ll repos/
cd repos/ucl_moodle_patches/
ls
cd ..
ls
cd scrap/
ls
cp *.txt ../ucl_moodle_patches/
cd ../ucl_moodle_patches/
ls
git status
git add *.txt
git status
git commit -m "add text files containing list of ucl extensions"
git remote -v
git branch -a
git push -u origin master 
git remote -v
git log
git reset --hard HEAD~1
git log
git pull origin 
ssh ccsplta@wwwapps-dev.ucl.ac.uk
ls ~/ucl/moodle
ls ~/ucl/wordpress_live/
ls ~/ucl/moodledev
ls ~/ucl/moodle
cd ../scrap/
cp *.txt ../ucl_moodle_patches/
cd ../ucl_moodle_patches/
git add *.txt
git commit -m "add text files containing list of ucl extensions"
git push -u origin master 
git remote -v
ping -c 3 git.dcs.ucl.ac.uk
git push -u dcs UCL_STABLE 
##saved 11 jul 2016

##make moodle repo without history. merge official moodle v3.1.0
#on personal workstation
cd /n/Downloads/github/
ssh ccspmdl@moodle-f.ucl.ac.uk
#on server - prepare tar ball
cd /data/apache/htdocs/
tar cvzf moodle_v2812.tar.gz moodle_v2812/
#on personal workstation
scp ccspmdl@moodle-f.ucl.ac.uk:/data/apache/htdocs/moodle_v2812.tar.gz .
tar xvzf moodle_v2812.tar.gz 
rm moodle_v2812.tar.gz
#on server
rm moodle_v2812.tar.gz
#on workstation

#############initialize ucl git moodle repo######################
# don't try from git-bash, you need rsync installed
TARGET_BRANCH="MOODLE_28_STABLE" # our current branch
TARGET_TAG="v2.8.12" # our current tag
MOODLE_REPO="https://github.com/moodle/moodle.git"
git clone --branch $TARGET_BRANCH --single-branch $MOODLE_REPO initialize_moodle_repo
cd initialize_moodle_repo
git reset --hard $TARGET_TAG #just in case they are ahead of our target tag
ls -a #check
git log --pretty=oneline -5
git rm -rf . #delete everything in current directory
ll -ah #check
git status #check
git commit -m "Take Moodle 2.8.12 from the Moodle official repository; then empty the working directory"
git status #check
git reflog #check
git checkout HEAD@{1} .gitignore #add back .gitignore
ll -ah #check
rsync -vaz -e ssh ccspmdl@moodle-f.ucl.ac.uk:/data/apache/htdocs/moodle_v2812/ . #get moodle@ucl
echo "config.php" >> .gitignore #add file to .gitignore
echo "local_settings.php" >> .gitignore #add file to .gitignore
git status #check
git add --all . #stage all files for commit
git status #check
git commit 
#commit message:
#Moodle@ucl initial commit. 
#v2.8.12 copied from moodle-f.ucl.ac.uk
#Contains all the hacks and extensions
#We have kept a common history with the Moodle official repository.
#We think it will facilitate merging future releases.
git log --pretty=oneline -5 #check

git branch -m MOODLE_28_STABLE UCL_STABLE #rename branch MOODLE_28_STABLE
git remote add dcs git@git.dcs.ucl.ac.uk:lta/moodle.git #add gitlab remote repository
git push -u dcs UCL_STABLE #push to gitlab 
#ignore what follows about git init and commit
###################################initialize ucl git moodle repo

TARGET_TAG="v3.0.5" # our current tag
cd moodle_v2812/ #replace accoridngly
# cd path_to_moodle_local_repo

# 0000000000000000000000000000 begin ignone 0000000000000000000000000000 #
git init
git add --all .
git commit -m "moodle ucl initial commit. v2.8.12 on moodle-f.ucl.ac.uk"
#copy code to uat. faster than git-bash on windows
tar cvzf moodle_v2812.tar.gz moodle_v2812/
scp moodle_v2812.tar.gz ccspmdu@moodle-uat.ucl.ac.uk:
#end copy code to uat
#login to uat
ssh ccspmdu@moodle-uat.ucl.ac.uk
unset HISTFILE
tar xvzf moodle_v2812.tar.gz
rm moodle_v2812.tar.gz
cd moodle_v2812/
git reset --hard HEAD@{0} #for some reason needed to do that after scp and tar extract.
# end login to uat
# 0000000000000000000000000000 end ignone 0000000000000000000000000000 #

git checkout -b ucl-temp-merge-3.0.5
#git checkout -b ucl-temp-merge-$TARGET_TAG
git remote add upstream https://github.com/moodle/moodle.git
#git fetch upstream MOODLE_30_STABLE
git fetch upstream +refs/tags/v3.0.5
#git fetch upstream +refs/tags/$TARGET_TAG

#warning: no common commits
#remote: Counting objects: 678093, done.
#remote: Compressing objects: 100% (74/74), done.
#remote: Total 678093 (delta 41), reused 18 (delta 18), pack-reused 678001
#Receiving objects: 100% (678093/678093), 316.58 MiB | 14.89 MiB/s, done.
#Resolving deltas: 100% (477246/477246), done.
#From https://github.com/moodle/moodle
# * tag               v3.0.5     -> FETCH_HEAD

# merge the Moodle update with the UCL code. Use the following options:
# -s recursive or --strategy=recursive (see git documentation for possible stratgies)
# -X ours or --strategy-option=theirs (in case of conflicts, priority is given to their branch 
#git merge --strategy=recursive ---strategy-option=theirs FETCH_HEAD
git merge -s recursive -X theirs FETCH_HEAD
#git merge -Xtheirs FETCH_HEAD #should work
#Automatic merge failed; fix conflicts and then commit the result.

#check conflicts
git status
# Unmerged paths:
#   (use "git add/rm <file>..." as appropriate to mark resolution)
#
#       both added:         filter/algebra/algebra2tex.pl
#       both added:         filter/tex/mimetex.darwin
#       both added:         filter/tex/mimetex.exe
#       both added:         filter/tex/mimetex.freebsd
#       both added:         filter/tex/mimetex.linux
#       both added:         lib/horde/locale/pt_BR/LC_MESSAGES/Horde_Mime.mo
#       both added:         lib/htmlpurifier/HTMLPurifier/ConfigSchema/schema.ser
#       both added:         lib/tcpdf/include/sRGB.icc
#       both added:         question/type/ddimageortext/pix/icon.png
#       both added:         question/type/ddmarker/pix/icon.png
#       both added:         question/type/ddwtos/pix/icon.png
#       both added:         question/type/gapselect/pix/icon.png

#resolve conflicts as needed
#git rm
#git add
git add filter/algebra/algebra2tex.pl
git add filter/tex/mimetex.darwin
git add filter/tex/mimetex.exe
git add filter/tex/mimetex.freebsd
git add filter/tex/mimetex.linux
git add lib/horde/locale/pt_BR/LC_MESSAGES/Horde_Mime.mo
git add lib/htmlpurifier/HTMLPurifier/ConfigSchema/schema.ser
git add lib/tcpdf/include/sRGB.icc
git add question/type/ddimageortext/pix/icon.png
git add question/type/ddmarker/pix/icon.png
git add question/type/ddwtos/pix/icon.png
git add question/type/gapselect/pix/icon.png

#commit
git commit -m "merged Moodle v3.0.5 and Moodle@ucl"
#git commit -m "merged Moodle $TARGET_TAG and Moodle@ucl"


# 00000000000 begin aplly ucl hacks 00000000000 #
#download from my workstation
PATCH_DIR="$HOME/ucl_patches"
git clone git@git.dcs.ucl.ac.uk:lta/moodle_patches.git $PATCH_DIR
#rsync -vaz-e ssh $PATCH_DIR ccspmdu@moodle-uat.ucl.ac.uk:
scp -rp $PATCH_DIR ccspmdu@moodle-uat.ucl.ac.uk:   ##recursive, preserves access time

#apply patches -- for each file do a search for 'ucl hack'. All should already contain the hack.
#for i in $PATCH_DIR/*.patch; do git apply --stat $i; done
for i in $PATCH_DIR/*.patch; do git apply --check --verbose $i; done
#for i in $PATCH_DIR/*.patch; do git apply --verbose $i; done

grep -nr 'END UCL hack' .

#delete patch directory
rm -rf $PATCH_DIR
# 00000000000 end aplly ucl hacks 00000000000 #

##
#create capabilies file from selenium script
grep 'input\[name=&quot;' selenium_student_read_only2.html > test.txt


#
asa-vpn-isd.ucl.ac.uk
==
mysql-support@ucl.ac.uk
lta-learning@ucl.ac.uk
is-webteam@ucl.ac.uk
webservices-team@ucl.ac.uk
==
Data/ccsplta@wwwapps-a.ucl.ac.uk
Data/ccsplta@wwwapps-dev.ucl.ac.uk
Data/ccsplta@wwwapps-uat.ucl.ac.uk
SQL/ccspsql@webapps-db-a
Data/ccsplta@webapps-dev.ucl.ac.uk
Data/ccsplta@webapps-uat.ucl.ac.uk
Data/ccsplta@webappsvm-b.ucl.ac.uk
SQL/ccspsql@webapps-db.ucl.ac.uk
SQL/ccspsql@webapps-db-a.ucl.ac.uk
SQL/ccspsql@webapps-dev.ucl.ac.uk
SQL/ccspsql@webapps-uat.ucl.ac.uk
Data/ccspmdd@moodle-admin-dev.ucl.ac.uk
Data/ccspmdd@moodle-dev.ucl.ac.uk
Data/ccspmdl@moodle-admin-pp.ucl.ac.uk
Data/ccspmdl@moodle-archive.ucl.ac.uk
Data/ccspmdl@moodle-cid-dev.ucl.ac.uk
Data/ccspmdl@moodle-nfs-pp.ucl.ac.uk
Data/ccspmdl@moodle-pp-a.ucl.ac.uk
Data/ccspmdl@moodle-pp-b.ucl.ac.uk
Data/ccspmdl@moodle-pp-c.ucl.ac.uk
Data/ccspmdl@moodle-test.ucl.ac.uk
Data/ccspmdu@moodle-admin-uat.ucl.ac.uk
Data/ccspmdu@moodle-test.ucl.ac.uk
Data/ccspmdu@moodle-uat.ucl.ac.uk
SQL/ccspsql@moodle-admin-dev.ucl.ac.uk
SQL/ccspsql@moodle-admin-uat.ucl.ac.uk
SQL/ccspsql@moodle-db-pp.ucl.ac.uk
SQL/ccspsql@moodle-dev.ucl.ac.uk
SQL/ccspsql@moodle-test.ucl.ac.uk
SQL/ccspsql@moodle-uat.ucl.ac.uk
Data/ccspmdl@moodle-admin.ucl.ac.uk
Data/ccspmdl@moodle-d.ucl.ac.uk
Data/ccspmdl@moodle-e.ucl.ac.uk
Data/ccspmdl@moodle-f.ucl.ac.uk
Data/ccspmdl@moodlevm-nfs.ucl.ac.uk
SQL/ccspsql@moodle-db-a.ucl.ac.uk
SQL/ccspsql@moodle-db-b.ucl.ac.uk
Data/ccsplta@webappsvm-a.ucl.ac.uk
SQL/ccspsql@webapps-db-a.ucl.ac.uk


http://pcr.qa.com/p2f/main.html

##
19 July 2016:
test apply patches
wiki page on update with git
test create read only roles
test change moodle config on snapshot
calendar event Tudor

still to do:
wiki page update wordpress
wiki page update mahara
git repository plugin
clone blogs-dev to digipres
move database content from live to uat,dev

#
wp super-admin add 4938
wp super-admin add s.moulem@ucl.ac.uk
wp super-admin add cceamou

#
# update mahara/myportfolio git repo
#
ssh ccsplta@webapps-dev.ucl.ac.uk "ls"
ssh ccsplta@webapps-dev.ucl.ac.uk "git clone git@git.dcs.ucl.ac.uk:lta/myportfolio.git"
git clone git@git.dcs.ucl.ac.uk:lta/myportfolio.git
cd myportfolio
git checkout UCL_STABLE
git rm -r .
rsync -vaz ccsplta@webappsvm-b.ucl.ac.uk:/data/apache/htdocs/mahara/mahara/ .
git add --all .
git commit -m "Updates from server on `date`"
git push -u origin UCL_STABLE



scp ccspmdl@moodle-pp-a.ucl.ac.uk:/data/apache/htdocs/moodle/theme/ucl/renderers/core_renderer.php .

scp /n/Downloads/github/core_renderer.php ccspmdl@moodle-pp-{a,b,c}.ucl.ac.uk:/data/apache/htdocs/moodle/theme/ucl/renderers/

#usemenu items missing
https://tracker.moodle.org/browse/CONTRIB-5708


#example
find /home/www -type f -print0 | xargs -0 sed -i 's/subdomainA\.example\.com/subdomainB.example.com/g'

grep -rl '$OUTPUT->login_info' layout

find layout -type f -exec sed -i 's/$OUTPUT->login_info/$OUTPUT->user_menu/g' {} +
find layout -type f -exec sed -i 's/$OUTPUT->user_menu/$OUTPUT->login_info/g' {} +
#
find . -type f -exec sed -i 's/"spaceKey":"UCL"/"spaceKey":"UCL_WAMS_20SEP2016"/g' {} +
#replace extends with extend

$oldstring='$OUTPUT->login_info'
$newstring='$OUTPUT->user_menu'
grep -rl login_info . | xargs sed -i s/$oldstring/$newstring/g

#####
##### course tabs
##### 
#dark blue is what we want so we look for title header example 
grep -nr '#619eb6' theme/ucl

.block .header .title h2 {
    background: #4B7A8D !important;
    
#we look for light blue and change to dark
    #619eb6
    ./style/settings.css:391:    background-color: #619eb6;

./style/settings.css: #at the end

/*Samuel Moulem 27/07/2016 - issue: text color of user menu*/

/* ucl hack begin - Samuel Moulem 27/07/2016 - issue: text color of user menu */
.usermenu .moodle-actionmenu .toggle-display,
.usermenu .moodle-actionmenu .toggle-display:link,
.usermenu .moodle-actionmenu .toggle-display:hover,
.usermenu .moodle-actionmenu .toggle-display:visited,
.usermenu .moodle-actionmenu .toggle-display:active {
    color: #fff;
}

.usermenu .moodle-actionmenu .toggle-display .userbutton .avatars img {
    display: none;
}

.menu-action-text, 
.menu-action-text:link,
.menu-action-text:hover 
.menu-action-text:visited 
.menu-action-text:active {
    color: #fff;
} 
/* ucl hack end */


#
# Turnitin
#
unset HISTFILE
unzip turnitintooltwo_2016072601.zip
cd mod/
rsync -vaz turnitintooltwo/ /data/apache/moodle-vhosts/31-0704/mod/turnitintooltwo

##
## for behat testing
##
php -S localhost:8001 -t /home/ccspmdd/v2812_sammy/

require_once(dirname(__FILE__) . '/behat_settings.php');

$CFG->behat_prefix = 'b_';
$CFG->behat_dataroot = '/data/apache/moodle-vhosts/behat_data';
$CFG->behat_wwwroot = 'https://behat_data.moodle-dev.ucl.ac.uk';

vendor/bin/behat --config /data/moodle/behatdataroot/behat/behat.yml --tags ~@javascript
vendor/bin/behat --config /data/moodle/behatdataroot31/behat/behat.yml --feature="auth/tests/behat/login.feature"
vendor/bin/behat --config /data/moodle/behatdataroot31/behat/behat.yml --name="Log in with the predefined admin user with Javascript disabled"
vendor/bin/behat --config /data/moodle/behatdataroot31/behat/behat.yml --name="Log in as an existing admin user filling the form"
vi auth/tests/behat/sam.feature
vendor/bin/behat --config /data/moodle/behatdataroot31/behat/behat.yml --name="Login as sammy existing user"


php admin/tool/behat/cli/util.php --drop
php admin/tool/behat/cli/init.php
#If you are adding new tests or steps definitions update the tests list:
php admin/tool/behat/cli/util.php --enable
#if you want to prevent access to test environment
php admin/tool/behat/cli/util.php --disable

grep -nr AllowOverride .
asa-vpn-isd.ucl.ac.uk
protect_directory
install_init_dataroot


unset HISTFILE
moodle-test.ucl.ac.uk
moodle-dev.ucl.ac.uk

https://v2812.moodle-uat.ucl.ac.uk
/data/moodledata


# ssh -L 3306:localhost:3306 ccspmdd@moodle-dev.ucl.ac.uk -N -f
# ssh -L 8081:localhost:8081 ccspmdd@moodle-dev.ucl.ac.uk -N -f
#
# php -S 0.0.0.0:8001 -t /data/moodle/behatwww

mysql -u mdluser_dev -pMdl@dev1 -h 127.0.0.1 #-P 3306 moodle_dev_20160602

##
## moodle-dev: php admin/tool/behat/cli/init.php
You are already using composer version 1.2.0 (stable channel).
Loading composer repositories with pUpdating dependencies (including require-dev)         Nothing to install or update
Package symfony/icu is abandoned, you should avoid using it. Use symfony/intl instead.
Generating autoload files
Dropping tables:

##
scp ccsplta@webapps-uat.ucl.ac.uk:/data/mahara-vhosts/v16040/lib/mahara.php .
scp ccsplta@webapps-uat.ucl.ac.uk:/data/mahara-vhosts/v16040/skin/import.php .

scp mahara.php ccsplta@webapps-uat.ucl.ac.uk:/data/mahara-vhosts/v16040/lib/mahara.php
scp import.php ccsplta@webapps-uat.ucl.ac.uk:/data/mahara-vhosts/v16040/skin/import.php

#
cceamou@CS00011170.ad.ucl.ac.uk

###
.....F-.F-------------------------------------------------.PHP Fatal error:  Allowed memory size of 134217728 bytes exhausted (tr
ied to allocate 1048577 bytes) in /data/apache/moodle-vhosts/moodle_31_develop/cache/stores/file/lib.php on line 369

Fatal error: Allowed memory size of 134217728 bytes exhausted (tried to allocate 1048577 bytes) in /data/apache/moodle-vhosts/moo
dle_31_develop/cache/stores/file/lib.php on line 369

##added line in a file
vi cache/stores/file/lib.php
ini_set('memory_limit', '512M');

.usermenu .moodle-actionmenu .toggle-display .userbutton
.avatars

11:45 10/08/2016
10.128.33.209
144.82.115.65
https://moodle.ucl.ac.uk/mod/workshop/exsubmission.php
Coding error detected, it must be fixed by a programmer: PHP catchable fatal error
#
#grep 10.0.112.164 /etc/httpd/logs/error_log
[Thu Aug 11 14:52:57 2016] [error] [client 10.0.112.164] Default exception handler: Coding error detected, it must be fixed by a programmer: PHP catchable fatal error Debug: Argument 3 passed to file_postupdate_standard_editor() must be of the type array, null given, called in [dirroot]/mod/workshop/exsubmission.php on line 159 and defined\nError code: codingerror\n* line 425 of /lib/setuplib.php: coding_exception thrown\n* line 223 of /lib/filelib.php: call to default_error_handler()\n* line 159 of /mod/workshop/exsubmission.php: call to file_postupdate_standard_editor()\n, referer: https://moodle.ucl.ac.uk/mod/workshop/exsubmission.php?cmid=2318441&id=29171&edit=on


SHOW FULL TABLES IN moodle_sits_management_2 WHERE TABLE_TYPE LIKE 'VIEW';
show procedure status;
show create procedure moodle_sits_management_2.sync_students;

##
git clone --branch MOODLE_29_STABLE https://github.com/moodle/moodle.git sammy_moodle297
cd sammy_moodle297
git reset --hard v2.9.7
cd admin/cli/

#//for behat testing
require_once(dirname(__FILE__) . '/behat_settings.php');
#
$CFG->behat_prefix = 'sammy_behat297_';
$CFG->behat_dataroot = '/data/moodle/sammy_behatdataroot297';
$CFG->behat_wwwroot = 'http://moodle-dev.ucl.ac.uk/sammybehat297';
php admin/tool/behat/cli/init.php >> /data/apache/moodle-vhosts/sammy_behat297_installation.txt
vendor/bin/behat --config /data/moodle/sammy_behatdataroot297/behat/behat.yml --name='Log in as an existing admin user filling the form'

php install.php --lang=en \
--wwwroot='http://moodle-dev.ucl.ac.uk/sammymoodle297' \
--dataroot='/data/moodle/sammy_moodle297' \
--dbhost='localhost' \
--dbname='moodle_dev_20160802' \
--dbuser='mdluser_dev' \
--dbpass='Mdl@dev1' \
--prefix='sammy_moodle297_' \
--fullname='Sammy Moodle v2.9.7' \
--shortname='Sam 297' \
--summary='Instance to test settings. Will be deleted' \
--adminuser='admin' \
--adminpass='password' \
--adminemail='admin@noreply.net' \
--non-interactive \
--agree-license >> /data/apache/moodle-vhosts/sammy_moodle297_installation.txt

Options:
--chmod=OCTAL-MODE    Permissions of new directories created within dataroot.
                      Default is 2777. You may want to change it to 2770
                      or 2750 or 750. See chmod man page for details.
--lang=CODE           Installation and default site language.
--wwwroot=URL         Web address for the Moodle site,
                      required in non-interactive mode.
--dataroot=DIR        Location of the moodle data folder,
                      must not be web accessible. Default is moodledata
                      in the parent directory.
--dbtype=TYPE         Database type. Default is mysqli
--dbhost=HOST         Database host. Default is localhost
--dbname=NAME         Database name. Default is moodle
--dbuser=USERNAME     Database user. Default is root
--dbpass=PASSWORD     Database password. Default is blank
--dbport=NUMBER       Use database port.
--dbsocket=PATH       Use database socket, 1 means default. Available for some databases only.
--prefix=STRING       Table prefix for above database tables. Default is mdl_
--fullname=STRING     The fullname of the site
--shortname=STRING    The shortname of the site
--summary=STRING      The summary to be displayed on the front page
--adminuser=USERNAME  Username for the moodle admin account. Default is admin
--adminpass=PASSWORD  Password for the moodle admin account,
                      required in non-interactive mode.
--adminemail=STRING   Email address for the moodle admin account.
--non-interactive     No interactive questions, installation fails if any
                      problem encountered.
--agree-license       Indicates agreement with software license,
                      required in non-interactive mode.
--allow-unstable      Install even if the version is not marked as stable yet,
                      required in non-interactive mode.
-h, --help            Print out this help

# clean up
rm -rf /data/moodle/sammy_moodle297/
rm -rf /data/moodle/sammy_behatdataroot297
rm -rf /data/moodle/sammy_behatdataroot2971/
php admin/tool/behat/cli/util.php --drop
DBUSER='mdluser_dev'
DBPASS='Mdl@dev1'
DBNAME='moodle_dev_20160802'
#mysql -A -u $DBUSER -p$DBPASS $DBNAME
#SHOW TABLES LIKE 'sammy\_moodle297\_%';
mysql -u $DBUSER -p$DBPASS --silent --skip-column-names -e "SHOW TABLES LIKE 'sammy\_moodle297\_%'" $DBNAME | xargs -L1 -I% echo 'DROP TABLE `%`;' | mysql -u $DBUSER -p$DBPASS -v $DBNAME
rm /data/apache/htdocs/sammybehat297
rm /data/apache/htdocs/sammymoodle297
rm -rf /data/apache/moodle-vhosts/sammy_moodle297/
#=

#New
mkdir /data/moodle/sammy_moodle310
chmod -R 777 /data/moodle/sammy_moodle310
mkdir /data/moodle/sammy_behat310
cd /data/apache/moodle-vhosts
git clone --branch MOODLE_31_STABLE https://github.com/moodle/moodle.git sammy_moodle310
cd sammy_moodle310
git reset --hard v3.1.0
cd admin/cli/
php install.php --lang=en \
--wwwroot='http://moodle-dev.ucl.ac.uk/sammymoodle310' \
--dataroot='/data/moodle/sammy_moodle310' \
--dbhost='localhost' \
--dbname='moodle_dev_20160802' \
--dbuser='mdluser_dev' \
--dbpass='Mdl@dev1' \
--prefix='sammy_moodle310_' \
--fullname='Sammy Moodle v3.1.0' \
--shortname='Sam v310' \
--summary='Instance to test settings. Will be deleted' \
--adminuser='admin' \
--adminpass='password' \
--adminemail='admin@noreply.net' \
--non-interactive \
--agree-license >> /data/apache/moodle-vhosts/sammy_moodle310_installation.txt
#
ln -s /data/apache/moodle-vhosts/sammy_moodle310 /data/apache/htdocs/sammymoodle310
ln -s /data/apache/moodle-vhosts/sammy_moodle310 /data/apache/htdocs/sammybehat310
#
cd /data/apache/moodle-vhosts/sammy_moodle310
vi config.php
#//for behat testing
require_once(dirname(__FILE__) . '/behat_settings.php');
#
vi behat_settings.php
<?php
$CFG->behat_prefix = 'sammy_behat310_';
$CFG->behat_dataroot = '/data/moodle/sammy_behatdataroot310';
$CFG->behat_wwwroot = 'http://moodle-dev.ucl.ac.uk/sammybehat310';
#
cd /data/apache/moodle-vhosts/sammy_moodle310
php admin/tool/behat/cli/init.php >> /data/apache/moodle-vhosts/sammy_behat310_installation.txt
vendor/bin/behat --config /data/moodle/sammy_behatdataroot310/behat/behat.yml --name='Log in as an existing admin user filling the form'
vendor/bin/behat --config /data/moodle/sammy_behatdataroot310/behat/behat.yml --name='Log in with the predefined admin user with Javascript disabled'
#@javascript
vendor/bin/behat --config /data/moodle/sammy_behatdataroot310/behat/behat.yml --name='Log in with the predefined admin user with Javascript enabled'

eval $(ssh-agent -s)
ssh-add ~/.ssh/ucl_desktop
ssh -L 3306:localhost:3306 ccspmdd@moodle-dev.ucl.ac.uk -f -N

#
https://moodle.ucl.ac.uk/pluginfile.php/1/theme_ucl/usepolicy/1442233325/UCL_Moodle_usage_policy.html

https://moodle.ucl.ac.uk/pluginfile.php/1/theme_ucl/usepolicy/1442233325/UCL_Moodle_usage_policy.html
#

##
git clone https://github.com/interconnectit/Search-Replace-DB.git searchandreplace
cd searchandreplace

php srdb.cli.php \
-h 'webapps-dev.ucl.ac.uk' \
-n 'blogs_dev_44_11Aug' \
-u 'wpmu_user' \
-p 'uOsKMENRTrNBFBp5' \
-s 'blogs-dev.ucl.ac.uk' \
-r 'blogs-dev.ucl.ac.uk/newblogs' \
> newblogs_search.txt

##
select * from wp_options where option_name='siteurl' or option_name='home';
update wp_options set option_value='http://blogs-dev.ucl.ac.uk/restore11082016' where option_name='siteurl';
update wp_options set option_value='http://blogs-dev.ucl.ac.uk/restore11082016' where option_name='home';

##
wp db export --add-drop-table ~/newblogs_working.sql

##
echo "create database restore default character set utf8 collate utf8_unicode_ci" | mysql -u 'mdluser_dev' -p'Mdl@dev1' 
echo "create database restore default character set utf8 collate utf8_unicode_ci" | mysql -u 'mdluser_uat' -p'Mdl@uat1' 

mysql -u 'mdluser_dev' -p'Mdl@dev1' restore < blogs11082016.sql

rm blogs11082016.sql

##
wp user get admin
wp user update 2 --user_pass=marypass

php srdb.cli.php \
-h 'webapps-dev.ucl.ac.uk' \
-n 'blogs_dev_44_11Aug' \
-u 'wpmu_user' \
-p 'uOsKMENRTrNBFBp5' \
-s 'blogs-dev.ucl.ac.uk' \
-r 'blogs-dev.ucl.ac.uk/newblogs' \
> newblogs_search.txt

php srdb.cli.php \
-h 'webapps-dev.ucl.ac.uk' \
-n 'blogs_dev_44_11Aug' \
-u 'wpmu_user' \
-p 'uOsKMENRTrNBFBp5' \
-s 'blogs-dev.ucl.ac.uk/newblogs' \
-r 'digipres.blogs-dev.ucl.ac.uk' \
> newblogs_search_12pm.txt

mysql -u wpmu_user -p'uOsKMENRTrNBFBp5' -h webapps-dev.ucl.ac.uk blogs_dev_44_11Aug

php srdb.cli.php \
-h 'webapps-dev.ucl.ac.uk' \
-n 'blogs_dev_44_11Aug' \
-u 'wpmu_user' \
-p 'uOsKMENRTrNBFBp5' \
-s 'blogs.ucl.ac.uk' \
-r 'digipres.blogs-dev.ucl.ac.uk' \
> newblogs_search_14pm.txt

sudo -u wwwrun php install.php --lang=en \
--wwwroot='http://localhost/~sammy/vanillamoodle' \
--dataroot='/home/sammy/vanillamoodle_data' \
--dbhost='localhost' \
--dbname='vaillamoodle' \
--dbuser='root' \
--dbpass='manga99' \
--prefix='vanillamoodle_' \
--fullname='Vanilla Moodle v0.0' \
--shortname='vMoodle' \
--summary='Vanilla instance to test things. Will be deleted' \
--adminuser='admin' \
--adminpass='password' \
--adminemail='admin@noreply.net' \
--non-interactive \
--agree-license 2>&1 > /home/sammy/vanillamoodle_installation.txt

## alternative to above
php admin/cli/install_database.php --lang=en \
--adminuser=admin \
--adminpass=Pass1234! \
--adminemail='admin@test.com' \
--agree-license \
--fullname='Vanilla Moodle v0.0' \
--shotname='vMoodle'
## end alternative

/usr/local/bin/sits_filter2_RunCmis.sh > /dev/null 2>&1 > run_cmis_import_$(date +"%d%b%Y_%H%M").txt
scp ccspmdl@moodle-admin.ucl.ac.uk:run_cmis_import_05Jan2017_1125.txt .

mysql -A -u 'moodleuser' -p'kw+2_nE,' moodle_archive_1516
mysql -A -u 'moodleuser' -p'kw+2_nE,' -P 3307 -h 127.0.0.1 moodle_archive_1516

php admin/cli/maintenance.php --enable
php admin/cli/maintenance.php --disable

#
# 'REFRESH' data on dev
rsync -vaz -e ssh ccspsql@moodle-db-b.ucl.ac.uk:/data/mysql/backup/mysqlbackup.dump.backup-20160917.gz .
rsync -vaz -e ssh ./mysqlbackup.dump.backup-20160917.gz ccspsql@moodle-dev.ucl.ac.uk:/data/mysql/backup

./copy_live_moodle_to_dev_from_last_backup-local.sh --skip-logs moodle_dev_17sep2016 moodle-dev.ucl.ac.uk ./mysqlbackup.dump.backup-20160917.gz
#
#update theme UCL
#******COMMENT OUT tHE FOLLOWING LINE
./ucl/style/settings.css:391:    background-color: #619eb6; #should be #4B7A8D !important
scp setting.css ccspmdl@moodle-{d,e,f,admin}.ucl.ac.uk:/data/apache/htdocs/moodle_v31/theme/ucl/style
scp setting.css ccspmdl@moodle-pp-{a,b,c}.ucl.ac.uk:/data/apache/htdocs/moodle_v31/theme/ucl/style
#

.jsenabled .usermenu .moodle-actionmenu.show {
    /*background-color: #e5e5e5;*/
    background-color: initial;
}
scp ccspmdl@moodle-d.ucl.ac.uk:/data/apache/htdocs/moodle_v31/theme/ucl/style/ucl.css ucl.css.back

scp ucl.css ccspmdl@moodle-d.ucl.ac.uk:/data/apache/htdocs/moodle_v31/theme/ucl/style
scp ucl.css ccspmdl@moodle-e.ucl.ac.uk:/data/apache/htdocs/moodle_v31/theme/ucl/style
scp ucl.css ccspmdl@moodle-f.ucl.ac.uk:/data/apache/htdocs/moodle_v31/theme/ucl/style
scp ucl.css ccspmdl@moodle-admin.ucl.ac.uk:/data/apache/htdocs/moodle_v31/theme/ucl/style
#
# remote desktop to my workstation
rdesktop -u \AD\cceamou -p 128.41.2.241
rdesktop -u cceamou -d AD -p 128.41.2.241
#
#log into 'cluster pc App' server
ccsplta@campusm-a.ucl.ac.uk
ccsplta@campusm-b.ucl.ac.uk
#
#update ucl_tools
scp index.php ccspmdl@moodle-d.ucl.ac.uk:/data/apache/htdocs/moodle_v31/ucl_tools
scp index.php ccspmdl@moodle-e.ucl.ac.uk:/data/apache/htdocs/moodle_v31/ucl_tools
scp index.php ccspmdl@moodle-f.ucl.ac.uk:/data/apache/htdocs/moodle_v31/ucl_tools
scp index.php ccspmdl@moodle-admin.ucl.ac.uk:/data/apache/htdocs/moodle_v31/ucl_tools

scp index.php ccspmdl@moodle-pp-a.ucl.ac.uk:/data/apache/htdocs/moodle_v31/ucl_tools
scp index.php ccspmdl@moodle-pp-b.ucl.ac.uk:/data/apache/htdocs/moodle_v31/ucl_tools
scp index.php ccspmdl@moodle-pp-c.ucl.ac.uk:/data/apache/htdocs/moodle_v31/ucl_tools
scp index.php ccspmdl@moodle-admin-pp.ucl.ac.uk:/data/apache/htdocs/moodle_v31/ucl_tools
#
# SCRIPT TO 'REFRESH' dev/uat WITH DATA FROM prod/live
15 2 4 10 * time /data/mysql/backup/copy_live_moodle.sh >> /data/mysql/backup/copy_live_moodle.log 2>&1
scp copy_live_moodle.sh ccspsql@moodle-dev.ucl.ac.uk:/data/mysql/backup
scp copy_live_moodle_from_file.sh ccspsql@moodle-dev.ucl.ac.uk:/data/mysql/backup

## /data/moodle/update_moodle_dev_database
#!/bin/bash
[[ -f /data/moodle/.name_of_last_moodle_database ]] || {
    echo No trace of a backup having run
    exit 1
}

source /data/moodle/.name_of_last_moodle_database
[[ -n $name_of_last_moodle_database ]] || {
    echo A new database has not been created
    exit 2
}

MOODLE_DIR="/data/apache/moodle-vhosts/moodle_31_develop/"
old_database=$("grep 'dbname' $MOODLE_DIR/local_settings.php" | grep '$LS->dbname' | cut -d"'" -f2)
[[ -n $old_database ]] || {
    echo could not pick up the name of the old database
    exit 3
}

if [[ $name_of_last_moodle_database == $old_database ]]; then {
    echo database is already the latest
    exit 4
}

#replace name of database in config file
sed -i s/${old_database}/${name_of_last_moodle_database}/g $MOODLE_DIR/local_settings.php
[[ $? == 0 ]] || {
echo Error replacing dev database
exit 5
}

echo
echo Name of database has been updated OK

#delete file with name of last database
rm /data/moodle/.name_of_last_moodle_database
[[ $? == 0 ]] || {
echo Error deleting the file \'.name_of_last_moodle_database\'
exit 6
}

#send mail to lta
cat /data/moodle/lta_email.txt<<EOF
Subject: data have been updated on moodle-dev - database name was changed

Name of current database: ${name_of_last_moodle_database}
Please check all is well and delete ${old_database}
EOF
sendmail lta-learning@ucl.ac.uk  < /data/moodle/lta_email.txt
rm /data/moodle/lta_email.txt

echo
echo "All done; script will terminate."
## add line below to cron
30 8 4 10 * time /data/moodle/update_moodle_dev_database >> /data/moodle/update_moodle_dev_database.log 2>&1
#=
# delete duplicate accounts for Digi Ed
#
scp duplicate_accounts.csv ccspsql@moodle-db-a.ucl.ac.uk:
ssh ccspsql@moodle-db-a.ucl.ac.uk
unset HISTFILE
mysql -u moodleuser -p'kw+2_nE,' moodle_live
tee /home/ccspsql/duplicate_accounts_output0.txt

DROP TABLE IF EXISTS `duplicate_accounts`;
CREATE TABLE `duplicate_accounts` (
  `username` varchar(100) NOT NULL DEFAULT ''
) CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Temporary table with the usernames of duplicate accounts';

mysqlimport -u moodleuser -p'kw+2_nE,' --columns=username  --local moodle_live  "$HOME/duplicate_accounts.csv"
select * from mdl_logstore_standard_log where userid in (select id from mdl_user where username in (select username from duplicate_accounts));
delete from mdl_user where username in (select username from duplicate_accounts);
describe mdl_logstore_standard_log;

scp ccspsql@moodle-db-a.ucl.ac.uk:/home/ccspsql/duplicate_accounts_output0.txt .
## on PP (pp and prod are different)##
scp duplicate_accounts.csv ccspsql@moodle-db-pp.ucl.ac.uk:
ssh -L 3305:localhost:3306 ccspsql@moodle-db-pp.ucl.ac.uk -f -N
mysql -u moodleuser -p'kw+2_nE,' -P 3305 -h 127.0.0.1 moodle_pp_20160715
tee /home/sammy/duplicate_accounts_output.txt
DROP TABLE IF EXISTS `duplicate_accounts`;
CREATE TABLE `duplicate_accounts` (
  `username` varchar(100) NOT NULL DEFAULT ''
) CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Temporary table with the usernames of duplicate accounts';
mysqlimport -u moodleuser -p'kw+2_nE,' --columns=username  --local moodle_pp_20160715  "$HOME/duplicate_accounts.csv"
'
Warning: Using a password on the command line interface can be insecure.
moodle_pp_20160715.duplicate_accounts: Records: 405  Deleted: 0  Skipped: 0  Warnings: 0
'
delete from mdl_user where username in (select username from duplicate_accounts);
'
Query OK, 353 rows affected (1 min 16.95 sec)
'
#
# run sits filter manually - 
#
time /usr/local/bin/sits_filter2_RunSits.sh > /dev/null 2>&1 > sammy_sistsfilter2_output_$(date +"%d%b%Y_%H%M").txt
scp ccspmdl@moodle-admin.ucl.ac.uk:sammy_sistsfilter2_output_10Oct2016_09591476089947.txt .

##
## search and replace in blogs' database
##
ssh ccsplta@wwwapps-a.ucl.ac.uk
cd /data/apache/vhost/live/blogs/Search-Replace-DB-master
php srdb.cli.php \
--host 'webapps-db.ucl.ac.uk' \
--name 'wordpress_mu_live' \
--user 'wpmu_user' \
--pass '4blg;wpmuklb' \
--search 'blogs.ucl.ac.uk/museums' \
--replace 'blogs.ucl.ac.uk/culture' \
--dry-run \
> blogs_replace_museums_culture_$(date +"%d%b%Y").txt
#
# prepare behat run for release v312
#
<?php
$CFG->behat_prefix = 'b31_';
$CFG->behat_dataroot = '/data/moodle/behatdataroot31';
$CFG->behat_wwwroot = 'http://moodle-dev.ucl.ac.uk/bb';
#
# export stored procedures in database sitsfilter/cmis
#
mysqldump --routines --no-create-info --no-data --no-create-db --skip-opt -h 127.0.0.1 -u sitsfilteruserp -p'TlTKaTC0cdnsUwPE9pL8' -P 3312 moodle_sits_management_2 > simpledump.sql
#
#tmux name session and window; then re attach
tmux new -s sammy -n refresh_db
#ctrl + b d #to dettach
tmux attach -t sammy
##
## search and replace blog's name
wp search-replace --url=http://blogs-uat.ucl.ac.uk/museums2culture 'http://blogs-uat.ucl.ac.uk/museums2culture' 'http://blogs-uat.ucl.ac.uk/culture' --dry-run | tee search_replace_$(date +"%d%b%Y")

####################
## DEMO 22
ssh -L 3306:localhost:3306 ccspmdd@moodle-dev.ucl.ac.uk -f -N
selenium
cd Downloads/sammy_moodle310/
vendor/bin/behat --config /home/sammy/Downloads/sammy_behat310/behat/behat.yml --tags @sam3 -f pretty
## DEMO 22

zypper in php5 php5-mysql apache2-mod_php5 php5-bcmath php5-bz2 php5-calendar php5-ctype php5-curl php5-dom php5-ftp php5-gd php5-gettext php5-gmp php5-iconv php5-imap php5-ldap php5-mbstring php5-mcrypt php5-odbc php5-openssl php5-pcntl php5-pgsql php5-posix php5-shmop php5-snmp php5-soap php5-sockets php5-sqlite php5-sysvsem php5-tokenizer php5-wddx php5-xmlrpc php5-xsl php5-zlib php5-exif php5-fastcgi php5-pear php5-sysvmsg php5-sysvshm


eval $(ssh-agent -s)
ssh-add ~/.ssh/ucl_desktop

sudo zypper in php5-openssl php5-phar
curl http://getcomposer.org/installer | php
mv composer.phar ~/bin/
ln -s /home/sammy/bin/composer.phar /home/sammy/bin/composer

### perso
ssh -L 127.0.0.1:9090:localhost:8080 ccspmdd@moodle-dev.ucl.ac.uk -f -N
######SSH SECTION ########################################
#moodle-dev
ssh -L 3304:localhost:3306 ccspsql@mysdb-01-d.adcom.ucl.ac.uk -f -N
#moodle-uat
ssh -L 3305:localhost:3306 ccspsql@mysdb-01-t.adcom.ucl.ac.uk -f -N
#
ssh -L 3307:localhost:3306 ccspsql@moodle-db-pp.ucl.ac.uk -f -N
#
ssh -L 3308:localhost:3306 ccspsql@moodle-db-a.ucl.ac.uk -f -N
## NEEDED FOR SITSFILTER2
ssh -L 3309:localhost:3306 ccspsql@moodle-db-a.ucl.ac.uk -f -N
#
ssh -L 3310:localhost:3306 ccspsql@moodle-db-b.ucl.ac.uk -f -N
## NEEDED FOR SITSFILTER2
ssh -L 3311:localhost:3306 ccspsql@moodle-db-b.ucl.ac.uk -f -N
#
ssh -L 3312:localhost:3306 ccspsql@moodle-snapshot-a.ucl.ac.uk -f -N
#
ssh -L 3313:localhost:3306 ccspmdu@moodle-test.ucl.ac.uk -f -N
## SITS FILTER 2 PP
#ssh -L 3320:localhost:3306 ccspsql@moodle-db-pp.ucl.ac.uk -f -N
#wordpress prod
ssh -L 3314:localhost:3306 ccspsql@webapps-db-a.ucl.ac.uk -f -N
#mahara dev
ssh -L 3315:localhost:3306 ccsplta@webapps-dev.ucl.ac.uk -f -N
#mahara uat
ssh -L 3316:localhost:3306 ccsplta@webapps-uat.ucl.ac.uk -f -N
#mahara prod
ssh -L 3317:localhost:3306 ccspsql@webapps-db.ucl.ac.uk -f -N
#opinio prod
ssh -L 3318:localhost:3306 ccspsql@webapps-db.ucl.ac.uk -f -N
#wiki prod
ssh -L 3319:localhost:3306 ccspsql@webapps-db.ucl.ac.uk -f -N
#------------------------------
#wordpress dev/uat wwwapps-uat
ssh -L 3320:localhost:3306 ccsplta@wwwapps-uat-mgmt.ucl.ac.uk -f -N
#opinio dev
ssh -L 3321:localhost:3306 ccsplta@opinio-dev.ucl.ac.uk -f -N
#opinio uat
ssh -L 3322:localhost:3306 ccsplta@opinio-uat.ucl.ac.uk -f -N
#wiki dev
ssh -L 3323:localhost:3306 ccsplta@wiki-dev.ucl.ac.uk -f -N
#wiki uat
ssh -L 3324:localhost:3306 ccsplta@wiki-uat.ucl.ac.uk -f -N
######END SSH SECTION ########################################
ssh -L 127.0.0.1:3304:localhost:3306 ccspsql@mysdb-01-d.adcom.ucl.ac.uk -f -N
ssh -L 127.0.0.1:3305:localhost:3306 ccspsql@mysdb-01-t.adcom.ucl.ac.uk -f -N
ssh -L 127.0.0.1:3307:localhost:3306 ccspsql@moodle-db-pp.ucl.ac.uk -f -N
ssh -L 127.0.0.1:3308:localhost:3306 ccspsql@moodle-db-a.ucl.ac.uk -f -N
ssh -L 127.0.0.1:3309:localhost:3306 ccspsql@moodle-db-a.ucl.ac.uk -f -N
ssh -L 127.0.0.1:3310:localhost:3306 ccspsql@moodle-db-b.ucl.ac.uk -f -N
ssh -L 127.0.0.1:3311:localhost:3306 ccspsql@moodle-db-b.ucl.ac.uk -f -N
ssh -L 127.0.0.1:3312:localhost:3306 ccspsql@moodle-snapshot-a.ucl.ac.uk -f -N
ssh -L 127.0.0.1:3313:localhost:3306 ccspmdu@moodle-test.ucl.ac.uk -f -N
ssh -L 127.0.0.1:3314:localhost:3306 ccspsql@webapps-db-a.ucl.ac.uk -f -N
ssh -L 127.0.0.1:3315:localhost:3306 ccsplta@webapps-dev.ucl.ac.uk -f -N
ssh -L 127.0.0.1:3316:localhost:3306 ccsplta@webapps-uat.ucl.ac.uk -f -N
ssh -L 127.0.0.1:3317:localhost:3306 ccspsql@webapps-db.ucl.ac.uk -f -N
ssh -L 127.0.0.1:3318:localhost:3306 ccspsql@webapps-db.ucl.ac.uk -f -N
ssh -L 127.0.0.1:3319:localhost:3306 ccspsql@webapps-db.ucl.ac.uk -f -N
ssh -L 127.0.0.1:3320:localhost:3306 ccsplta@wwwapps-uat-mgmt.ucl.ac.uk -f -N
ssh -L 127.0.0.1:3321:localhost:3306 ccsplta@opinio-dev.ucl.ac.uk -f -N
ssh -L 127.0.0.1:3322:localhost:3306 ccsplta@opinio-uat.ucl.ac.uk -f -N
ssh -L 127.0.0.1:3323:localhost:3306 ccsplta@wiki-dev.ucl.ac.uk -f -N
ssh -L 127.0.0.1:3324:localhost:3306 ccsplta@wiki-uat.ucl.ac.uk -f -N
ssh -L 127.0.0.1:3325:localhost:3306 ccspsql@moodle-db-pp.ucl.ac.uk -f -N
######END SSH SECTION ########################################
mysqldump -h 127.0.0.1 -u 'wpmu_user' -p'4blg;wpmuklb' -P 3314 wordpress_mu_live > wordpress_mu_live_$(date +"%Y%m%d").sql
mysql -h 'webapps-uat.ucl.ac.uk' -u 'wpmu_user' -p'uOsKMENRTrNBFBp5' -P 3306 -A blogs_uat_44
#
ssh -L 3307:localhost:3306 ccspsql@mysdb-01-t.adcom.ucl.ac.uk -f -N
mysqldump -u mdluser_uat -p'Mdl@uat1' -P 3307 -h 127.0.0.1 moodle_uat_20170215 > moodle_uat_20170215_backup.sql
#
select * FROM wp_513_options;
select * FROM wp_513_options WHERE option_name like 'ga_%';
describe wp_513_options;
update wp_513_options set option_value = NULL where option_name = 'ga_google_token';
#ga_google_token UA-92068987-1  
#ga_uid UA-XXXXXXXX-X
DELETE FROM wp_513_options WHERE option_name='ga_status' OR option_name='ga_disable_gasites' OR option_name='ga_analytic_snippet' OR option_name='ga_uid' OR option_name='ga_admin' OR option_name='ga_admin_disable' OR option_name='ga_admin_role' OR option_name='ga_dashboard_role' OR option_name='ga_adsense' OR option_name='ga_extra' OR option_name='ga_extra_after' OR option_name='ga_event' OR option_name='ga_outbound' OR option_name='ga_outbound_prefix' OR option_name='ga_enhanced_link_attr' OR option_name='ga_downloads' OR option_name='ga_downloads_prefix' OR option_name='ga_widgets' OR option_name='ga_annon' OR option_name='ga_defaults' OR option_name='ga_google_token' OR option_name='ga_google_authtoken' OR option_name='ga_profileid';
#04/09/2017 ~ 15:50  uclltateam@gmail.com  K%.a*WhK
DELETE FROM wp_options WHERE option_name='ga_status' OR option_name='ga_disable_gasites' OR option_name='ga_analytic_snippet' OR option_name='ga_uid' OR option_name='ga_admin' OR option_name='ga_admin_disable' OR option_name='ga_admin_role' OR option_name='ga_dashboard_role' OR option_name='ga_adsense' OR option_name='ga_extra' OR option_name='ga_extra_after' OR option_name='ga_event' OR option_name='ga_outbound' OR option_name='ga_outbound_prefix' OR option_name='ga_enhanced_link_attr' OR option_name='ga_downloads' OR option_name='ga_downloads_prefix' OR option_name='ga_widgets' OR option_name='ga_annon' OR option_name='ga_defaults' OR option_name='ga_google_token' OR option_name='ga_google_authtoken' OR option_name='ga_profileid';

###
qecho "create database moodle_vanilla312 default character set utf8 collate utf8_unicode_ci" | mysql -h 127.0.0.1 -u mdluser_dev -p'Mdl@dev1' -P 3304
mysql -h 127.0.0.1 -u mdluser_dev -p'Mdl@dev1' -P 3304 -A
mysql -h 127.0.0.1 -u mdluser_uat -p'Mdl@uat1' -P 3305 -A
mysql -h mysdb01-t.adcom.ucl.ac.uk -u mdluser_uat -p'Mdl@uat1' -A moodle_uat_20170215
mysql -h 127.0.0.1 -u 'sitsfilteruserp' -p'TlTKaTC0cdnsUwPE9pL8' -P 3309 -A moodle_sits_management_2
mysql -h 127.0.0.1 -u 'moodleuser' -p'kw+2_nE,' -P 3311 -A
mysql -h 127.0.0.1 -u 'moodleuser' -p'kw+2_nE,' -P 3310 -A moodle_live
mysql -h 127.0.0.1 -u 'moodleuser' -p'kw+2_nE,' -P 3307 -A
mysql -h 127.0.0.1 -u 'mahara' -p'wMXlZbznTukQ' -P 3315 -A
mysql -h 127.0.0.1 -u 'confluenceuser' -p'wikido11' -P 3319 -A confluence_live
mysqldump -h 127.0.0.1 -u 'confluenceuser' -p'wikido11' -P 3319 confluence_live > confluence_live.sql
mysql -u 'sitsfilteruser' -p'zvM9GhLCdZJ5VOSAgvmD'
#
mysqldump -h 127.0.0.1 -u 'moodleuser' -p'kw+2_nE,' -P 3310 moodle_live mdl_assignfeedback_editpdf_queue > mdl_assignfeedback_editpdf_queue.sql
#
ssh -L 127.0.0.1:3320:localhost:3306 ccspsql@mysdb-01-t.adcom.ucl.ac.uk -f -N
mysql -u mdluser_uat -p'Mdl@uat1' -h 127.0.0.1 -P 3320 -A moodle_uat_20170215
#mysql -u mdluser_uat -p'Mdl@uat1' -h mysdb-01-t.adcom.ucl.ac.uk moodle_uat_20170215
ssh -L 127.0.0.1:3321:localhost:3306 ccspsql@mysdb-01-d.adcom.ucl.ac.uk -f -N
mysql -u mdluser_dev -p'Mdl@dev1' -h mysdb-01-d.adcom.ucl.ac.uk -P 3320 -A moodle_dev_20170215
#
ssh -L 127.0.0.1:3310:localhost:3306 ccspsql@moodle-db-b.ucl.ac.uk -f -N
#
$PREFIX='bht_'
mysql -u mdluser_dev -p'Mdl@dev1' --silent --skip-column-names -e "SHOW TABLES" moodle_dev_20170215 | grep -i $PREFIX | xargs -L1 -I% echo 'DROP TABLE `%`;' | mysql -u mdluser_dev -p'Mdl@dev1' -v moodle_dev_20170215
########
ssh -L 9001:wwwapps-uat.ucl.ac.uk:22 ccspmdd@moodle-dev.ucl.ac.uk -f -N
ssh -p 9001 ccsplta@localhost
########

php admin/tool/behat/cli/util.php --enable > ../behat_enable_output.txt

php admin/tool/behat/cli/init.php > ../behat_init_output.txt

mysql -u mdluser_dev -p'Mdl@dev1' -P 3306 -h 127.0.0.1

vendor/bin/behat --config /home/sammy/Downloads/sammy_behat310/behat/behat.yml --name='Log in with the predefined admin user with Javascript disabled' -f pretty

vendor/bin/behat --config /home/sammy/Downloads/sammy_behat310/behat/behat.yml --name='Log in with the predefined admin user with Javascript enabled' -f pretty

vendor/bin/behat --config /home/sammy/Downloads/sammy_behat310/behat/behat.yml --name='Edit activity name in-place' -f pretty

vendor/bin/behat --config /home/sammy/Downloads/sammy_behat310/behat/behat.yml --name='Log in as an existing admin user filling the form' -f pretty

php admin/tool/behat/cli/util.php --enable
php admin/tool/behat/cli/init.php
vendor/bin/behat --config /home/sammy/Downloads/sammy_behat310/behat/behat.yml --tags @sam1 -f pretty
vendor/bin/behat --config /data/moodle/sammy_behatdataroot310/behat/behat.yml --tags @sam2 -f pretty

php admin/tool/behat/cli/init.php 2&>1 > ../sammy_moodle310_behat_init.txt
vendor/bin/behat --config /data/moodle/sammy_behatdataroot310/behat/behat.yml --tags @sam2

PATH=$PATH:/home/sammy/Downloads/bin


http://moodle-dev.ucl.ac.uk/sammymoodle310/login/index.php

java -jar selenium-server-standalone-3.0.0-beta2.jar -Dwebdriver.chrome.driver=/home/sammy/Downloads/bin/chromedriver
java -jar -Dwebdriver.chrome.driver=/home/sammy/Downloads/bin/chromedriver selenium-server-standalone-3.0.0-beta2.jar 

docker run --name myadmin -d -e PMA_HOST=127.0.0.1 -p 8080:80 phpmyadmin/phpmyadmin
chown -R root:root htdocs

$CFG->behat_profiles = array(
   'chrome' => array(
       'browser' => 'chrome',
       'tags' => '@javascript',
       'wd_host' => 'http://127.0.0.1:4444/wd/hub',
       'capabilities' => array(
           'platform' => 'Linux'
       )
   )
);

##selenium htmlunit
java -cp selenium-server-standalone-3.0.0-beta2.jar;htmlunit-driver-standalone-2.23.jar org.openqa.grid.selenium.GridLauncher <server options>

java -jar /home/sammy/Downloads/bin/selenium-server-standalone-3.0.0-beta2.jar &

##selenium phantomJS
1. Launch the grid server, which listens on 4444 by default: java -jar /path/to/selenium-server-standalone-<SELENIUM VERSION>.jar -role hub
2. Register with the hub: phantomjs --webdriver=8080 --webdriver-selenium-grid-hub=http://127.0.0.1:4444
3. Now you can use your normal webdriver client with http://127.0.0.1:4444 and just request browserName: phantomjs

LOGFILE=jenkins_log.log
java -jar jenkins.war --httpPort=$HTTP_PORT > $LOGFILE 2>&1
java -jar jenkins.war >> ~/jenkinslog.log 2>&1

#
https://moodle.org/mod/forum/discuss.php?d=327482
https://docs.moodle.org/dev/Assignment_Grading_UX

#
ssh -L 3305:localhost:3306 ccspsql@moodle-db-pp.ucl.ac.uk -f -N
mysql -u moodleuser -p'kw+2_nE,' -P 3305 -h 127.0.0.1 moodle_pp_20160715
tee /home/sammy/duplicate_accounts_output.txt
DROP TABLE IF EXISTS `duplicate_accounts`;
CREATE TABLE `duplicate_accounts` (
  `username` varchar(100) NOT NULL DEFAULT ''
) CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Temporary table with the usernames of duplicate accounts';
mysqlimport -u moodleuser -p'kw+2_nE,' --columns=username  --local moodle_pp_20160715  "$HOME/duplicate_accounts.csv"
'
Warning: Using a password on the command line interface can be insecure.
moodle_pp_20160715.duplicate_accounts: Records: 405  Deleted: 0  Skipped: 0  Warnings: 0
'
delete from mdl_user where username in (select username from duplicate_accounts);
'
Query OK, 353 rows affected (1 min 16.95 sec)
'
#
# refresh db
ssh ccspsql@moodle-dev.ucl.ac.uk
ssh ccspsql@moodle-uat.ucl.ac.uk
unset HISTFILE
scp ccspsql@moodle-db-b.ucl.ac.uk:/data/mysql/backup/mysqlbackup.dump.backup-20161014.gz .
. $HOME/.database_credentials
echo "drop database if EXISTS moodle_uat_20161014" | mysql -u $DB_USER -p$DB_PASSWORD
echo "create database moodle_uat_20161014 default character set utf8 collate utf8_unicode_ci" | mysql -u $DB_USER -p$DB_PASSWORD
sed -i '/INSERT INTO `mdl_logstore_standard_log`/d' moodle_live_20161014
mysql -u $DB_USER -p$DB_PASSWORD moodle_uat_20161014 < moodle_live_20161014 &
#
ssh ccsplta@webappsvm-a.ucl.ac.uk
wp search-replace --url=http://blogs-uat.ucl.ac.uk/museums2culture 'http://blogs-uat.ucl.ac.uk/museums2culture' 'http://blogs-uat.ucl.ac.uk/culture' --dry-run | tee search_replace_$(date +"%d%b%Y")

lta@Ucl!
####################
##begin merge indigo
#git fetch https://git.dcs.ucl.ac.uk/ccealan/wordpress-mu.git UCL_STABLE
git fetch git@git.dcs.ucl.ac.uk:ccealan/wordpress-mu.git refs/heads/UCL_STABLE
git checkout -b ccealan/wordpress-mu-UCL_STABLE FETCH_HEAD
#
git checkout UCL_STABLE
git merge --no-ff ccealan/wordpress-mu-UCL_STABLE
git push origin UCL_STABLE
##end merge indigo
##copy indigo without merging
#on uat
mv indigo indigo_renamed
#on workstation
cd wp-content/themes/
rsync -vaz -e ssh indigoyellow ccsplta@wwwapps-uat.ucl.ac.uk:/data/apache/vhost/uat/blogs/wp-content/themes
rsync -vaz -e ssh indigo ccsplta@wwwapps-uat.ucl.ac.uk:/data/apache/vhost/uat/blogs/wp-content/themes
##copy indigo without merging

tmux new -s sammy -n devops
#

#-- use moodle_dev_04Oct2016;
SET GROUP_CONCAT_MAX_LEN=10000;
SET @tbls = (SELECT GROUP_CONCAT(TABLE_NAME)
               FROM information_schema.TABLES
              WHERE TABLE_SCHEMA = 'moodle_dev_04Oct2016'
                AND TABLE_NAME LIKE 'behat_312_%');
SET @delStmt = CONCAT('DROP TABLE ',  @tbls);
PREPARE stmt FROM @delStmt;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
#

Acceptance tests environment enabled on http://moodle-dev.ucl.ac.uk/behat_v31, to run the tests use: 
vendor/bin/behat --config /data/moodle/behatdataroot_v31/behat/behat.yml --tags @tudor -f pretty
/data/moodle/behat_javascript/phantomjs-2.1.1-linux-x86_64/bin/phantomjs --webdriver=4444 &
#
ssh -L 8090:localhost:8080 ccspmdd@moodle-dev.ucl.ac.uk -N -f

## CMIS
SELECT * FROM `mapped_modules` where moodle_id = 12883
DELETE FROM `mapped_modules` WHERE moodle_id = 12883
--
SELECT * FROM `cmis_groupings_moodle` WHERE mdlcourseid = 12883
DELETE FROM `cmis_groupings_moodle` WHERE mdlcourseid = 12883 
--
SELECT * FROM `cmis_groupmembers_backup` WHERE courseid = 12883
DELETE FROM `cmis_groupmembers_backup` WHERE courseid = 12883 
--
SELECT * FROM `cmis_groupmembers_backup_old` WHERE courseid = 12883
DELETE FROM `cmis_groupmembers_backup_old` WHERE courseid = 12883 
--
SELECT * FROM `cmis_groupmembers_deleted` WHERE courseid = 12883
DELETE FROM `cmis_groupmembers_deleted` WHERE courseid = 12883 
--
SELECT * FROM `cmis_groups_course` WHERE courseid = 12883
DELETE FROM `cmis_groups_course` WHERE courseid = 12883 
--
SELECT * FROM `cmis_groups_course_backup` WHERE courseid = 12883
DELETE FROM `cmis_groups_course_backup` WHERE courseid = 12883 
--
SELECT * FROM `cmis_groups_moodle` WHERE mdlcourseid = 12883
DELETE FROM `cmis_groups_moodle` WHERE mdlcourseid = 12883 
--
SELECT * FROM `cmis_tutgroupmembers` WHERE courseid = 12883
DELETE FROM `cmis_tutgroupmembers` WHERE courseid = 12883 
--
SELECT * FROM `cmis_tutgroupmembers_backup` WHERE courseid = 12883
DELETE FROM `cmis_tutgroupmembers_backup` WHERE courseid = 12883 
--
SELECT * FROM `cmis_tutgroupmembers_deleted` WHERE courseid = 12883
DELETE FROM `cmis_tutgroupmembers_deleted` WHERE courseid = 12883 
--
DELETE FROM `mapped_modules` WHERE moodle_id = 32419;
DELETE FROM `cmis_groupings_moodle` WHERE mdlcourseid = 32419;
DELETE FROM `cmis_groupmembers_backup` WHERE courseid = 32419; 
DELETE FROM `cmis_groupmembers_backup_old` WHERE courseid = 32419; 
DELETE FROM `cmis_groupmembers_deleted` WHERE courseid = 32419; 
DELETE FROM `cmis_groups_course` WHERE courseid = 32419; 
DELETE FROM `cmis_groups_course_backup` WHERE courseid = 32419; 
DELETE FROM `cmis_groups_moodle` WHERE mdlcourseid = 32419; 
DELETE FROM `cmis_tutgroupmembers` WHERE courseid = 32419; 
DELETE FROM `cmis_tutgroupmembers_backup` WHERE courseid = 32419; 
DELETE FROM `cmis_tutgroupmembers_deleted` WHERE courseid = 32419; 
--
DELETE FROM `mapped_modules` WHERE moodle_id = 100739;
DELETE FROM `cmis_groupings_moodle` WHERE mdlcourseid = 100739;
DELETE FROM `cmis_groupmembers_backup` WHERE courseid = 100739; 
DELETE FROM `cmis_groupmembers_backup_old` WHERE courseid = 100739; 
DELETE FROM `cmis_groupmembers_deleted` WHERE courseid = 100739; 
DELETE FROM `cmis_groups_course` WHERE courseid = 100739; 
DELETE FROM `cmis_groups_course_backup` WHERE courseid = 100739; 
DELETE FROM `cmis_groups_moodle` WHERE mdlcourseid = 100739; 
DELETE FROM `cmis_tutgroupmembers` WHERE courseid = 100739; 
DELETE FROM `cmis_tutgroupmembers_backup` WHERE courseid = 100739; 
DELETE FROM `cmis_tutgroupmembers_deleted` WHERE courseid = 100739; 
##
#
tmux new -s sammy -n devops
tmux new -s sammy -n sql
unset HISTFILE
#gitlab, devops, fixed IP
i5-4570s @ 2.90GHz   4cores
ram 16GB
hdd 300GB
desktop@ucl

64 bit

server
ram 8GB
cpu 2
Intel(R) Xeon(R) CPU E5-2640 v3 @ 2.60GHz
cpu MHz         : 2596.992
cache size      : 20480 KB

3.6T  967G (1 TB)
Distributor ID: RedHatEnterpriseServer
Description:    Red Hat Enterprise Linux Server release 6.8 (Santiago)
Release:        6.8
Codename:       Santiago

hypervisor level access
even if vm within the vm
#
##change htaccess
##Backup up WordPress code and content
#define needed constants
NOW=$(date +"%Y%m%d")
rsync -vazh --exclude='.git' --exclude='*.sql' --exclude='wp-content/blogs.dir' ./ ./blogs_backup_${NOW}
## export blogs dev database
wp db export --add-drop-table ./wordpress_mu_uat_${NOW}.sql
wp plugin install jetpack --activate #--version=4.3.2  
##TESTING
#from the web interface
##change htaccess
##COMMIT CODE TO SVN REPO

# cmis database queries Tue 15/11/2016
delete FROM `cmis_groupmembers` WHERE courseid = 28055
delete FROM `cmis_groupmembers` WHERE courseid = 15138
update`cmis_groups_course` set todelete = 0 WHERE todelete = 1
DELETE FROM `mapped_modules` WHERE moodle_id = 28055
DELETE FROM `mapped_modules` WHERE moodle_id = 15138
#--#
#--#
zvM9GhLCdZJ5VOSAgvmD
moodle_uat_20161114
cd sits_filter2/app/
 ~/sits_filter2/lib/Cake/Console/cake RunSits runCronJob 2>&1 > ~/run_sits2_$(date +"%Y%m%d_%H%M").txt
mysql -u 'sitsfilteruser' -p'zvM9GhLCdZJ5VOSAgvmD' 

cat /usr/local/bin/sits_filter2_RunCmis.sh
# Run the SITS Filter 2 CMIS groups import process.
# To be executed each morning by cron (ccspmdl), e.g crontab entry:-
# 15  2  *  *  *  /usr/local/bin/sits_filter2_RunCmis.sh > /dev/null 2>&1
export PATH="$PATH:/usr/local/sits_filter2/lib/Cake/Console"
cd /usr/local/sits_filter2/app && cake RunSits runCronJob 2>&1 > ~/run_sits2_$(date +"%Y%m%d_%H%M").txt
#
# change frequency of scheduled tasks moodle-uat ########################
#
unset HISTFILE
tmux new -s sammy -n devops
#
grep 'client 10.0.112.240' /var/log/httpd/error_log


#for h in host1 host2 host3 host4 ; { scp file user@$h:/destination_path/ ; }
for target in a b c; {rsync -vaz --exclude='.git*' -e ssh moodle_gitlab/ ccspmdl@moodle-pp-$target.ucl.ac.uk:/data/apache/htdocs/moodle_v312 ;}

for HOST in a b c; do
    ssh ccspmdl@moodle-pp-$HOST.ucl.ac.uk "mv /data/apache/htdocs/moodle_v312 /data/apache/htdocs/moodle_v312_backup"
    rsync -vaz --exclude='.git*' -e ssh moodle_gitlab/ ccspmdl@moodle-pp-$HOST.ucl.ac.uk:/data/apache/htdocs/moodle_v312
    ssh ccspmdl@moodle-pp-$HOST.ucl.ac.uk "cp /data/apache/htdocs/moodle_v312_backup/local_settings.php /data/apache/htdocs/moodle_v312"
done

for HOST in admin; do
    ssh ccspmdl@moodle-$HOST-pp.ucl.ac.uk "mv /data/apache/htdocs/moodle_v312 /data/apache/htdocs/moodle_v312_backup"
    rsync -vaz --exclude='.git*' -e ssh moodle_gitlab/ ccspmdl@moodle-$HOST-pp.ucl.ac.uk:/data/apache/htdocs/moodle_v312
    ssh ccspmdl@moodle-$HOST-pp.ucl.ac.uk "cp /data/apache/htdocs/moodle_v312_backup/local_settings.php /data/apache/htdocs/moodle_v312"
done
#
[client 10.56.0.2]
# ********
ssh -f -N -R 9011:localhost:22 k5c56646@185.7.248.1
ssh k5c56646@185.7.248.1
ssh -p 9011 ccsplta@localhost
#k+R4MBxV
ssh -p 4873 -f -N -R 9001:localhost:22 digitalq@91.238.165.2
rsync -vaz -e 'ssh -p 4873' /home/sammy/.ssh/ucl_desktop digitalq@91.238.165.2:.ssh/
ssh -p 4873 digitalq@91.238.165.2
eval $(ssh-agent -s)
ssh-add ~/.ssh/ucl_desktop
ssh -p 9001 ccspmdd@localhost
unset HISTFILE
#
ssh -p 9001 ccspmdd@localhost "ssh -f -N -L 9002:localhost:22 ccspmdl@moodle-admin.ucl.ac.uk"
# **********

#**********************
# Apply Moodle patch mdl-56466: bling marking and group submission
#**********************
cd github_moodle/
git log --grep=56466
git show 65b4dce6f8b5f7541a8893dd08d673384fcb3581
#git format-patch 1b14f1a..65b4dce --stdout > ../mdl-56466.patch
git format-patch -1 65b4dce6f8b5f7541a8893dd08d673384fcb3581 --stdout > ../mdl-56466.patch
git diff 6e5f271..b3c1979 > ../mdl-56466.diff
#rsync -vaz -e ssh --exclude=".git*" moodle_gitlab/ ccspmdu@moodle-uat.ucl.ac.uk:/data/apache/moodle-vhosts/sammy_moodle312
#*** apply to prod ***
for HOST in d e f admin; do
    rsync -vaz -e ssh mdl-56466.* ccspmdl@moodle-$HOST.ucl.ac.uk:/data/apache/htdocs/moodle_v312
    ssh ccspmdl@moodle-$HOST.ucl.ac.uk "cd /data/apache/htdocs/moodle_v312 && patch mod/assign/gradingtable.php < mdl-56466.diff && rm mdl-56466.*"
done
# patch mdl-58182
git log --grep=58182
git format-patch -1 c5ed8046801aab0a1a48c2f5c44cf6fe970cf173 --stdout > ../mdl-58182.patch
git apply --stat mdl-58182.patch
git apply --check mdl-58182.patch
git apply mdl-58182.patch
#apply to prod
for HOST in d e f g admin; do
    rsync -vaz -e ssh mdl-58182.patch ccspmdl@moodle-$HOST.ucl.ac.uk:/data/apache/htdocs/moodle_v315
    ssh ccspmdl@moodle-$HOST.ucl.ac.uk "cd /data/apache/htdocs/moodle_v315 && git apply mdl-58182.patch && rm mdl-58182.patch"
done
rsync -vaz ccspmdl@moodle-f.ucl.ac.uk:/data/apache/htdocs/moodle_v315 .
cp mdl-58182.patch moodle_v315
cd moodle_v315
git apply mdl-58182.patch
rm mdl-58182.patch
cd ..
for HOST in d e f g admin; do
    ssh ccspmdl@moodle-$HOST.ucl.ac.uk "cd /data/apache/htdocs/moodle_v315 && rm mdl-58182.patch"
    rsync -vaz moodle_v315/ ccspmdl@moodle-$HOST.ucl.ac.uk:/data/apache/htdocs/moodle_v315
done
for HOST in a b c d; do
    rsync -vaz moodle_v315/ ccspmdl@moodle-pp-$HOST.ucl.ac.uk:/data/apache/htdocs/moodle_v315
done
rsync -vaz moodle_v315/ ccspmdl@moodle-admin-pp.ucl.ac.uk:/data/apache/htdocs/moodle_v315
#
scp ccspsql@webapps-db.ucl.ac.uk:/data/mysql/backup/mysqlbackup.dump.backup-20161126.gz .
scp ccspsql@webapps-db.ucl.ac.uk:/data/mysql/backup/mysqlbackup.dump.backup-20161127.gz .
#
#rsync -vaz -e ssh ccsplta@wwwapps-uat.ucl.ac.uk:/data/apache/vhost/uat/blogs/wp-content/themes/indigo/ indigo13dec2016
#rsync -vaz -e ssh ccsplta@wwwapps-uat.ucl.ac.uk:/data/apache/vhost/uat/blogs/wp-content/themes/indigoyellow/ indigoyellow13dec2016
git clone --branch UCL_STABLE git@git.dcs.ucl.ac.uk:ccealan/wordpress-mu.git ccealan_wordpress
cd ccealan_wordpress
git reset --hard b8f8bd30bd1d40a0c5a5e94644bcba4a49002b04
rsync -vaz wp-content/themes/indigo/ ../indigo13dec2016
rsync -vaz wp-content/themes/indigoyellow/ ../indigoyellow13dec2016
#
#+ rsync -vaz -e ssh ccspmdl@moodle-f.ucl.ac.uk:/data/apache/htdocs/moodle_v312/ moodle_f #get moodle@ucl
for HOST in a b c; do
    ssh ccspmdl@moodle-pp-$HOST.ucl.ac.uk "mv /data/apache/htdocs/moodle_v312 /data/apache/htdocs/moodle_v312_backup"
    rsync -vaz --exclude='.git*' -e ssh moodle_f/ ccspmdl@moodle-pp-$HOST.ucl.ac.uk:/data/apache/htdocs/moodle_v312
    ssh ccspmdl@moodle-pp-$HOST.ucl.ac.uk "cp /data/apache/htdocs/moodle_v312_backup/local_settings.php /data/apache/htdocs/moodle_v312"
done
for HOST in admin; do
    ssh ccspmdl@moodle-$HOST-pp.ucl.ac.uk "mv /data/apache/htdocs/moodle_v312 /data/apache/htdocs/moodle_v312_backup"
    rsync -vaz --exclude='.git*' -e ssh moodle_f/ ccspmdl@moodle-$HOST-pp.ucl.ac.uk:/data/apache/htdocs/moodle_v312
    ssh ccspmdl@moodle-$HOST-pp.ucl.ac.uk "cp /data/apache/htdocs/moodle_v312_backup/local_settings.php /data/apache/htdocs/moodle_v312"
done
ssh ccspmdu@moodle-uat.ucl.ac.uk "ls -lh /data/apache/moodle-vhosts/"
for HOST in uat; do
    rsync -vaz --exclude='.git*' -e ssh moodle_f/ ccspmdu@moodle-$HOST.ucl.ac.uk:/data/apache/moodle-vhosts/v3.1.2
    ssh ccspmdu@moodle-$HOST.ucl.ac.uk "cp /data/apache/moodle-vhosts/v31/local_settings.php /data/apache/moodle-vhosts/moodle_v312"
done
#
rsync -vaz -e ssh --exclude=".git*" \
--exclude=".svn*" \
--exclude="*.sql" \
--exclude="wp-content/blogs.dir" \
--exclude="wp-content/uploads" \
--exclude="wp-content/wptouch-data" \
ccsplta@wwwapps-a.ucl.ac.uk:/data/apache/vhost/live/blogs/ live_blogs
#
rsync -vaz -e ssh ccsplta@wwwapps-uat.ucl.ac.uk:/data/apache/vhost/uat/blogs/.htaccess htaccess_uat
rsync -vaz -e ssh ccsplta@wwwapps-a.ucl.ac.uk:/data/apache/vhost/live/blogs/.htaccess_live htaccess_live
diff htaccess_uat htaccess_live
#get sits_filter2 from server
rsync -vaz -e ssh ccspmdl@moodle-admin.ucl.ac.uk:/usr/local/sits_filter2/ sits_filter_from_server

#copy sits_filter2 to server - not all files
rsync -vaz -e ssh ./app/Console/Command/RunCmisShell.php \
ccspmdl@moodle-admin.ucl.ac.uk:/usr/local/sits_filter2/app/Console/Command

rsync -vaz -e ssh ./app/Controller/RestErrorHandlerController.php \
ccspmdl@moodle-admin.ucl.ac.uk:/usr/local/sits_filter2/app/Controller

rsync -vaz -e ssh ./app/Controller/MoodleRestClientController.php \
ccspmdl@moodle-admin.ucl.ac.uk:/usr/local/sits_filter2/app/Controller
#
scp ./app/Console/Command/RunCmisShell.php \
ccspmdl@moodle-admin.ucl.ac.uk:/usr/local/sits_filter2/app/Console/Command
scp ./app/Controller/SendEmailController.php \
ccspmdl@moodle-admin.ucl.ac.uk:/usr/local/sits_filter2/app/Controller
scp ./app/Locale/eng/LC_MESSAGES/default.po \
ccspmdl@moodle-admin.ucl.ac.uk:/usr/local/sits_filter2/app/Locale/eng/LC_MESSAGES
scp ./app/Console/Command/RunCmisShell.php \
ccspmdl@moodle-admin.ucl.ac.uk:/usr/local/sits_filter2/app/Console/Command
#

rsync -vaz -e ssh --exclude=".git*" \
--exclude=".svn*" \
--exclude="*.sql" \
--exclude="wp-content/blogs.dir" \
--exclude="wp-content/uploads" \
--exclude="wp-content/wptouch-data" \
ccsplta@wwwapps-uat.ucl.ac.uk:/data/apache/vhost/uat/blogs/ blogs_uat

rsync -vaz -e ssh \
--delete \
--exclude=".htaccess*" \
--exclude="robots.txt*" \
--exclude="wp-config.php" \
--exclude=".git*" \
--exclude=".svn*" \
--exclude="*.sql" \
--exclude="wp-content/blogs.dir" \
--exclude="wp-content/uploads" \
--exclude="wp-content/wptouch-data" \
blogs_live/ ccsplta@wwwapps-uat.ucl.ac.uk:/data/apache/vhost/uat/blogs
#
#Restore BLOGS UAT 03/01/2017
#
rsync -vaz --exclude=".git*" \
--delete \
--exclude="*.svn*" \
--exclude="*.sql" \
--exclude="wp-content/blogs.dir" \
--exclude="wp-content/uploads" \
--exclude="wp-content/wptouch-data" \
$HOME/blogs_uat_backup_${NOW}/ /data/apache/vhost/uat/blogs/

wp db import $HOME/blogs_uat_database_${NOW}.sql

cp .htaccess_live .htaccess
#
# CLEAN UP CMIS DB - typed in phpmyadmin 03/01/2017 at around 16:40 
DELETE FROM `cmis_groups_course` WHERE todelete =1
#  395 rows affected. (Query took 0.0225 seconds.)
#
# CLEAN UP CMIS DB - typed in phpmyadmin 05/01/2017 - pb with module/course PHOL2003
UPDATE `cmis_groups_course` SET toadd = 0 WHERE id = 111011
UPDATE `cmis_groups_course` SET toadd = 0 WHERE id = 111013
SELECT * FROM `cmis_groups_course` WHERE toadd = 1
# 05/01/2017 checkout/get sits_filter2 on svn
svn co --username=cceamou --force-interactive https://svn.ucl.ac.uk/repos/isd/moodle-sits-filter-2/trunk

###
for HOST in d e f admin db-a; do
    ssh ccspmdl@moodle-$HOST.ucl.ac.uk "bash -s" < ./server_cpu_stats.sh >> server_cpu_stats_$HOST.txt &
done

for HOST in a b c; do
    ssh ccspmdl@moodle-pp-$HOST.ucl.ac.uk "grep forbidden /var/log/httpd/error_log"
done
#
moodle-pp-a.ucl.ac.uk
ssh ccspmdl@moodle-pp-b.ucl.ac.uk
ssh ccspmdl@moodle-pp-c.ucl.ac.uk
unset HISTFILE
tail /var/log/httpd/error_log
grep forbidden /var/log/httpd/error_log
exit

# update mahara gitlab repo
rsync -vaz ccsplta@webapps-uat.ucl.ac.uk:/data/mahara-vhosts/v160404/ server_mahara_v160404
git clone git@git.dcs.ucl.ac.uk:lta/myportfolio.git myportfolio_git
cd myportfolio_git
git checkout UAT
cd ..
mv myportfolio_git/.git* server_mahara_v160404
cd server_mahara_v160404
git status
git add --all .
git commit -m "snapshot from uat server on `date`"
git push -u origin UAT
#
#
git checkout UCL_STABLE
cd ..
rm -rf myportfolio_git/
mv server_mahara_v160404 mahara_gitlab
rsync -vaz ccsplta@webappsvm-b.ucl.ac.uk:/data/apache/htdocs/mahara/v16.04.04/ live_mahara_v160404
mv mahara_gitlab/.git* live_mahara_v160404
cd live_mahara_v160404
git status
git add --all .
git commit -m "snapshot from PROD on `date`"
git push -u origin UCL_STABLE
#
rsync -vaz ccsplta@webappsvm-b.ucl.ac.uk:/data/apache/htdocs/mahara/mahara/lib/embeddedimage.php .
rsync -vaz embeddedimage.php ccsplta@webapps-uat.ucl.ac.uk:/data/mahara-vhosts/v160404/lib
rsync -vaz embeddedimage.php ccsplta@webapps-uat.ucl.ac.uk:/data/mahara-vhosts/v160405/lib
rsync -vaz embeddedimage.php ccsplta@webapps-dev.ucl.ac.uk:/data/mahara-vhosts/v1604/lib

rsync -vaz ccsplta@webappsvm-b.ucl.ac.uk:/data/apache/htdocs/mahara/mahara/theme/default/images/site-logo.png .
rsync -vaz site-logo.png ccsplta@webapps-uat.ucl.ac.uk:/data/mahara-vhosts/v160404/theme/default/images
rsync -vaz site-logo.png ccsplta@webapps-uat.ucl.ac.uk:/data/mahara-vhosts/v160405/theme/default/images
rsync -vaz site-logo.png ccsplta@webapps-dev.ucl.ac.uk:/data/mahara-vhosts/v1604/theme/default/images
#
cd myportfolio
git reset config.php
git rm --cached config.php
git commit -m "Try to get rid of secrets"
git push
cd ..
git clone --mirror git@git.dcs.ucl.ac.uk:lta/myportfolio.git
java -jar ./bfg-1.12.14.jar --delete-files config.php myportfolio.git
cd myportfolio.git
git reflog expire --expire=now --all && git gc --prune=now --aggressive
git push

rsync -vaz ccsplta@webappsvm-b.ucl.ac.uk:/data/apache/htdocs/mahara/v16.04.04/ prod_v16.04.04
rsync -vaz sammy_prod_v16.04.04 ccsplta@webapps-uat.ucl.ac.uk:/data/mahara-vhosts

## wordpress update plan 22/02/2017
# issues: can work only within one directory, hasn't got enough permissions on subdirectories to backup/restore or modify them if needed
# hasn't got enough permissions therefore file attributes change when copy new files
#can't create a 'top level' directory to do temporary work. can't rename old directory to replace with updated code.

# https://premium.wpmudev.org/blog/ultimate-guide-updating-wordpress-multisite/?utm_expid=3606929-97.J2zL7V7mQbSNQDPrXwvBgQ.0&utm_referrer=https%3A%2F%2Fwww.google.co.uk%2F
##
ssh ccsplta@wwwapps-a.ucl.ac.uk
path_to_blog="/data/apache/vhost/live/blogs"
BACKUP_FOLDER='/data/ccsplta'
#enable maintenance mode
cd $path_to_blog
cp .htaccess .htaccess_live
cp .htaccess-maint .htaccess
#Ask the DBAs to backup the db
#backup code
rsync -vaz \
--exclude=".git*" \
--exclude=".svn*" \
--exclude="*.sql" \
--exclude="wp-content/blogs.dir" \
--exclude="wp-content/uploads" \
--exclude="wp-content/wptouch-data" \
${path_to_blog}/ $BACKUP_FOLDER/blogs_backup_${NOW}
#deactivate all plugins
mv wp-content/plugins wp-content/plugins.hold
#delete some of current wordpress files
cd $path_to_blog
rm wp*.php readme.html wp.php xmlrpc.php license.txt
rm -rf wp-admin
mv wp-includes/languages .
rm -rf wp-includes
rm -rf wp-content/cache
rm -rf wp-content/plugins/widgets
#Download and extract the WordPress package
cd $path_to_blog
mkdir new_release 
cd new_release
wget https://wordpress.org/wordpress-4.7.2.tar.gz
tar --strip-components=1 -xvf wordpress-4.7.2.tar.gz -C .
mv wp-admin $path_to_blog
mv wp-includes $path_to_blog
mv $path_to_blog/languages $path_to_blog/wp-includes/
rsync -vaz ./wp-content $path_to_blog/wp-content
#look at the wp-config-sample.php file, 
#to see if any new settings have been introduced that you might want to add to your own wp-config.php

#visit  http://example.com/wordpress/wp-admin/upgrade.php

#activate plugins after upgrade
cd $path_to_blog
mv wp-content/plugins.hold wp-content/plugins

## cluster pc
cluster pc gend
CLUSTERPCMGR
cpcd7911
d5.adcom.ucl.ac.uk:4032:4031

cluster pc all
uclusers-dc3.uclusers.ucl.ac.uk
3268
cceamou@live.ucl.ac.ukk

all clusters
OU=Cluster,OU=Managed,DC=ucldpts,DC=ucl,DC=ac,DC=uk
(objectClass=computer)

ucl43
OU=UCL43,OU=Cluster,OU=Managed,DC=ucldpts,DC=ucl,DC=ac,DC=uk
(objectClass=computer)

grep -nr "m.shetye@ucl.ac.uk" .
grep -nr "jo.matthews@ucl.ac.uk" .
##

## portico unenrol michael barlow
PHAS3334: Interstellar Physics
2543
SELECT * FROM mdl_enrol WHERE courseid = 2543

44655
SELECT u.id, u.username, u.firstname, u.lastname, u.email, e.id as EnrolmentIDRecord , e.status, e.enrolid, e.userid, ep.id, ep.enrol, c.id,
 c.fullname, c.shortname, c.idnumber as CourseIDNumber
FROM mdl_user u, mdl_user_enrolments e, mdl_enrol ep, mdl_course c 
WHERE u.id = e.userid
AND ep.id = e.enrolid
AND e.enrolid = 44655
AND c.id = ep.courseid
AND ep.courseid = 2543
ORDER BY u.lastname asc, u.firstname asc

2249855
DELETE FROM mdl_user_enrolments
WHERE enrolid = '44655'
AND id = '2249855';

1 row affected. (Query took 0.0373 seconds.)
##
{userlister:groups=confluence-users|online=true} 
mysql -u confluenceuser -pwikido11 -h webapps-db.ucl.ac.uk
SELECT CONTENTID FROM CONTENT WHERE TITLE = 'live log in' AND VERSION = '1';
62806495
https://wiki.ucl.ac.uk/pages/editpage.action?pageId=62806495
##
30381
SELECT * FROM `mdl_turnitintooltwo_parts`where turnitintooltwoid = 30381
course
38027
##
$ docker run --name digi-mysql -e MYSQL_ROOT_PASSWORD=manga999 -d mysql:5.7
#
./clusterpc-datastore/src/main/resources/cpadatastoreLIVE.properties:131:email.sent.cc = isd.cps-infrastructureteam@ucl.ac.uk
./clusterpc-datastore/src/main/resources/cpadatastoreUAT.properties:128:email.sent.cc = isd.cps-infrastructureteam@ucl.ac.uk
#
rsync -vaz -e ssh ccspmdl@moodle-f.ucl.ac.uk:/data/apache/htdocs/moodle/report/myfeedback/ myfeedback_prod
## check trailing backslash # scp -rp ccspmdl@moodle-f.ucl.ac.uk:/data/apache/htdocs/moodle/report/myfeedback/ myfeedback_prod ## recursive preserve

##myfeedback bug -- search
<div class=\"available-grade t-rel off\">
gi.grademax
$record->highestgrade
$availablegrade
$this->mod_is_available("turnitintool")
gi.grademax
rsync -vaz ccspmdu@moodle-uat.ucl.ac.uk:/data/apache/moodle-vhosts/v314/report/myfeedback . 
rsync myfeedback/lib.php ccspmdu@moodle-uat.ucl.ac.uk:/data/apache/moodle-vhosts/v314/report/myfeedback
cd myfeedback && rsync ccspmdu@moodle-uat.ucl.ac.uk:/data/apache/moodle-vhosts/v315/report/myfeedback/lib.php .
# ldap user sync
php auth/ldap/cli/sync_users.php -d log_errors=1 -d error_reporting=E_ALL -d display_errors=1 -d html_errors=0 #-d momory_limit=256M
select * from user where timecreated > unix_timestamp('2017/03/20 00:00')
# change mahara_user password
mysql -u mahara_user -p'wMXlZbznTukQ'
set password for 'mahara_user'@'localhost' = PASSWORD('tpWQbwVULuWD');
mysql -u mahara_user -p'tpWQbwVULuWD'
#
git clone https://cceamou:"D'ontruntheadventure,,"@git.dcs.ucl.ac.uk/lta/moodle.git sammy_moodle

rsync -vaz ccspmdl@moodle-d.ucl.ac.uk:/data/apache/htdocs/moodle_v315/ moodle_d
rsync -vaz ccspmdl@moodle-pp-a.ucl.ac.uk:/data/apache/htdocs/moodle_v315/ moodle_pp_a
rsync -vaz --exclude=".git*" ccspmdd@moodle-dev-a.ucl.ac.uk:/data/moodle/tudor/sammy_moodle/ moodle_gitlab_v315
#
ssh ccspmdl@moodle-pp-a
unset HISTFILE
tail -f /var/log/httpd/error_log
####
# Laurie's merge request - merge to ucl_stable
git checkout -b ccealan/wordpress-mu-UCL_STABLE FETCH_HEAD
git checkout UCL_STABLE
git merge --no-ff ccealan/wordpress-mu-UCL_STABLE
#backup uat
cd wp-content/themes
tar cvzf indigo.tar.gz indigo
tar cvzf indigoyellow.tar.gz indigoyellow
# from own worstation copy code to uat
cd wp-content/themes
rsync -vaz \
--delete \
indigo ccsplta@wwwapps-uat.ucl.ac.uk:/data/apache/vhost/uat/blogs/wp-content/themes 
# copy indigoyellow to uat
rsync -vaz \
--delete \
indigoyellow ccsplta@wwwapps-uat.ucl.ac.uk:/data/apache/vhost/uat/blogs/wp-content/themes 
#
####
for HOST in  d e f g admin; do
    ssh ccspmdl@moodle-$HOST.ucl.ac.uk "cd /data/apache/htdocs/moodle/blocks/portico_enrolments && cp portico_enrolments_form.php portico_enrolments_form.php.back && vi +':x ++ff=unix' portico_enrolments_form.php"
    ssh ccspmdl@moodle-$HOST.ucl.ac.uk "cd /data/apache/htdocs/moodle/blocks/portico_enrolments && cp html/tablehtml.phtml html/tablehtml.phtml.back && vi +':x ++ff=unix' html/tablehtml.phtml"
done
#
rsync -vaz ccspmdl@moodle-e.ucl.ac.uk:/data/apache/htdocs/moodle/blocks/portico_enrolments/portico_enrolments_form.php .
rsync -vaz ccspmdl@moodle-e.ucl.ac.uk:/data/apache/htdocs/moodle/blocks/portico_enrolments/html/tablehtml.phtml .
for HOST in  a b c d; do
    rsync -vaz portico_enrolments_form.php ccspmdl@moodle-pp-$HOST.ucl.ac.uk:/data/apache/htdocs/moodle/blocks/portico_enrolments/
    rsync -vaz tablehtml.phtml ccspmdl@moodle-pp-$HOST.ucl.ac.uk:/data/apache/htdocs/moodle/blocks/portico_enrolments/html/
done
##
#moodle-test
mysql -u mdluser_test -p'Mdl@tst1' -A moodle_315_03052017
select username from phpu_user;
#local admin password
Lt4!le4rning

#
# myfeedback bug - deploy new lib.php 16/05/2017
#
cd ~/Downloads/repos/myfeedback_gitlab/report/myfeedback
for HOST in d e f g admin; do
    ssh ccspmdl@moodle-$HOST.ucl.ac.uk "cd /data/apache/htdocs/moodle_v315/report/myfeedback && rsync -vaz lib.php lib.php.bak"
    rsync -vaz lib.php ccspmdl@moodle-$HOST.ucl.ac.uk:/data/apache/htdocs/moodle_v315/report/myfeedback
done
#PP #############################
for HOST in a b c d; do
    ssh ccspmdl@moodle-pp-$HOST.ucl.ac.uk "cd /data/apache/htdocs/moodle_v315/report/myfeedback && cp lib.php lib.php.bak"
    rsync -vaz lib.php ccspmdl@moodle-pp-$HOST.ucl.ac.uk:/data/apache/htdocs/moodle_v315/report/myfeedback
done
ssh ccspmdl@moodle-admin-pp.ucl.ac.uk "cd /data/apache/htdocs/moodle_v315/report/myfeedback && cp lib.php lib.php.bak"
rsync -vaz lib.php ccspmdl@moodle-admin-pp.ucl.ac.uk:/data/apache/htdocs/moodle_v315/report/myfeedback
#delete .bak file ################
for HOST in d e f g admin; do
    ssh ccspmdl@moodle-$HOST.ucl.ac.uk "rm /data/apache/htdocs/moodle_v315/report/myfeedback/lib.php.bak"
done
for HOST in a b c d; do
    ssh ccspmdl@moodle-pp-$HOST.ucl.ac.uk "rm /data/apache/htdocs/moodle_v315/report/myfeedback/lib.php.bak"
done
ssh ccspmdl@moodle-admin-pp.ucl.ac.uk "rm /data/apache/htdocs/moodle_v315/report/myfeedback/lib.php.bak"
#
#
scp ccsptc3@campusm-a:/data/ccsptc3/jobs/logs/cpa_datstoreERROR.log .
scp ccsptc3@campusm-a:/data/ccsptc3/jobs/logs/cpa_datstore.log .
#
svn co --username=cceamou --force-interactive https://svn.ucl.ac.uk/repos/isd/cluster-pc-availability/database-scripts/
##
##
unset HISTFILE
mysql -h 127.0.0.1 -u mdluser_dev -p'Mdl@dev1' -A moodle_dev_20170215
show processlist;
show status like '%onn%';
mysqladmin status  -h 127.0.0.1 -u mdluser_dev -p'Mdl@dev1' 
show processlist;
+--------+-------------+-----------------+---------------------+---------+------+--------------+------------------------------------------------------------------------------------------------------+
| Id     | User        | Host            | db                  | Command | Time | State        | Info                                                                                                 |
+--------+-------------+-----------------+---------------------+---------+------+--------------+------------------------------------------------------------------------------------------------------+
| 106121 | mdluser_dev | localhost       | moodle_dev_20170215 | Query   |  845 | Sending data | SELECT e.id, e.username
                  FROM mdl_tmp_extuser e
                  LEFT JOIN mdl_use |
| 106129 | mdluser_dev | localhost:34300 | moodle_dev_20170215 | Query   |    0 | init         | show processlist                                                                                     |
+--------+-------------+-----------------+---------------------+---------+------+--------------+------------------------------------------------------------------------------------------------------+
#

php auth/ldap/cli/sync_users.php -d log_errors=1 -d error_reporting=E_ALL -d display_errors=1 -d html_errors=0 #-d momory_limit=256M

scp -pv ccspmdd@moodle-dev:/data/apache/moodle-vhosts/v315/auth/ldap/auth.php .
scp -pv ccspmdd@moodle-dev:/data/apache/moodle-vhosts/v315/auth/ldap/cli/sync_users.php .

scp auth.php ccspmdd@moodle-dev:/data/apache/moodle-vhosts/v315/auth/ldap/
scp sync_users.php ccspmdd@moodle-dev:/data/apache/moodle-vhosts/v315/auth/ldap/cli/

#
select * from mdl_config where name like "%theme%";
select * from mdl_config where name like "%ucl%";
select id, plugin, name, value from mdl_config_plugins where plugin like "%theme_ucl%" limit 9;

vi /data/opinio/production/WEB-INF/opinio.properties
#/usr/share/texmf/fonts/truetype/public/arialuni.ttf
/data/opinio/production/WEB-INF/classes/fonts/LiberationSans-Regular.ttf
sudo service tomcat7-opinio restart
#ir+4-#B.@56tu..f5t,[(]
41801
#CR00001162

rsync -vaz ccspmdd@moodle-dev /data/mysql/backup/sm_copy_live_moodle_from_file.sh .

echo  "SELECT username, email FROM mdl_user WHERE username REGEXP '(moodl|trail)[[:digit:]]{1,2}';" | mysql -h 127.0.0.1 -u 'moodleuser' -p'kw+2_nE,' -P 3310 -A moodle_live
moosh cache-clear
moosh config-plugins theme_ucl
moosh config-set name value <plugin>
moosh config-set debug 32767
moosh config-set logo http://example.com/logo.png theme_sky_high
moosh debug-off
moosh debug-on
moosh event-list
moosh module-config set dropbox dropbox_secret 123
moosh user-mod --email my@email.com --password newpwd admin
moosh user-mod -i --auth manual 17 20 22
moosh user-mod --email my@email.com --password newpwd --auth manual --all
moosh sql-run "update {user} set country='PL'"
select * from mdl_config_plugins where plugin like "%theme_ucl%"
usepolicy marketing1image marketing2image marketing3image marketing4image useanalytics analyticsid

https://confluence.atlassian.com/doc/restore-passwords-to-recover-admin-user-rights-158390.html
#
sudo service tomcat7-wiki restart
https://wiki.ucl.ac.uk/plugins/servlet/confluence/placeholder/macro-heading?definition=e2NvZGU6bGFuZ3VhZ2U9YmFzaH0&locale=en_GB&version=2
e2NvZGU6bGFuZ3VhZ2U9YmFzaH0
https://wiki-uat.ucl.ac.uk/plugins/servlet/confluence/placeholder/macro?definition=e3Jzczp1cmw9YmJjLmNvLnVrfQ&locale=en_GB&version=2
e3Jzczp1cmw9YmJjLmNvLnVrfQ
unset HISTFILE
rsync -vaz ccspsql@webapps-db-a:/data/mysql/backup/mysqlbackup.dump.backup-20170614.gz .
ssh -L 127.0.0.1:3319:localhost:3306 ccspsql@webapps-uat.ucl.ac.uk -f -N
mysql -h 127.0.0.1 -u 'confluenceuser' -p'wikido11' -P 3319 -A confluence_uat_575
mysqldump -h 127.0.0.1 -u 'confluenceuser' -p'wikido11' -P 3319 confluence_uat_575 > confluence_uat_575.sql
#
ssh ccsptc3@campusm-a
unset HISTFILE
clear
cd /data/ccsptc3/jobs/CPA
ll -h
rsync -vaz clusterpc_datastore.jar ~/sammy_tmp/
cd ~/sammy_tmp/
jar tf clusterpc_datastore.jar
jar xf clusterpc_datastore.jar cpadatastore.properties
#jar xf clusterpc_datastore.jar ad/adLookUp.properties
vi cpadatastore.properties
#vi ad/adLookUp.properties
jar uf clusterpc_datastore.jar cpadatastore.properties
#jar uf clusterpc_datastore.jar ad/adLookUp.properties
cd /data/ccsptc3/jobs/CPA
ps aux |grep java
kill -9 612
NOW=$(date +"%Y-%m-%d")
mv clusterpc_datastore.jar clusterpc_datastore.jar.$NOW
rsync -vaz ~/sammy_tmp/clusterpc_datastore.jar .
#rm clusterpc_datastore.jar.$NOW
sh CPABatch.sh
##
moosh config-set sessioncookie ucl_devxxxxxx
#
moosh config-set sesskey ZJtr2016_17
moosh config-set marketing4image '' theme_ucl
moosh config-set usepolicy '' theme_ucl
moosh config-set marketing3image '' theme_ucl
moosh config-set marketing2image '' theme_ucl
moosh config-set marketing1image '' theme_ucl
#
moosh config-set accountid '<test account>' turnitintooltwo
moosh config-set secretkey '<in KeePass>' turnitintooltwo
#
unset HISTFILE
DB_USER='moodle_xxx' 
DB_PASSWORD='<in keepass>' 
DB_NAME='moodle_xxx'
#
echo "UPDATE mdl_config_plugins  SET `value` = ''  WHERE `plugin` =  'theme_ucl' AND ` name ` =  'usepolicy' ;" | mysql -u $DB_USER -p${DB_PASSWORD} -v $DB_NAME
echo "UPDATE mdl_config_plugins  SET `value` =  '' WHERE `plugin` =  'theme_ucl' AND ` name ` =  'marketing1image' ;" | mysql -u $DB_USER -p${DB_PASSWORD} -v $DB_NAME
echo "UPDATE mdl_config_plugins  SET `value` = ''  WHERE `plugin` =  'theme_ucl' AND ` name ` =  'marketing2image' ;" | mysql -u $DB_USER -p${DB_PASSWORD} -v $DB_NAME
echo "UPDATE mdl_config_plugins  SET `value` =  '' WHERE `plugin` =  'theme_ucl' AND ` name ` =  'marketing3image' ;" | mysql -u $DB_USER -p${DB_PASSWORD} -v $DB_NAME
echo "UPDATE mdl_config_plugins  SET `value` =  '' WHERE `plugin` =  'theme_ucl' AND ` name ` =  'marketing4image' ;" | mysql -u $DB_USER -p${DB_PASSWORD} -v $DB_NAME
##
rsync -vaz ccspmdl@moodle-snapshot-a:/data/apache/htdocs/moodle-docker/15-16/local_settings.php 15-16/
#rsync -vaz ccspmdl@moodle-snapshot-a:/data/apache/htdocs/moodle-docker/15-16/config.php 15-16/
rsync -vaz ccspmdl@moodle-f:/data/apache/htdocs/moodle/ moodle_f_for_snap 
#edit old local_settings, config - copy to moodle_f
rsync -vaz moodle_f_for_snap/ ccspmdl@moodle-snapshot-a:/data/apache/htdocs/moodle-docker/16-17/
# ssh ccspmdl@moodle-snapshot-a
mkdir /data/moodle/16-17
chmod -R 777 /data/moodle/16-17
#
git clone git@git.dcs.ucl.ac.uk:lta/moodle-snapshot.git
cd moodle-snapshot
git branch -a
git remote -v
git status
git checkout branch_15-16
git checkout -b branch_16-17
#edit gitignore
cd ..
mv moodle-snapshot/.git* moodle_f_for_snap/
cd moodle_f_for_snap
git status
git add --all .
git commit -m "Moodle snapshot 16-17. Created from moodle-f on `date`"
git tag -a snapshot.16-17 -m "Moodle snapshot 16-17"
git push -u origin branch_16-17
git push origin --tags
##
rsync -vaz ccspmdl@moodle-snapshot-a:/data/apache/htdocs/moodle-docker/16-17 .

SELECT * FROM `moodle_sits_management_dev2`.`mapped_modules` where mapping_action = 'RMV'; 
/* Affected rows: 0  Found rows: 1,252  Warnings: 0  Duration for 1 query: 0.047 sec. (+ 0.032 sec. network) */
SELECT * FROM `moodle_sits_management_dev2`.`mapped_departments` where mapping_action = 'RMV';
/* Affected rows: 0  Found rows: 49  Warnings: 0  Duration for 1 query: 0.016 sec. */
SELECT * FROM `moodle_sits_management_dev2`.`mapped_programmes` where mapping_action = 'RMV'; 
/* Affected rows: 0  Found rows: 54  Warnings: 0  Duration for 1 query: 0.000 sec. */
SELECT * FROM `moodle_sits_management_dev2`.`mapped_routes` where mapping_action = 'RMV'; 
/* Affected rows: 0  Found rows: 32  Warnings: 0  Duration for 1 query: 0.000 sec. */
-- SELECT * FROM `moodle_sits_management_dev2`.`mapped_faculties` where mapping_action = 'RMV'; 
#
https://v315.moodle-dev.ucl.ac.uk/pluginfile.php/1/tool_generator/testplan/0/testplan_201707061133_3757.jmx
https://v315.moodle-dev.ucl.ac.uk/pluginfile.php/1/tool_generator/users/0/users_201707061133_5578.csv
$CFG->tool_generator_users_password = "=sammySecurePassword!";
php admin/tool/generator/cli/maketestcourse.php --size S --shortname jmeter_test_course --fullname "jmeter test course"
php admin/tool/generator/cli/maketestplan.php --size S --shortname jmeter_test_course
#
rsync -vaz ccsplta@webappsvm-a:/data/confluence/confluence.cfg.xml .
scp -p ccsplta@webappsvm-a:/data/confluence/confluence.cfg.xml .
scp -p ccsplta@webappsvm-a:/data/confluence/logs/atlassian-confluence.log .
rsync -vaz ccsplta@webappsvm-a:/data/confluence/export/Confluence_support_2017-07-14-05-49-44.zip .
#
grep -nr "uclusers.ucl.ac.uk" .
./ClusterLDAP/src/main/resource/clustermaint.props:4:forest.server=ldap://uclusers-dc3.uclusers.ucl.ac.uk:3268
./clusterpc-datastore/trunk/src/main/resources/ad/adLookUp.properties:4:forest.server=ldap://uclusers-dc3.uclusers.ucl.ac.uk:3268
#
#SNAPSHOT 16-17. Banner
git clone -b branch_16-17 --single-branch git@git.dcs.ucl.ac.uk:lta/moodle-snapshot.git
scp moodle-snapshot/theme/ucl/pix/banner.jpg ccspmdl@moodle-snapshot-a:/data/apache/htdocs/moodle-docker/16-17/theme/ucl/pix/
#sql role add ===========================================================
ssh -L 127.0.0.1:3308:localhost:3306 ccspsql@moodle-snapshot-a.ucl.ac.uk -f -N
mysql -h 127.0.0.1 -u 'moodleuser' -p'kw+2_nE,' -P 3308 -A moodle_archive_1617

select id,name,shortname from mdl_role;

--
--  Assign every student to the read-only role (in addition to their other roles).
--
-- create temporary table
drop table if exists temp_role_assignments;
create table temp_role_assignments like mdl_role_assignments;
-- insert targeted records into temporary table
INSERT temp_role_assignments
select * from
mdl_role_assignments
where
roleid = 5; -- student ID is 5
-- change all role IDs to 'read-only student'
update temp_role_assignments set roleid = 142; -- read-only student role ID is 140
 
-- insert records from temporary table into 'role assignments'
INSERT mdl_role_assignments (roleid,contextid,userid,timemodified,modifierid,component,itemid,sortorder)
SELECT roleid, contextid, userid, timemodified, modifierid, component, itemid, sortorder FROM temp_role_assignments;

-- empty temporary table before next query
delete from temp_role_assignments;
 
-- Identify what would end up being duplicates
INSERT temp_role_assignments (id,roleid,contextid,userid,timemodified,modifierid,component,itemid,sortorder)
select DISTINCT d.id, d.roleid, d.contextid, d.userid, d.timemodified, d.modifierid, d.component, d.itemid, d.sortorder
from
mdl_role_assignments m, mdl_role_assignments d
where
m.contextid=d.contextid and m.userid=d.userid
and m.roleid=142 and d.roleid in (26);
 
-- insert records into 'role assignment', except those who are in temporary table
INSERT mdl_role_assignments (roleid,contextid,userid,timemodified,modifierid,component,itemid,sortorder)
SELECT 142, contextid, userid, timemodified, modifierid, component, itemid, sortorder
FROM mdl_role_assignments ra
WHERE ra.roleid = 26 AND
ra.id NOT IN
(SELECT id from temp_role_assignments);

drop table if exists temp_role_assignments;
#sql role add ===========================================================

#theme settins
https://moodle-snapshot.ucl.ac.uk/16-17/admin/settings.php?section=theme_ucl_generic

/* Snapshot 16-17 banner */
div#archivetopstrap{
 background: url(https://moodle-archive.ucl.ac.uk/16-17/theme/ucl/pix/banner.jpg);
 height: 60px;
}
# add link ti snapshot instance
vi /data/apache/htdocs/moodle/index.php
# fix course search form
grep -nr "/course/search.php" theme/ucl/
#result:
theme/ucl/layout/mydashboard.php:108:                           <form method="get" action="/course/search.php">
vi theme/ucl/layout/mydashboard.php
#edit file and replace /course/search.php  with /16-17/course/search.php
#
tool_generator_000001
m!!dle
41191
https://moodle-pp.ucl.ac.uk/user/view.php?id=523037&course=41191
#
sz.2-cId
#
# Emergency CR00001682
#
cd /home/sammy/Documents
## apply to pp
for HOST in a b c d; do
    ssh ccspmdl@moodle-pp-$HOST.ucl.ac.uk "mv /data/apache/htdocs/moodle/blocks/lecturecast_connector/block_lecturecast_connector.php /data/apache/htdocs/moodle/blocks/lecturecast_connector/old_block_lecturecast_connector.php"
    rsync -vaz ./block_lecturecast_connector.php ccspmdl@moodle-pp-$HOST.ucl.ac.uk:/data/apache/htdocs/moodle/blocks/lecturecast_connector/
done
for HOST in admin; do
    ssh ccspmdl@moodle-$HOST-pp.ucl.ac.uk "mv /data/apache/htdocs/moodle/blocks/lecturecast_connector/block_lecturecast_connector.php /data/apache/htdocs/moodle/blocks/lecturecast_connector/old_block_lecturecast_connector.php"
    rsync -vaz ./block_lecturecast_connector.php ccspmdl@moodle-$HOST-pp.ucl.ac.uk:/data/apache/htdocs/moodle/blocks/lecturecast_connector/
done
#apply to prod
for HOST in d e f g admin; do
    ssh ccspmdl@moodle-$HOST.ucl.ac.uk "mv /data/apache/htdocs/moodle/blocks/lecturecast_connector/block_lecturecast_connector.php /data/apache/htdocs/moodle/blocks/lecturecast_connector/old_block_lecturecast_connector.php"
    rsync -vaz ./block_lecturecast_connector.php ccspmdl@moodle-$HOST.ucl.ac.uk:/data/apache/htdocs/moodle/blocks/lecturecast_connector/
done
#
# ROLLBACK
for HOST in d e f g admin; do
    ssh ccspmdl@moodle-$HOST.ucl.ac.uk "rsync -vaz /data/apache/htdocs/moodle/blocks/lecturecast_connector/old_block_lecturecast_connector.php /data/apache/htdocs/moodle/blocks/lecturecast_connector/block_lecturecast_connector.php"
done
#Rollback PP
for HOST in a b c d; do
    ssh ccspmdl@moodle-pp-$HOST.ucl.ac.uk "rsync -vaz /data/apache/htdocs/moodle/blocks/lecturecast_connector/old_block_lecturecast_connector.php /data/apache/htdocs/moodle/blocks/lecturecast_connector/block_lecturecast_connector.php"
done
for HOST in admin; do
    ssh ccspmdl@moodle-$HOST-pp.ucl.ac.uk "rsync -vaz /data/apache/htdocs/moodle/blocks/lecturecast_connector/old_block_lecturecast_connector.php /data/apache/htdocs/moodle/blocks/lecturecast_connector/block_lecturecast_connector.php"
done

## TII default checkbox - apply to pp
cd ~/Downloads/course_reset_defaults
for HOST in a b c d; do
    #rsync -vaz lib.php ccspmdl@moodle-pp-$HOST.ucl.ac.uk:/data/apache/htdocs/moodle/mod/turnitintooltwo/
    rsync -vaz reset_form.php ccspmdl@moodle-pp-$HOST.ucl.ac.uk:/data/apache/htdocs/moodle/course/
done
for HOST in admin; do
    #rsync -vaz lib.php ccspmdl@moodle-$HOST-pp.ucl.ac.uk:/data/apache/htdocs/moodle/mod/turnitintooltwo/
    rsync -vaz reset_form.php ccspmdl@moodle-$HOST-pp.ucl.ac.uk:/data/apache/htdocs/moodle/course/
done
#error on pp-c. update from pp-a
rsync -vaz ccspmdl@moodle-pp-a.ucl.ac.uk:/data/apache/htdocs/moodle/ ppa
rsync -vaz ppa/ ccspmdl@moodle-pp-c.ucl.ac.uk:/data/apache/htdocs/moodle/
#
######
rsync -vaz ccspmdl@moodle-d.ucl.ac.uk:/data/apache/htdocs/moodle/ moodle_d
git clone git@git.dcs.ucl.ac.uk:lta/moodle.git gitlab_moodle
mv gitlab_moodle/.git* moodle_d
cd moodle_d
git status
git commit -am "refresh from server on `date`"
cp ~/Downloads/course_reset_defaults/reset_form.php course/
cp ~/Downloads/course_reset_defaults/lib.php mod/turnitintooltwo/
git status
git commit -am "Change default settings for course reset - CR00001745"
git push -u origin ucl_stable
cd ..
rm -rf gitlab_moodle
## copy to pp
for HOST in a b c d; do
    rsync -vaz --exclude='.git*' --exclude='local_settings.php' moodle_d/ ccspmdl@moodle-pp-$HOST.ucl.ac.uk:/data/apache/htdocs/moodle/
done
for HOST in admin; do
    rsync -vaz --exclude='.git*' --exclude='local_settings.php' moodle_d/ ccspmdl@moodle-$HOST-pp.ucl.ac.uk:/data/apache/htdocs/moodle/
done
#
Convert 3 submission attempt(s) for assignment 34497
for HOST in d admin; do
  ssh ccspmdl@moodle-$HOST "ps aux | egrep '(VSZ|soffice|unoconv|clamscan|gs)' | egrep -v '(grep|watch)'"
done
#
SELECT * FROM `moodle_live`.`mdl_assign_submission` where assignment =  35003 LIMIT 1000;
SELECT * FROM `moodle_live`.`mdl_assignfeedback_editpdf_queue` where submissionid in (
  SELECT id FROM `moodle_live`.`mdl_assign_submission` where assignment =  35003
);
delete FROM `moodle_live`.`mdl_assignfeedback_editpdf_queue` where submissionid in (
  SELECT id FROM `moodle_live`.`mdl_assign_submission` where assignment =  35003
);
SELECT * FROM `moodle_live`.`mdl_assign_submission` where id in (1037587, 1050967);
#
select * from cmis_groups_course where moodlegroupid = 32731;
select * from cmis_groups_course where moodlegroupingid = 32731;
delete from cmis_groups_course where moodlegroupingid = 32731;
#
for HOST in d e f g; do
rsync -vaz ccspmdl@moodle-$HOST:/var/log/httpd/access_log access_log_$HOST
done
for HOST in d e f g; do
rsync -vaz ccspmdl@moodle-$HOST:/var/log/httpd/error_log error_log_$HOST
done
perl logresolvemerge.pl access_log_{d,e,f,g} > mycombinedaccesslog
perl logresolvemerge.pl error_log_{d,e,f,g} > mycombinederrorlog
#
for HOST in d e f g; do
rsync -vaz ccspmdl@moodle-$HOST:/var/log/httpd/ var_log_httpd_$HOST
done
#
wget -c https://prdownloads.sourceforge.net/awstats/awstats-7.6.tar.gz
tar xvf awstats-7.6.tar.gz
cd awstats-7.6/wwwroot/cgi-bin/
mkdir results_dir
perl awstats.pl -config=moodle -update
rsync -vaz ../../tools/awstats_buildstaticpages.pl .
perl awstats_buildstaticpages.pl -config=moodle -dir=results_dir -staticlinks
#--
wget -c http://tar.goaccess.io/goaccess-1.2.tar.gz
tar xvf goaccess-1.2.tar.gz
sudo zypper install GeoIP GeoIP-devel GeoIP-data
./configure --enable-utf8 --enable-geoip=legacy --prefix=/home/sammy/Download/bin
make
make install
PATH=$PATH:localdir
vi goaccess.conf
goaccess access_log -a --config-file=goaccess.conf -o report.html
