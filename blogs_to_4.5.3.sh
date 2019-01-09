## Blogs Prod. update to 4.5.3
#ref: https://wiki.ucl.ac.uk/display/ISAppsDev/Upgrading+WordPress+at+UCL
ssh ccsplta@wwwapps-a.ucl.ac.uk
unset HISTFILE
path_to_blog="/data/apache/vhost/live/blogs"
blog_parent="/data/apache/vhost/live"
BACKUP_FOLDER='/data/ccsplta'
version="4.5.3"
NOW=$(date +"%Y%m%d")

cd $path_to_blog
cp .htaccess-maint .htaccess

###Backup the WordPress database
# Will be done by the DBAs
#wp db export --add-drop-table $BACKUP_FOLDER/wordpress_mu_live_${NOW}.sql
#doesn't work anyway because, database being on another machine, mysqldump is not installed on wwwapps-a

###Backup up WordPress code and content
#Make sure you can read everything in this folder
cd $path_to_blog
find . -name blah # If you see any 'Permission denied' these files or folders are still not accessible
#contact DCS if there are permissions issues

# if all is well - we time the process
time rsync -vaz $path_to_blog/ $BACKUP_FOLDER/blogs_backup_${NOW}

###UPGRADE/UPDATE
#update core - we time the process
cd $path_to_blog
time wp core update --version=$version #update wordpress core

#update BD
wp core update-db --dry-run # do a dry run
time wp core update-db # update database

#update PLUGINS - check website to find out latest versions of each plugin
# with web browser, go to https://blogs-uat.ucl.ac.uk/wp-admin/network/update-core.php
#
wp plugin update --version=3.1.11 akismet
wp plugin update --version=4.4.2 contact-form-7  
wp plugin update --version=6.4.9.7 google-analyticator  
wp plugin update --version=2.7.2 wysija-newsletters  
wp plugin update --version=5.3.3 addthis  
#wp plugin update --version=10.21 subscribe2 #compatibility unknown
wp plugin update --version=1.0.1 tag-pages
wp plugin update --version=1.0 m-wp-popup  
wp plugin update --version=4.1.5 wptouch
wp plugin update --version=3.3.1 wordpress-seo

# THEMES
wp theme update --version=0.6.0 oxygen
wp theme update --version=1.5 twentyfifteen
wp theme update --version=1.7 twentyfourteen
wp theme update --version=1.2 twentysixteen

#Check the page /wp-admin/network/update-core.php

#Goto https://blogs-dev.ucl.ac.uk/wp-admin/network/upgrade.php 
#and click the Upgrade Network button. Let this complete

#TESTING
#from the web interface - talk to WAMS

#change htaccess
cp htaccess_live .htaccess

#clean up
rm -rf $BACKUP_FOLDER/blogs_backup_${NOW}

##NOT ON SEVER - DO WHAT COMES NEXT ON YOUR WORKSTATION 
## GIT sequence
##FROM WORKSTATION
#if you don't have the repo, clone it
#if you have the repo, the repo alias might be 'dcs' rather than 'origin'
git clone git@git.dcs.ucl.ac.uk:lta/wordpress-mu.git
cd wordpress-mu
#branch UCL_STABLE did not exist. Instead there was one called UAT_STABLE; which has now been renamed.
git checkout  -b UCL_STABLE

mv .gitignore ..
mv .git ..
cd ..
mkdir latest_blogs
mv .gitignore .git latest_blogs

git rm -rf .
mv ../.gitignore .
#
rsync -vaz -e ssh ccsplta@wwwapps-a.ucl.ac.uk:/data/apache/vhost/live/blogs/ .
#
git add --all .
git commit -m "Update WordPress to $version - also update plugins and themes"
git push -u origin UCL_STABLE #repo alias might be 'dcs'
#git push -u dcs UCL_STABLE

##
## roll back
##
cd $path_to_blog
#--add-drop-table was added during the export; so re-importing should be straightforward
#wp db import $BACKUP_FOLDER/wordpress_mu_live_${NOW}
rm *
rm .*
rm -rf *
time rsync -vaz $BACKUP_FOLDER/blogs_backup_${NOW}/ $path_to_blog
