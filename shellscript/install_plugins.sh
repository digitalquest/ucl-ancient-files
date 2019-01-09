cd /data/www/html/blocks/
wget -c https://moodle.org/plugins/download.php/8100/block_course_contents_moodle29_2015030300.zip
unzip block_course_contents_moodle29_2015030300.zip
rm block_course_contents_moodle29_2015030300.zip

wget -c https://moodle.org/plugins/download.php/8303/block_course_overview_campus_moodle28_2014111003.zip
wget -c https://moodle.org/plugins/download.php/8750/block_featuredcourses_moodle30_2015042701.zip
wget -c https://github.com/UniversityofPortland/moodle-block_custom_course_menu/archive/master.zip
unzip master.zip
mv moodle-block_custom_course_menu-master custom_course_menu
rm master.zip
unzip block_course_overview_campus_moodle28_2014111003.zip
unzip block_featuredcourses_moodle30_2015042701.zip
rm block_course_overview_campus_moodle28_2014111003.zip 
rm block_featuredcourses_moodle30_2015042701.zip


wget -c https://moodle.org/plugins/download.php/10263/block_progress_moodle30_2016011300.zip
unzip block_progress_moodle30_2016011300.zip
rm block_progress_moodle30_2016011300.zip


wget -c https://moodle.org/plugins/download.php/10432/block_configurable_reports_moodle29_2011040120.zip
unzip block_configurable_reports_moodle29_2011040120.zip
rm block_configurable_reports_moodle29_2011040120.zip
wget -c https://moodle.org/plugins/download.php/10481/block_culupcoming_events_moodle28_2016020800.zip
unzip block_culupcoming_events_moodle28_2016020800.zip
rm block_culupcoming_events_moodle28_2016020800.zip
wget -c https://moodle.org/plugins/download.php/10197/block_filtered_course_list_moodle30_2016010300.zip
unzip block_filtered_course_list_moodle30_2016010300.zip
rm block_filtered_course_list_moodle30_2016010300.zip

## downloaded but not installed:
https://moodle.org/plugins/download.php/3970/format_fntabs_moodle25_2013032201.zip

##'ou multiple response'
cd /data/www/html/question/type
wget -c https://moodle.org/plugins/download.php/10057/qtype_oumultiresponse_moodle30_2015121500.zip
unzip qtype_oumultiresponse_moodle30_2015121500.zip
rm qtype_oumultiresponse_moodle30_2015121500.zip
