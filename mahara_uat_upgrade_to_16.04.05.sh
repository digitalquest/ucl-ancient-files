# upgrade from mahara 16.04.04 to 16.04.05 - on UAT
ssh ccsplta@webapps-uat.ucl.ac.uk
unset HISTFILE
# first thing; clone the old site
OLD_VERSION="160404"
NEW_VERSION="160405"
APP_ROOT="/data/mahara-vhosts"
DB_USER='mahara'
DB_PASSWORD='wMXlZbznTukQ'
NOW=$(date +"%Y%m%d")
OLD_DB_NAME="mahara_uat_"
NEW_DB_NAME="mahara_uat_${NOW}"
#
cd $APP_ROOT
mkdir v${NEW_VERSION}
wget -c https://launchpad.net/mahara/16.04/16.04.5/+download/mahara-16.04.5.tar.gz
wget -c https://launchpad.net/mahara/16.04/16.04.5/+download/mahara-16.04.5.tar.gz/+md5 -O md5_mahara_16.04.05
md5sum -c md5_mahara_16.04.05
tar --strip-components=1 -xvf mahara-16.04.5.tar.gz -C v${NEW_VERSION}
rm mahara-16.04.5.tar.gz
rm md5_mahara_16.04.05
# keep some files that we have customised
rsync -vaz $APP_ROOT/v${OLD_VERSION}/config.php $APP_ROOT/v${NEW_VERSION}/htdocs/
rsync -vaz $APP_ROOT/v${OLD_VERSION}/artefact/resume/blocktype/entireresume/lang/en.utf8/blocktype.entireresume.php $APP_ROOT/v${NEW_VERSION}/htdocs/artefact/resume/blocktype/entireresume/lang/en.utf8/
rsync -vaz $APP_ROOT/v${OLD_VERSION}/artefact/resume/blocktype/resumefield/lang/en.utf8/blocktype.resumefield.php $APP_ROOT/v${NEW_VERSION}/htdocs/artefact/resume/blocktype/resumefield/lang/en.utf8/
rsync -vaz $APP_ROOT/v${OLD_VERSION}/artefact/resume/lang/en.utf8/artefact.resume.php $APP_ROOT/v${NEW_VERSION}/htdocs/artefact/resume/lang/en.utf8/
rsync -vaz $APP_ROOT/v${OLD_VERSION}/artefact/resume/lang/en.utf8/help/forms/resumefieldform.coverletterfs.html $APP_ROOT/v${NEW_VERSION}/htdocs/artefact/resume/lang/en.utf8/help/forms/
rsync -vaz $APP_ROOT/v${OLD_VERSION}/artefact/resume/lang/en.utf8/help/forms/personalinformation.visastatus.html $APP_ROOT/v${NEW_VERSION}/htdocs/artefact/resume/lang/en.utf8/help/forms/
rsync -vaz $APP_ROOT/v${OLD_VERSION}/artefact/resume/lang/en.utf8/help/pages/index.html $APP_ROOT/v${NEW_VERSION}/htdocs/artefact/resume/lang/en.utf8/help/pages/
rsync -vaz $APP_ROOT/v${OLD_VERSION}/artefact/resume/lang/en.utf8/help/sections/mygoals.html $APP_ROOT/v${NEW_VERSION}/htdocs/artefact/resume/lang/en.utf8/help/sections/
rsync -vaz $APP_ROOT/v${OLD_VERSION}/artefact/resume/lang/en.utf8/help/sections/browsemyfiles.html $APP_ROOT/v${NEW_VERSION}/htdocs/artefact/resume/lang/en.utf8/help/sections/
rsync -vaz $APP_ROOT/v${OLD_VERSION}/search/elasticsearch/lang/en.utf8/search.elasticsearch.php $APP_ROOT/v${NEW_VERSION}/htdocs/search/elasticsearch/lang/en.utf8/
rsync -vaz $APP_ROOT/v${OLD_VERSION}/search/elasticsearch/lib.php $APP_ROOT/v${NEW_VERSION}/htdocs/search/elasticsearch/
rsync -vaz $APP_ROOT/v${OLD_VERSION}/theme/default/static/images/site-logo.png $APP_ROOT/v${NEW_VERSION}/htdocs/theme/default/images/
rsync -vaz $APP_ROOT/v${OLD_VERSION}/.htaccess* $APP_ROOT/v${NEW_VERSION}/htdocs/
# keep some of our plugins - We do not check newer version here. It'll be done in another script
rsync -vaz -r $APP_ROOT/v${OLD_VERSION}/artefact/europass $APP_ROOT/v${NEW_VERSION}/htdocs/artefact/
rsync -vaz -r $APP_ROOT/v${OLD_VERSION}/artefact/cpds $APP_ROOT/v${NEW_VERSION}/htdocs/artefact/
rsync -vaz -r $APP_ROOT/v${OLD_VERSION}/artefact/learning $APP_ROOT/v${NEW_VERSION}/htdocs/artefact/
rsync -vaz -r $APP_ROOT/v${OLD_VERSION}/blocktype/embedly $APP_ROOT/v${NEW_VERSION}/htdocs/blocktype/
rsync -vaz -r $APP_ROOT/v${OLD_VERSION}/blocktype/twitter $APP_ROOT/v${NEW_VERSION}/htdocs/blocktype/
#
#begin mahara naming issue ahhhhhh!!!!
mv $APP_ROOT/v${NEW_VERSION}/htdocs $APP_ROOT/htdocs_tmp && \
rm -rf $APP_ROOT/v${NEW_VERSION} && \
mv $APP_ROOT/htdocs_tmp $APP_ROOT/v${NEW_VERSION}
#end mahara naming issue ahhhhhh!!!!
#

