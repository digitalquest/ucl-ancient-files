# upgrade to mahara 17.04.03
ssh ccsplta@webapps-dev.ucl.ac.uk
unset HISTFILE
# first thing; clone the old site
OLD_VERSION="1604"
NEW_VERSION="17.04.3"
APP_ROOT="/data/mahara-vhosts"
#NOW=$(date +"%Y%m%d")
#DB_USER='mahara_user'
#DB_PASSWORD='tpWQbwVULuWD'
#OLD_DB_NAME="mahara_dev_1604"
#NEW_DB_NAME="mahara_uat_17.04.1"
#
cd $APP_ROOT
mkdir v${NEW_VERSION}
wget -c https://launchpad.net/mahara/17.04/${NEW_VERSION}/+download/mahara-${NEW_VERSION}.tar.gz
tar --strip-components=1 -xvf mahara-${NEW_VERSION}.tar.gz -C v${NEW_VERSION}
rm mahara-${NEW_VERSION}.tar.gz
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
# keep UCL theme
rsync -vaz $APP_ROOT/v${OLD_VERSION}/theme/ucl $APP_ROOT/v${NEW_VERSION}/htdocs/theme
rsync -vaz $APP_ROOT/v${OLD_VERSION}/artefact/europass/theme/raw/buttons.tpl $APP_ROOT/v${NEW_VERSION}/htdocs/theme/ucl
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

#mysqldump -u $DB_USER -p$DB_PASSWORD $OLD_DB_NAME > ${OLD_DB_NAME}_${NOW}.sql
#OLD_HOST="v${OLD_VERSION}.myportfolio-uat.ucl.ac.uk"
#NEW_HOST="v${NEW_VERSION}.myportfolio-uat.ucl.ac.uk"
#sed -i s/${OLD_HOST}/${NEW_HOST}/g ${OLD_DB_NAME}_${NOW}.sql
#
#mysqladmin  -u $DB_USER -p$DB_PASSWORD create $NEW_DB_NAME
#mysql -u $DB_USER -p$DB_PASSWORD $NEW_DB_NAME < ${OLD_DB_NAME}_${NOW}.sql
#change name of database in config file: $cfg->dbname   = 'mahara_dev_ver';
#sed -i s/${OLD_DB_NAME}/${NEW_DB_NAME}/g $APP_ROOT/v${NEW_VERSION}/config.php
## change the following line: $cfg->wwwroot = 'https://v151000.myportfolio-dev.ucl.ac.uk/';
##sed -i s/${OLD_HOST}/latest/g $APP_ROOT/v${NEW_VERSION}/config.php

# create symlink. in two steps to avoid already excisting name error.
ln -s $APP_ROOT/v${NEW_VERSION} current
mv -T current latest
# we do the upgrade as the current user (ccsplta); which is fine for us.
php $APP_ROOT/latest/admin/cli/upgrade.php 2>&1 | tee mahara_upgrade_to_${NEW_VERSION}_$(date +"%d-%m-%Y")

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


