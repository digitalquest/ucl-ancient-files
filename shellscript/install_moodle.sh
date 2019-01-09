#! /bin/bash
#
# declare variables. change accordingly
MOODLE_RELEASE=MOODLE_30_STABLE
MOODLEDIR=moodle
INSTALL_PATH=/home/ubuntu/workspace
PATH_TO_MOODLE=$INSTALL_PATH/$MOODLEDIR
PATH_TO_MOODLEDATA=/home/ubuntu/moodledata
ROOT_USER=ubuntu
WEBSERVER_USER=www-data

cd $INSTALL_PATH

# downlaod usin wget and decompress
#wget -c https://download.moodle.org/download.php/stable30/moodle-latest-30.tgz
#wget -c https://download.moodle.org/stable30/moodle-latest-30.tgz.sha256
#sha256sum -c moodle-latest-30.tgz.sha256
#mkdir $MOODLEDIR
#tar xvf moodle-latest-30.tgz --directory $MOODLEDIR --strip-components=1
# rm moodle-latest-30.tgz
#rm moodle-latest-30.tgz.sha256

# download with git
git clone --depth=1 -b $MOODLE_RELEASE git://git.moodle.org/moodle.git $MOODLEDIR

# Secure the Moodle files: It is vital that the files are not writeable by the web server user. For example, on Unix/Linux (as root):
chown -R $ROOT_USER $PATH_TO_MOODLE
chmod -R 0755 $PATH_TO_MOODLE
find $PATH_TO_MOODLE -type f -exec chmod 0644 {} \;
# (files are owned by the administrator/superuser and are only writeable by them - readable by everyone else)

# If you want to use the built-in plugin installer. use ACL when your server supports it
# A default Ubuntu install does not have the +a option for the chmod command
#chmod -R +a "$WEBSERVER_USER allow read,delete,write,append,file_inherit,directory_inherit" $PATH_TO_MOODLE

# Create an empty database
# source db credentials
#. $HOME/.moodle_dbconfig
#
#CONFIGFILE=config
#cp $CONFIGFILE-dist.php $CONFIGFILE.php
#
#sed -i 's/^$CFG->dbtype.*/$CFG->dbtype    = \'$DB_TYPE\';/' $CONFIGFILE.php
#sed -i 's/^$CFG->dbhost.*/$CFG->dbhost    = \'$DB_HOST\';/' $CONFIGFILE.php
#sed -i 's/^$CFG->dbname.*/$CFG->dbname    = \'$DB_NAME\';/' $CONFIGFILE.php
#sed -i 's/^$CFG->dbuser.*/$CFG->dbuser    = \'$DB_USER\';/' $CONFIGFILE.php
#sed -i 's/^$CFG->dbpass.*/$CFG->dbpass    = \'$DB_PASSWORD\';/' $CONFIGFILE.php
# *****
mysql -u root -p
#Enter password:
CREATE DATABASE moodledb DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,CREATE TEMPORARY TABLES,DROP,INDEX,ALTER ON moodledb.* TO moodleuser@localhost IDENTIFIED BY 'moodlepassword';
# *****

# Create the (moodledata) data directory
mkdir $PATH_TO_MOODLEDATA
chmod 0777 $PATH_TO_MOODLEDATA

# If your server supports ACL it is recommended to set following permissions, for example if your Apache server uses account www-data:
#chmod -R +a "$WEBSERVER_USER allow read,delete,write,append,file_inherit,directory_inherit" $PATH_TO_MOODLEDATA

# If you are planning to execute PHP scripts from the command line you should set the same permissions for the current user: 
#sudo chmod -R +a "`whoami` allow read,delete,write,append,file_inherit,directory_inherit" $PATH_TO_MOODLEDATA

# if you are using a hosted site and you have no option but to place 'moodledata' in a web accessible directory. You may be able to secure it by creating an .htaccess file in the 'moodledata' directory.
#echo "order deny,allow" >> $PATH_TO_MOODLEDATA/.htaccess
#echo "deny from all" $PATH_TO_MOODLEDATA/.htaccess

# Command line installer
# extra sudo needed on c9
sudo chown $WEBSERVER_USER $PATH_TO_MOODLE
cd $PATH_TO_MOODLE/admin/cli
sudo sudo -u $WEBSERVER_USER /usr/bin/php install.php
#admin Ucladmin!
sudo chown -R $ROOT_USER $PATH_TO_MOODLE

#crontab -u $WEBSERVER_USER -e
# add the following: (replace $PATH_TO_MOODLE accordingly)
#*/1 * * * * /usr/bin/php  $PATH_TO_MOODLE/admin/cli/cron.php >/dev/null