mysqldump -u $DB_USER -p$DB_PASSWORD $OLD_DB_NAME > ${OLD_DB_NAME}_${NOW}.sql
OLD_HOST="v${OLD_VERSION}.myportfolio-uat.ucl.ac.uk"
NEW_HOST="v${NEW_VERSION}.myportfolio-uat.ucl.ac.uk"
sed -i s/${OLD_HOST}/${NEW_HOST}/g ${OLD_DB_NAME}_${NOW}.sql
#
mysqladmin  -u $DB_USER -p$DB_PASSWORD create $NEW_DB_NAME
mysql -u $DB_USER -p$DB_PASSWORD $NEW_DB_NAME < ${OLD_DB_NAME}_${NOW}.sql
#change name of database in config file: $cfg->dbname   = 'mahara_dev_ver';
sed -i s/${OLD_DB_NAME}/${NEW_DB_NAME}/g $APP_ROOT/v${NEW_VERSION}/config.php
# change the following line: $cfg->wwwroot = 'https://v151000.myportfolio-dev.ucl.ac.uk/';
sed -i s/${OLD_HOST}/latest/g $APP_ROOT/v${NEW_VERSION}/config.php
# create symlink. in two steps to avoid already excisting name error.
ln -s $APP_ROOT/v${NEW_VERSION} current
mv -T current latest
# we do the upgrade as the current user (ccsplta); which is fine for us.
php $APP_ROOT/latest/admin/cli/upgrade.php

#
# GIT
cd $APP_ROOT/v${OLD_VERSION}
# Initialise as a git repo and do first commit
git init
git config --global user.name "Sam Moulem" # just in case
git config --global user.email "s.moulem@ucl.ac.uk" # just in case
git add --all .
git commit -m "Commit code from $HOST on `date`" # $HOST is an environment variable
git remote add dcs git@git.dcs.ucl.ac.uk:lta/myportfolio.git
# check out new branch. delete all file; we'll be downloading a new version
git checkout -b MAHARA_${NEW_VERSION}
#
mv $APP_ROOT/v${OLD_VERSION}/.git $APP_ROOT/v${NEW_VERSION}
cd $APP_ROOT/v${NEW_VERSION}
git add --all .
git commit -m "Add code of Mahara ${NEW_VERSION}. Keep our plugins and language files - `date`" 
#
git format-patch master --stdout > $APP_ROOT/v${NEW_VERSION}.patch
git checkout master
git apply --check $APP_ROOT/v${NEW_VERSION}.patch
# If there is no output, then the patch should apply cleanly. 
#git merge --no-commit MAHARA_${NEW_VERSION}
git merge MAHARA_${NEW_VERSION}
#git archive master --prefix="mahara_${NEW_VERSION}/" --format=zip > $APP_ROOT/mahara_${NEW_VERSION}.zip
git push -u dcs master

##
## clean up - manually
##
rm ${OLD_DB_NAME}_${NOW}.sql
echo "drop database if exists $OLD_DB_NAME" | mysql -u $DB_USER -p$DB_PASSWORD


