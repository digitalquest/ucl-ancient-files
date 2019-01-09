## Blogs Prod. update
#ref: https://wiki.ucl.ac.uk/display/ISAppsDev/Upgrading+WordPress+at+UCL
ssh ccsplta@wwwapps-a.ucl.ac.uk
unset HISTFILE
path_to_blog="/data/apache/vhost/live/blogs"
BACKUP_FOLDER='/data/ccsplta'
version="4.7"
NOW=$(date +"%Y%m%d")

#ENABLE maintenance mode
cd $path_to_blog
cp .htaccess .htaccess_live
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
#time rsync -vaz --exclude="wp-content/blogs.dir" $path_to_blog/ $BACKUP_FOLDER/blogs_backup_${NOW}
time rsync -vaz $path_to_blog/ $BACKUP_FOLDER/blogs_backup_${NOW}

###UPGRADE/UPDATE
#update core - we time the process
cd $path_to_blog
#time wp core update #update to latest version
time wp core update --version=$version #update wordpress core

#update BD
#wp core update-db --dry-run # do a dry run
time wp core update-db # update database

#update PLUGINS - check website to find out latest versions of each plugin
# with web browser, go to https://blogs-uat.ucl.ac.uk/wp-admin/network/update-core.php
#
wp plugin update --version=3.2 akismet
wp plugin update --version=4.6 contact-form-7  
wp plugin update --version=1.08 formbuilder  
wp plugin update --version=6.5.0.0 google-analyticator  
wp plugin update --version=2.6.2 google-document-embedder  
wp plugin update --version=2.7.5 wysija-newsletters  
wp plugin update --version=5.3.4 addthis  
#wp plugin update --version=1.0.1 tag-pages
wp plugin update --version=1.9.2 slideshare  
wp plugin update --version=10.21 subscribe2 #compatibility unknown
wp plugin update --version=0.6.3 wordpress-importer
wp plugin update --version=1.1 m-wp-popup  
wp plugin update --version=4.3.7 wptouch
wp plugin update --version=3.9 wordpress-seo

# THEMES
#wp theme update --version=0.6.0 oxygen
wp theme update --version=1.7 twentyfifteen
wp theme update --version=1.9 twentyfourteen
wp theme update --version=1.3 twentysixteen

# INSTALL new plugin
wp plugin install wp-maintenance-mode
wp plugin install maintenance

####
# Indigo theme
####
mv $path_to_blog/wp-content/themes/indigo $BACKUP_FOLDER/indigo_backup_$NOW
#FROM MY WORKSTATION ############################################
#~/Downloads/repos
rsync -vaz -e ssh indigo13dec2016/ ccsplta@wwwapps-a.ucl.ac.uk:/data/apache/vhost/live/blogs/wp-content/themes/indigo
rsync -vaz -e ssh indigoyellow13dec2016/ ccsplta@wwwapps-a.ucl.ac.uk:/data/apache/vhost/live/blogs/wp-content/themes/indigoyellow

#DISABLE maintenace mode
#Activate MAINTENANCE MODE FOR USERS; site admins can access frontend and backend
cp .htaccess_live .htaccess

#TESTING
#from the web interface - talk to Web Presence

#clean up
rm -rf $BACKUP_FOLDER/blogs_backup_${NOW}

##
##DO WHAT COMES NEXT ON YOUR WORKSTATION - NOT ON SEVER 
##

# GIT sequence FROM WORKSTATION
#if you don't have the repo, clone it
#if you have the repo, the repo alias might be 'dcs' rather than 'origin'
mkdir latest_blogs
#
git clone git@git.dcs.ucl.ac.uk:lta/wordpress-mu.git
cd wordpress-mu
#
git checkout  -b UCL_STABLE
mv .gitignore ../latest_blogs
mv .git ../latest_blogs
#
cd ../latest_blogs
rsync -vaz -e ssh ccsplta@wwwapps-a.ucl.ac.uk:/data/apache/vhost/live/blogs/ .
#
git add --all .
git commit -m "Update WordPress to $version - also update plugins and themes"
git push -u origin UCL_STABLE #repo alias might be 'dcs'
#git push -u dcs UCL_STABLE

##
## Roll back - ON SERVER
##
#CONTACT DBAs to rollback the database
cd $path_to_blog
#keep site in maintenance mode
#keep wp-content/blogs.dir
rm -rf *
#ask dcs to delete wp-content
#keep .htacces* keep ucl_service.php

#time rsync -vaz --exclude="wp-content/blogs.dir" $BACKUP_FOLDER/blogs_backup_${NOW}/ $path_to_blog
time rsync -vaz $BACKUP_FOLDER/blogs_backup_${NOW}/ $path_to_blog
#echo "empty database $dbname" | mysql -u $dbuser -p$dbpassword
#wp db import $BACKUP_FOLDER/wordpress_mu_live_${NOW}

##
## UAT - WORDPRESS UPDATE/UPGRADE
##
environment="uat" #possible values live, uat, dev
path_to_blog="/data/apache/vhost/$environment/blogs"
blog_parent="/data/apache/vhost/$environment"
version="4.7"
NOW=$(date +"%Y%m%d")

cd $path_to_blog
#on uat
cp .htaccess htaccess.live
cp .htaccess.maint .htaccess

#Backup the WordPress database
#wp db export --add-drop-table /data/mysql/mysql-5.6/backup/wordpress_mu_$environment_${NOW}
wp db export --add-drop-table $path_to_blog/wordpress_mu_$environment_${NOW}.sql
# export and compress wordpress database:
#wp db export --add-drop-table - | zip wordpress_mu_$environment_${NOW} -

###Backup up WordPress code and content
rsync -vaz --exclude=".git*" --exclude="*.sql" --exclude="wp-content/blogs.dir" --exclude="wp-content/uploads" ${path_to_blog}/ ~/blogs_backup_$NOW

# RUN UPDATE SEQUENCE (see what is done on Prod)
#time wp core update #update to latest version
time wp core update --version=$version #update wordpress core
#update BD
#wp core update-db --dry-run # do a dry run
time wp core update-db # update database

#wp plugin install --activate maintenance
#wp plugin activate maintenance
#wp plugin deactivate maintenance
#wp plugin uninstall maintenance
#wp plugin delete maintenance
wp plugin install --activate wp-maintenance-mode
#wp plugin activate wp-maintenance-mode
#wp plugin deactivate wp-maintenance-mode
#wp plugin uninstall wp-maintenance-mode
#wp plugin delete wp-maintenance-mode

#change htaccess
cp htaccess.live .htaccess

##
wp plugin list #All installed plugins
wp plugin list --status=active --format=json #All plugins activated sitewide
wp plugin list --status=inactive --format=json #All plugins inactive sitewide
# List plugins on each site in a network
wp site list --field=url | xargs -n 1 -I % wp plugin list --url=%

#
wp db export --add-drop-table $path_to_blog/wordpress_mu_$environment_${NOW}.sql
rsync -vaz --exclude=".git*" --exclude="*.sql" --exclude="wp-content/blogs.dir" --exclude="wp-content/uploads" ${path_to_blog}/ ~/blogs_backup_$NOW
time wp core update --version=$version
time wp core update-db
#
rm *.php *.txt *.html *.png 
rm -rf wp-admin wp-includes
rsync -vaz --exclude=".git*" --exclude="*.sql" --exclude="wp-content/wptouch-data" --exclude="wp-content/blogs.dir" --exclude="wp-content/uploads" ~/blogs_backup_$NOW/ ${path_to_blog}
#