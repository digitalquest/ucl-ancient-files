# upgrade from mahara 16.04.0 to 16.04.04 - on PROD
# 1. backup
# 2. new code
# 3. upgrade.php
# 4. commit to repo 
ssh ccsplta@webappsvm-b.ucl.ac.uk
unset HISTFILE
# first thing; clone the old site
OLD_VERSION="16.04.0"
NEW_VERSION="16.04.04"
APP_ROOT="/data/apache/htdocs/mahara"
DB_USER='mahara'
DB_PASSWORD='wMXlZbznTukQ'
#NOW=$(date +"%Y%m%d")
#
cd $APP_ROOT
mkdir v${NEW_VERSION}
wget -c https://launchpad.net/mahara/16.04/16.04.4/+download/mahara-16.04.4.tar.gz
wget -c https://launchpad.net/mahara/16.04/16.04.4/+download/mahara-16.04.4.tar.gz/+md5 -O md5_mahara_16.04.04
md5sum -c md5_mahara_16.04.04
tar --strip-components=1 -xvf mahara-16.04.4.tar.gz -C v${NEW_VERSION}
rm mahara-16.04.4.tar.gz
rm md5_mahara_16.04.04
# keep some files that we have customised
rsync -vaz $APP_ROOT/v${OLD_VERSION}/config.php $APP_ROOT/v${NEW_VERSION}/htdocs/
rsync -vaz $APP_ROOT/v${OLD_VERSION}/ucl_service.php $APP_ROOT/v${NEW_VERSION}/htdocs/
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
rsync -vaz $APP_ROOT/v${OLD_VERSION}/artefact/europass $APP_ROOT/v${NEW_VERSION}/htdocs/artefact/
rsync -vaz $APP_ROOT/v${OLD_VERSION}/artefact/cpds $APP_ROOT/v${NEW_VERSION}/htdocs/artefact/
rsync -vaz $APP_ROOT/v${OLD_VERSION}/artefact/learning $APP_ROOT/v${NEW_VERSION}/htdocs/artefact/
rsync -vaz $APP_ROOT/v${OLD_VERSION}/blocktype/embedly $APP_ROOT/v${NEW_VERSION}/htdocs/blocktype/
rsync -vaz $APP_ROOT/v${OLD_VERSION}/blocktype/openbadgedisplayer $APP_ROOT/v${NEW_VERSION}/htdocs/blocktype/
rsync -vaz $APP_ROOT/v${OLD_VERSION}/blocktype/twitter $APP_ROOT/v${NEW_VERSION}/htdocs/blocktype/

#begin mahara naming issue  - remove 'htdocs' subfolder
mv $APP_ROOT/v${NEW_VERSION}/htdocs $APP_ROOT/htdocs_tmp && \
rm -rf $APP_ROOT/v${NEW_VERSION} && \
mv $APP_ROOT/htdocs_tmp $APP_ROOT/v${NEW_VERSION}
#end mahara naming issue - remove 'htdocs' subfolder

# ******** On the day ********
# create symlink
cd $APP_ROOT/v${OLD_VERSION}
rsync -vaz .htaccess .htaccess_live
rsync -vaz .htaccess_maint .htaccess
rsync -vaz $APP_ROOT/v${OLD_VERSION}/.htaccess* $APP_ROOT/v${NEW_VERSION}
#
cd $APP_ROOT
rm mahara && ln -s v${NEW_VERSION} mahara
# we do the upgrade as the current user (ccsplta); which is fine for us.
php $APP_ROOT/v${NEW_VERSION}/admin/cli/upgrade.php
#
cd $APP_ROOT/v${NEW_VERSION}
rsync -vaz .htaccess_live .htaccess
##
## clean up - manually
##
#GIT
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
#
git push -u dcs master
#
