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

mkdir sammy_behat310

######SSH SECTION ########################################
ssh -L 3304:localhost:3306 ccspmdd@moodle-dev.ucl.ac.uk -f -N

ssh -L 3305:localhost:3306 ccspsql@moodle-db-pp.ucl.ac.uk -f -N

ssh -L 3306:localhost:3306 

ssh -L 3307:localhost:3306 ccspsql@moodle-db-a.ucl.ac.uk -f -N

ssh -L 3308:localhost:3306 ccspsql@moodle-snapshot-a.ucl.ac.uk -f -N

ssh -L 3309:localhost:3306 ccspsql@moodle-db-b.ucl.ac.uk -f -N

ssh -L 3310:localhost:3306 ccspsql@webapps-db-a.ucl.ac.uk -f -N

ssh -L 3311:localhost:3306 ccspsql@moodle-db-a.ucl.ac.uk -f -N

ssh -L 3312:localhost:3306 ccspsql@moodle-db-a.ucl.ac.uk -f -N

######END SSH SECTION ########################################

A0g3st#!

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
