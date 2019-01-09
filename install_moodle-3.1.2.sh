#New
mkdir /data/moodle/sammy_moodle312
chmod -R 777 /data/moodle/sammy_moodle312

cd /data/apache/moodle-vhosts
git clone --branch MOODLE_31_STABLE https://github.com/moodle/moodle.git sammy_moodle312
ln -s /data/apache/moodle-vhosts/sammy_moodle312 /data/apache/moodle-vhosts/sammy312
cd sammy_moodle312
git reset --hard v3.1.2

echo "create database moodle_uat_sammy_v312 default character set utf8 collate utf8_unicode_ci" | mysql -u mdluser_uat -p'Mdl@uat1'
cd admin/cli/
php install.php --lang=en \
--wwwroot='https://sammy312.moodle-uat.ucl.ac.uk' \
--dataroot='/data/moodle/sammy_moodle312' \
--dbhost='localhost' \
--dbname='moodle_uat_sammy_v312' \
--dbuser='mdluser_uat' \
--dbpass='Mdl@uat1' \
--prefix='sammy_moodle312_' \
--fullname='Sammy Moodle v3.1.2' \
--shortname='Sam v312' \
--summary='Instance to test settings. Will be deleted' \
--adminuser='admin' \
--adminpass='password' \
--adminemail='admin@noreply.net' \
--non-interactive \
--agree-license >> /data/apache/moodle-vhosts/sammy_moodle312_installation.txt
