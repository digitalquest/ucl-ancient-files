#!/bin/bash
#
# WARNING: This script has not been tested and is used at your own risks
# It is not intended to be run as a shell script.
# Rather, command should be copied and pasted one by one
#
# The 'script' uses moosh (Moodle command line tool) to install extensions.
#
# INSTALL MOOSH
# Skip if you don't use Ubuntu and, instead, refer to: http://moosh-online.com/
# Install moosh from ppa; preferred method (on Ubuntu Linux)
sudo apt-add-repository ppa:zabuch/ppa
sudo apt-get update
sudo apt-get install moosh
#
# Alternative method to install moosh (relevant only for Ubuntu).
#
cd /etc/apt/sources.list.d/
#find out what is your Ubuntu release
codename=$(lsb_release -a | grep Codename | cut -d":" -f2 | tr -d ' ')
#
sudo echo "deb http://ppa.launchpad.net/zabuch/ppa/ubuntu $codename main" >> moosh.list
sudo echo "deb-src http://ppa.launchpad.net/zabuch/ppa/ubuntu $codename main" >> moosh.list
sudo apt-get update
sudo apt-get install moosh
#
# Install Moodle plugins automatically
#

# get list of plugins
PATH_TO_OLD_MOODLE=/home/ubuntu/workspace/moodle
cd $PATH_TO_OLD_MOODLE
# create file containing list of plugins
moosh plugin-list | cut -d',' -f1 > plugin_list
# generate info regarding plugins. 
# we keep it but won't use it. the file plugins_info will NOT be used.
# However it can be useful for your information.
moosh info-plugins | cut -d',' -f1 > plugins_info
# cd to new installation
PATH_TO_NEW_MOODLE=/home/ubuntu/workspace/moodle # on that occasion, path is the same for old and new Moodle ;)
cd $PATH_TO_NEW_MOODLE
# work out the version of Moodle needed
#moodle_version=$(sed -ne "s/\\\$branch *= *['\"]\([^'\"]*\)['\"] *;.*/\1/p" version.php)
moodle_version=$(grep '$branch' version.php | cut -d"'" -f2)
# install plugins from the list generated earlier
cat $PATH_TO_OLD_MOODLE/plugin_list | while read plugin; do echo "trying to install $plugin..."; moosh plugin-install $plugin $moodle_version; echo "-- next -->"; done
echo "ALL DONE. see logs for errors"