#redo on 20 feb 2017
mysqladmin  -u $DB_USER -p$DB_PASSWORD create mahara_uat_new_20170214
mysql -u $DB_USER -p$DB_PASSWORD mahara_uat_new_20170214 < mahara_uat_20170214.sql
OLD_VERSION="160404"
NEW_VERSION="160405"
rsync -vaz $APP_ROOT/v${OLD_VERSION}/config.php $APP_ROOT/v${NEW_VERSION}/
rsync -vaz $APP_ROOT/v${OLD_VERSION}/artefact/resume/blocktype/entireresume/lang/en.utf8/blocktype.entireresume.php $APP_ROOT/v${NEW_VERSION}/artefact/resume/blocktype/entireresume/lang/en.utf8/
rsync -vaz $APP_ROOT/v${OLD_VERSION}/artefact/resume/blocktype/resumefield/lang/en.utf8/blocktype.resumefield.php $APP_ROOT/v${NEW_VERSION}/artefact/resume/blocktype/resumefield/lang/en.utf8/
rsync -vaz $APP_ROOT/v${OLD_VERSION}/artefact/resume/lang/en.utf8/artefact.resume.php $APP_ROOT/v${NEW_VERSION}/artefact/resume/lang/en.utf8/
rsync -vaz $APP_ROOT/v${OLD_VERSION}/artefact/resume/lang/en.utf8/help/forms/resumefieldform.coverletterfs.html $APP_ROOT/v${NEW_VERSION}/artefact/resume/lang/en.utf8/help/forms/
rsync -vaz $APP_ROOT/v${OLD_VERSION}/artefact/resume/lang/en.utf8/help/forms/personalinformation.visastatus.html $APP_ROOT/v${NEW_VERSION}/artefact/resume/lang/en.utf8/help/forms/
rsync -vaz $APP_ROOT/v${OLD_VERSION}/artefact/resume/lang/en.utf8/help/pages/index.html $APP_ROOT/v${NEW_VERSION}/artefact/resume/lang/en.utf8/help/pages/
rsync -vaz $APP_ROOT/v${OLD_VERSION}/artefact/resume/lang/en.utf8/help/sections/mygoals.html $APP_ROOT/v${NEW_VERSION}/artefact/resume/lang/en.utf8/help/sections/
rsync -vaz $APP_ROOT/v${OLD_VERSION}/artefact/resume/lang/en.utf8/help/sections/browsemyfiles.html $APP_ROOT/v${NEW_VERSION}/artefact/resume/lang/en.utf8/help/sections/
rsync -vaz $APP_ROOT/v${OLD_VERSION}/search/elasticsearch/lang/en.utf8/search.elasticsearch.php $APP_ROOT/v${NEW_VERSION}/search/elasticsearch/lang/en.utf8/
rsync -vaz $APP_ROOT/v${OLD_VERSION}/search/elasticsearch/lib.php $APP_ROOT/v${NEW_VERSION}/search/elasticsearch/
rsync -vaz $APP_ROOT/v${OLD_VERSION}/theme/default/images/site-logo.png $APP_ROOT/v${NEW_VERSION}/theme/default/images/
rsync -vaz $APP_ROOT/v${OLD_VERSION}/theme/default/images/header-bkgd.png $APP_ROOT/v${NEW_VERSION}/theme/default/images/
rsync -vaz $APP_ROOT/v${OLD_VERSION}/.htaccess* $APP_ROOT/v${NEW_VERSION}/
# keep some of our plugins - We do not check newer version here. It'll be done in another script
rsync -vaz $APP_ROOT/v${OLD_VERSION}/artefact/europass $APP_ROOT/v${NEW_VERSION}/artefact/
rsync -vaz $APP_ROOT/v${OLD_VERSION}/artefact/cpds $APP_ROOT/v${NEW_VERSION}/artefact/
rsync -vaz $APP_ROOT/v${OLD_VERSION}/artefact/learning $APP_ROOT/v${NEW_VERSION}/artefact/
rsync -vaz $APP_ROOT/v${OLD_VERSION}/blocktype/embedly $APP_ROOT/v${NEW_VERSION}/blocktype/
rsync -vaz $APP_ROOT/v${OLD_VERSION}/blocktype/twitter $APP_ROOT/v${NEW_VERSION}/blocktype/


