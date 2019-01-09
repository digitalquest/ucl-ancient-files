
-- success logins 09/01/2017
SELECT FROM_UNIXTIME(timecreated) AS lsl_timecreated, 
id , eventname , component , action , target , crud , courseid , anonymous , other , origin , ip , realuserid 
FROM mdl_logstore_standard_log 
WHERE action = 'loggedin' 
AND timecreated BETWEEN UNIX_TIMESTAMP('2016/11/14 00:00:00') AND UNIX_TIMESTAMP('2016/11/14 23:59:00') 
ORDER BY timecreated

-- failed login 09/01/2017
SELECT FROM_UNIXTIME(timecreated) AS lsl_timecreated , id , eventname , component , action , target , crud , courseid , origin , ip , realuserid FROM mdl_logstore_standard_log WHERE target = 'user_login' AND timecreated BETWEEN UNIX_TIMESTAMP('2016/11/14 00:00:00') AND UNIX_TIMESTAMP('2016/11/14 23:59:00') ORDER BY timecreated

-- all logins. time interval 
SELECT from_unixtime(timecreated) time_interval, 
COUNT(id) as Cnt
FROM mdl_logstore_standard_log
where action = 'loggedin' or target = 'user_login'
and timecreated BETWEEN UNIX_TIMESTAMP('2016/11/14 00:00:00') AND UNIX_TIMESTAMP('2016/11/14 23:59:00')
GROUP BY timecreated DIV (10*60)
--mysql your_database -p < my_requests.sql | awk '{print $1","$2}' > out.csv

--SELECT from_unixtime(FLOOR((timecreated)/(10*60))*(10*60)) time_interval, 
--COUNT(*) as Cnt 
--FROM mdl_logstore_standard_log
--where action = 'loggedin' or target = 'user_login'
--and timecreated BETWEEN UNIX_TIMESTAMP('2017/01/13 00:00:00') AND UNIX_TIMESTAMP('2017/01/13 23:59:00')
--GROUP BY time_interval
--all logins. time interval 

--
-- turn it in 2 assignment modified on a given day
SELECT from_unixtime(asb.submission_modified) AS 'time modified', u.firstname AS 'First', u.lastname AS 'Last', c.fullname AS 'Course', a.name AS 'Assignment' FROM `mdl_turnitintooltwo_submissions` AS asb JOIN mdl_turnitintooltwo AS a ON a.id = asb.turnitintooltwoid JOIN mdl_user AS u ON u.id = asb.userid JOIN mdl_course AS c ON c.id = a.course
	WHERE asb.submission_modified > unix_timestamp('2017/03/22 14:00:00') AND asb.submission_modified < unix_timestamp('2017/03/22 14:59:00')
	ORDER BY c.fullname, a.name, u.lastname

--turn it in 2 assignment modified on a given day
SELECT from_unixtime(asb.submission_modified) AS 'time modified', u.firstname AS 'First', u.lastname AS 'Last', c.fullname AS 'Course', a.name AS 'Assignment' FROM `mdl_turnitintooltwo_submissions` AS asb JOIN mdl_turnitintooltwo AS a ON a.id = asb.turnitintooltwoid JOIN mdl_user AS u ON u.id = asb.userid JOIN mdl_course AS c ON c.id = a.course 
WHERE asb.submission_modified > unix_timestamp('2017/03/22 00:00:00') AND asb.submission_modified < unix_timestamp('2017/03/22 23:59:00') ORDER BY c.fullname, a.name, u.lastname

-- turn it in 2 assignment modified on a given day
SELECT from_unixtime(asb.submission_modified) AS 'time modified', u.firstname AS 'First', u.lastname AS 'Last', c.fullname AS 'Course', a.name AS 'Assignment' FROM `mdl_turnitintooltwo_submissions` AS asb JOIN mdl_turnitintooltwo AS a ON a.id = asb.turnitintooltwoid JOIN mdl_user AS u ON u.id = asb.userid JOIN mdl_course AS c ON c.id = a.course 
WHERE asb.submission_modified > unix_timestamp('2017/03/23 00:00:00') AND asb.submission_modified < unix_timestamp('2017/03/23 23:59:00') ORDER BY c.fullname, a.name, u.lastname

--
SELECT from_unixtime(asb.submission_modified) AS 'time modified', u.firstname AS 'First', u.lastname AS 'Last', c.fullname AS 'Course', a.name AS 'Assignment' FROM `mdl_turnitintooltwo_submissions` AS asb JOIN mdl_turnitintooltwo AS a ON a.id = asb.turnitintooltwoid JOIN mdl_user AS u ON u.id = asb.userid JOIN mdl_course AS c ON c.id = a.course WHERE asb.submission_modified > unix_timestamp('2016/11/14 00:00:00') AND asb.submission_modified < unix_timestamp('2016/11/14 23:59:00') ORDER BY c.fullname, a.name, u.lastname


--NORMAL ASSIGNMENTS created on a given day
SELECT from_unixtime(asb.timecreated) AS 'time created', u.firstname AS 'First', u.lastname AS 'Last', c.fullname AS 'Course', a.name AS 'Assignment' FROM `mdl_assign_submission` AS asb JOIN mdl_assign AS a ON a.id = asb.assignment JOIN mdl_user AS u ON u.id = asb.userid JOIN mdl_course AS c ON c.id = a.course WHERE asb.timecreated > unix_timestamp('2017-03-22 00:00:00') AND asb.timecreated < unix_timestamp('2017-03-22 23:59:00') ORDER BY c.fullname, a.name, u.lastname


-- mdlfiles created on a given day
SELECT  from_unixtime(timecreated) as 'time created', filepath, component, filename
FROM `mdl_files` 
WHERE timecreated BETWEEN UNIX_TIMESTAMP('2017/03/22 00:00:00') AND UNIX_TIMESTAMP('2017/03/22 23:59:00')
order by timecreated


-- turn it in submissions 09/01/2017
SELECT from_unixtime(timecreated) as 'time created', eventname, component 
FROM `mdl_logstore_standard_log`
WHERE component = 'mod_turnitintooltwo' 
and eventname = '\\mod_turnitintooltwo\\event\\add_submission'
and timecreated BETWEEN UNIX_TIMESTAMP('2017/01/09 00:00:00') AND UNIX_TIMESTAMP('2017/01/09 23:59:00')

--
--
-- turn it in submissions 09/01/2017 - Intervals of 10 mins
SELECT from_unixtime(timecreated) as 'time created', count(id) as 'tii2 submissions' 
FROM `mdl_logstore_standard_log`
WHERE component = 'mod_turnitintooltwo' 
and eventname = '\\mod_turnitintooltwo\\event\\add_submission'
and timecreated BETWEEN UNIX_TIMESTAMP('2017/03/22 00:00:00') AND UNIX_TIMESTAMP('2017/03/22 23:59:00')
GROUP BY timecreated DIV (10*60)

--
--
--assessable submissions
SELECT  from_unixtime(timecreated) as 'time created', eventname, component
FROM`mdl_logstore_standard_log`
WHERE action = 'uploaded'
and timecreated BETWEEN UNIX_TIMESTAMP('2017/01/09 00:00:00') AND UNIX_TIMESTAMP('2017/01/09 23:59:00')
  
--
-- TIME slot - failed logins 09/01/2017
SELECT FROM_UNIXTIME(timecreated) AS 'time slot' , count(id) as 'failed logins' 
FROM mdl_logstore_standard_log 
WHERE target = 'user_login' 
AND timecreated BETWEEN UNIX_TIMESTAMP('2017/01/09 00:00:00') AND UNIX_TIMESTAMP('2017/01/09 23:59:00') 
GROUP BY timecreated DIV (10*60)

--
--
--
-- TIME slot - success logins 09/01/2017
SELECT FROM_UNIXTIME(timecreated) AS 'time slot' , count(id) as 'success logins' 
FROM mdl_logstore_standard_log 
WHERE action = 'loggedin' 
AND timecreated BETWEEN UNIX_TIMESTAMP('2017/01/09 00:00:00') AND UNIX_TIMESTAMP('2017/01/09 23:59:00') 
GROUP BY timecreated DIV (10*60)

--
--
-- time slot tii2 file created on a day
SELECT  from_unixtime(timecreated) as 'time slot', count(id) as 'No files created'
FROM `mdl_files` 
WHERE filename IS NOT NULL
and filename <> '.'
and component = 'mod_turnitintooltwo'
and timecreated BETWEEN UNIX_TIMESTAMP('2017/03/22 00:00:00') AND UNIX_TIMESTAMP('2017/03/22 23:59:00')
GROUP BY timecreated DIV (10*60)

--
--
-- upload assignments NOT tti2 09/01/2017
SELECT FROM_UNIXTIME(timecreated,'%Y %M %D %h:%i:%s') AS TIME ,ip,userid,eventname,action  
FROM `mdl_logstore_standard_log` 
WHERE `action` LIKE "%upload%" 
AND eventname like "%assignsubmission%"
AND timecreated BETWEEN UNIX_TIMESTAMP('2017/01/09 00:00:00') AND UNIX_TIMESTAMP('2017/01/09 23:59:00') 
ORDER BY timecreated DESC

-- 12/12/2016
SELECT FROM_UNIXTIME(timecreated,'%Y %M %D %h:%i:%s') AS TIME ,ip,userid,eventname,action  
FROM `mdl_logstore_standard_log` 
WHERE `action` LIKE "%upload%" 
AND eventname like "%assignsubmission%"
AND timecreated BETWEEN UNIX_TIMESTAMP('2016/12/12 00:00:00') AND UNIX_TIMESTAMP('2016/12/12 23:59:00') 
ORDER BY timecreated DESC

-- 14/11/2016
SELECT FROM_UNIXTIME(timecreated,'%Y %M %D %h:%i:%s') AS TIME ,ip,userid,eventname,action  
FROM `mdl_logstore_standard_log` 
WHERE `action` LIKE "%upload%" 
AND eventname like "%assignsubmission%"
AND timecreated BETWEEN UNIX_TIMESTAMP('2016/11/14 00:00:00') AND UNIX_TIMESTAMP('2016/11/14 23:59:00') 
ORDER BY timecreated DESC

--
--
-- downloads 09/01/2017
SELECT FROM_UNIXTIME(timecreated,'%Y %M %D %h:%i:%s') AS TIME ,ip,userid,eventname,action  
FROM `mdl_logstore_standard_log` 
WHERE `action` LIKE "%download%" 
AND timecreated BETWEEN UNIX_TIMESTAMP('2017/01/09 00:00:00') AND UNIX_TIMESTAMP('2017/01/09 23:59:00') 
ORDER BY timecreated DESC

-- No of assgmt uploads. 10 mins time slot. NOT tii2 09/01/2017
SELECT FROM_UNIXTIME(timecreated) AS 'time slot' , count(id) as 'No of uploads' 
FROM `mdl_logstore_standard_log` 
WHERE `action` LIKE "%upload%" 
AND eventname like "%assignsubmission%"
AND timecreated BETWEEN UNIX_TIMESTAMP('2017/03/22 00:00:00') AND UNIX_TIMESTAMP('2017/03/22 23:59:00') 
GROUP BY timecreated DIV (10*60)


-- role dpt admin
select id,name,shortname from mdl_role;
-- moodle/lib/accesslib.php  #define('CONTEXT_COURSECAT', 40);
select concat(u.firstname,' ',u.lastname) as 'user', u.username as 'username', u.id as 'user id'
from mdl_role_assignments ra
join mdl_user u on ra.userid = u.id
where ra.roleid = 133
GROUP by u.username
-- version 2
select concat(u.firstname,' ',u.lastname) as 'user', u.username as 'username', u.id as 'user id',  cat.name as 'category name'
from mdl_role_assignments ra
join mdl_user u on ra.userid = u.id
join mdl_context c on ra.contextid = c.id
join mdl_course_categories cat on c.instanceid = cat.id
where ra.roleid = 133
GROUP by u.username
--and c.contextlevel = 40

--
-- config changes
SELECT DATE_FORMAT( FROM_UNIXTIME( g.timemodified ) , '%Y-%m-%d' ) AS DATE, concat(u.firstname, ' ', u.lastname) AS USER, g.name AS setting, CASE WHEN g.plugin IS NULL THEN "core" ELSE g.plugin END AS plugin, g.VALUE AS new_value, g.oldvalue AS original_value FROM mdl_config_log AS g JOIN mdl_user AS u ON g.userid = u.id ORDER BY DATE DESC

--running cron jobs
SELECT classname
  ,DATE_FORMAT(FROM_UNIXTIME(lastruntime), '%H:%i [%d-%m-%Y]') AS 'last'
  ,DATE_FORMAT(now(), '%H:%i [%d-%m-%Y]') AS 'now'
  ,DATE_FORMAT(FROM_UNIXTIME(nextruntime), '%H:%i [%d-%m-%Y]') AS 'next'
  ,DATE_FORMAT(FROM_UNIXTIME(UNIX_TIMESTAMP()-nextruntime), '%i') AS 'next in min'
FROM mdl_task_scheduled
WHERE now() > FROM_UNIXTIME(nextruntime)
order by nextruntime desc

-- all enabled cron tasks
SELECT component, classname
  ,DATE_FORMAT(FROM_UNIXTIME(lastruntime), '%H:%i [%d-%m-%Y]') AS 'last'
  ,DATE_FORMAT(now(), '%H:%i [%d-%m-%Y]') AS 'now'
  ,DATE_FORMAT(FROM_UNIXTIME(nextruntime), '%H:%i [%d-%m-%Y]') AS 'next'
  ,DATE_FORMAT(FROM_UNIXTIME(UNIX_TIMESTAMP()-nextruntime), '%i') AS 'next in min'
  ,minute
  ,hour
  ,day
  ,month
  ,dayofweek
FROM mdl_task_scheduled
where disabled = 0
order by minute
--
-- myfeedback related events 09/01/2017
SELECT from_unixtime(timecreated) as 'time created', eventname, component 
FROM `mdl_logstore_standard_log`
WHERE eventname like "%myfeedback%"
and timecreated BETWEEN UNIX_TIMESTAMP('2017/03/23 00:00:00') AND UNIX_TIMESTAMP('2017/03/23 23:59:00')
--and component = 'report_myfeedback'




--
-- ***********************
-- DON'T USE
-- ***********************
--
-- success logins in last 4 days
SELECT COUNT(id) AS Users  FROM `mdl_user` 
WHERE DATEDIFF( NOW(),FROM_UNIXTIME(`lastlogin`) ) < 4

Users
29348

--
-- logins 09/01/2017
SELECT u.id, u.username, u.firstname, FROM_UNIXTIME(l.timecreated) AS lsl_timecreated, origin , ip, eventname , component , action , target FROM mdl_logstore_standard_log l JOIN mdl_user u ON u.id = l.userid WHERE 1 = 1 AND target = 'user_login' AND l.timecreated BETWEEN UNIX_TIMESTAMP('2017/01/09 00:00:00') AND UNIX_TIMESTAMP('2017/01/09 23:59:00') ORDER BY l.timecreated

-- logins 10/01/2017
SELECT u.id, u.username, u.firstname, FROM_UNIXTIME(l.timecreated) AS lsl_timecreated, origin , ip, eventname , component , action , target FROM mdl_logstore_standard_log l JOIN mdl_user u ON u.id = l.userid WHERE 1 = 1 AND target = 'user_login' AND l.timecreated BETWEEN UNIX_TIMESTAMP('2017/01/10 00:00:00') AND UNIX_TIMESTAMP('2017/01/10 23:59:00') ORDER BY l.timecreated

-- logins 11/01/2017
SELECT u.id, u.username, u.firstname, FROM_UNIXTIME(l.timecreated) AS lsl_timecreated, origin , ip, eventname , component , action , target FROM mdl_logstore_standard_log l JOIN mdl_user u ON u.id = l.userid WHERE 1 = 1 AND target = 'user_login' AND l.timecreated BETWEEN UNIX_TIMESTAMP('2017/01/11 00:00:00') AND UNIX_TIMESTAMP('2017/01/11 23:59:00') ORDER BY l.timecreated

-- logins 12/01/2017
SELECT u.id, u.username, u.firstname, FROM_UNIXTIME(l.timecreated) AS lsl_timecreated, origin , ip, eventname , component , action , target FROM mdl_logstore_standard_log l JOIN mdl_user u ON u.id = l.userid WHERE 1 = 1 AND target = 'user_login' AND l.timecreated BETWEEN UNIX_TIMESTAMP('2017/01/12 00:00:00') AND UNIX_TIMESTAMP('2017/01/12 23:59:00') ORDER BY l.timecreated


-- Moodle courses that have used inline PDF annotation feedback
SELECT DISTINCT name as "Assignment Name", course as "Course ID", fullname as "course title", "Standard" as "Annotation",
FROM_UNIXTIME(grd.timecreated) as "grade created", FROM_UNIXTIME(grd.timemodified) as "grade modified"
FROM mdl_assignfeedback_editpdf_annot ant
INNER JOIN mdl_assign_grades grd ON ant.gradeid = grd.id
INNER JOIN mdl_assign assign ON grd.assignment = assign.id
INNER JOIN mdl_course c ON assign.course = c.id
UNION
SELECT DISTINCT name as "Assignment Name", course as "Course ID", fullname as "course title", "Comment" as "Annotation",
FROM_UNIXTIME(grd.timecreated) as "grade created", FROM_UNIXTIME(grd.timemodified) as "grade modified"
FROM mdl_assignfeedback_editpdf_cmnt cmnt
INNER JOIN mdl_assign_grades grd ON cmnt.gradeid = grd.id
INNER JOIN mdl_assign assign ON grd.assignment = assign.id
INNER JOIN mdl_course c ON assign.course = c.id


--
-- 'Normal' Assignments due
SELECT a.id as 'Assgt ID', c.shortname as 'Course name', a.name as 'Assignment name', from_unixtime(duedate) AS due FROM mdl_assign  a 
join mdl_course c on a.course = c.id
WHERE duedate > unix_timestamp('2017-03-22 23:59:00') AND duedate < unix_timestamp('2017-03-24 00:00:00') ORDER BY duedate;

--
-- Number of Moodle assignment submissions by date range
SELECT from_unixtime(asb.timecreated) AS 'time created', u.firstname AS 'First', u.lastname AS 'Last', c.fullname AS 'Course', a.name AS 'Assignment' FROM `mdl_assign_submission` AS asb JOIN mdl_assign AS a ON a.id = asb.assignment JOIN mdl_user AS u ON u.id = asb.userid JOIN mdl_course AS c ON c.id = a.course
	WHERE asb.timecreated > unix_timestamp('2017/01/09 00:00:00') AND asb.timecreated < unix_timestamp('2017/01/09 23:59:00')
	ORDER BY c.fullname, a.name, u.lastname
--

-- Turn It In assignments due
SELECT p.id as 'Assgt-part ID', tii.name as 'tii assignment', c.shortname as 'course', from_unixtime(p.dtdue) AS 'due' 
FROM mdl_turnitintooltwo_parts p 
join mdl_turnitintooltwo tii on p.turnitintooltwoid = tii.id
join mdl_course c on tii.course = c.id
WHERE p.dtdue > unix_timestamp('2017-03-22 23:59:00') AND p.dtdue < unix_timestamp('2017-03-24 00:00:00') 
ORDER BY p.dtdue;

--

-- Student (user) COUNT in each Course
SELECT concat('<a target="_new" href="%%WWWROOT%%/course/view.php?id=',course.id,'">',course.fullname,'</a>') AS Course
,concat('<a target="_new" href="%%WWWROOT%%/user/index.php?contextid=',context.id,'">Show users</a>') AS Users
, COUNT(course.id) AS Students
FROM mdl_role_assignments AS asg
JOIN mdl_context AS context ON asg.contextid = context.id AND context.contextlevel = 50
JOIN mdl_user AS USER ON USER.id = asg.userid
JOIN mdl_course AS course ON context.instanceid = course.id
WHERE asg.roleid = 5 
GROUP BY course.id
ORDER BY COUNT(course.id) DESC
-- AND course.fullname LIKE '%2013%'

-- Enrolment count in each Course
SELECT c.fullname, COUNT(ue.id) AS Enroled
FROM mdl_course AS c 
JOIN mdl_enrol AS en ON en.courseid = c.id
JOIN mdl_user_enrolments AS ue ON ue.enrolid = en.id
GROUP BY c.id
ORDER BY Enroled DESC


-- Role assignments on categories
SELECT 
concat('<a target="_new" href="%%WWWROOT%%/course/category.php?id=',cc.id,'">',cc.id,'</a>') AS id,
concat('<a target="_new" href="%%WWWROOT%%/course/category.php?id=',cc.id,'">',cc.name,'</a>') AS category,
cc.depth, cc.path, r.name AS ROLE,
concat('<a target="_new" href="%%WWWROOT%%/user/view.php?id=',usr.id,'">',usr.lastname,'</a>') AS name,
usr.firstname, usr.username, usr.email
FROM mdl_course_categories cc
INNER JOIN mdl_context cx ON cc.id = cx.instanceid
AND cx.contextlevel = '40'
INNER JOIN mdl_role_assignments ra ON cx.id = ra.contextid
INNER JOIN mdl_role r ON ra.roleid = r.id
INNER JOIN mdl_user usr ON ra.userid = usr.id
ORDER BY cc.depth, cc.path, usr.lastname, usr.firstname, r.name, cc.name


-- Unique user sessions per day and month + graph
SELECT COUNT(DISTINCT userid) AS "Unique User Logins"
,DATE_FORMAT(FROM_UNIXTIME(timecreated), "%y /%m / %d") AS "Year / Month / Day", "Graph" 
FROM `mdl_logstore_standard_log` 
WHERE action LIKE 'loggedin'
--AND timecreated >  UNIX_TIMESTAMP('2015-01-01 00:00:00') # optional START DATE
--AND timecreated <= UNIX_TIMESTAMP('2015-01-31 23:59:00') # optional END DATE
GROUP BY MONTH(FROM_UNIXTIME(timecreated)), DAY(FROM_UNIXTIME(timecreated))
ORDER BY MONTH(FROM_UNIXTIME(timecreated)), DAY(FROM_UNIXTIME(timecreated))

-- Counting user's global and unique hits per day + counting individual usage of specific activities and resources (on that day)
SELECT DATE_FORMAT(FROM_UNIXTIME(timecreated), "%y-%m-%d") AS "Datez"
,COUNT(DISTINCT userid) AS "Unique Users"
,ROUND(COUNT(*)/10) "User Hits (K)"
,SUM(IF(component='mod_quiz',1,0)) "Quizzes"
,SUM(IF(component='mod_forum' OR component='mod_forumng',1,0)) "Forums"
,SUM(IF(component='mod_assign',1,0)) "Assignments"
,SUM(IF(component='mod_oublog',1,0)) "Blogs"
,SUM(IF(component='mod_resource',1,0)) "Files (Resource)"
,SUM(IF(component='mod_url',1,0)) "Links (Resource)"
,SUM(IF(component='mod_page',1,0)) "Pages (Resource)"
 
FROM `mdl_logstore_standard_log` 
WHERE 1=1
AND timecreated >  UNIX_TIMESTAMP('2017-01-01 00:00:00') -- optional START DATE
AND timecreated <= UNIX_TIMESTAMP('2017-01-31 23:59:00') -- optional END DATE
GROUP BY MONTH(FROM_UNIXTIME(timecreated)), DAY(FROM_UNIXTIME(timecreated))
ORDER BY MONTH(FROM_UNIXTIME(timecreated)), DAY(FROM_UNIXTIME(timecreated))



--
--
--
SELECT
    TABLE_SCHEMA
  , TABLE_NAME
  , CONCAT('CREATE OR REPLACE VIEW ', TABLE_SCHEMA, '.', TABLE_NAME, ' AS ',
           REPLACE(VIEW_DEFINITION, 'moodle_pp_20160715', 'moodle_pp_20170124'), ';') AS sql_create
FROM information_schema.VIEWS
WHERE TABLE_SCHEMA = 'moodle_sits_management_pp2'
AND VIEW_DEFINITION LIKE '%moodle_pp_20160715%';

--
CREATE OR REPLACE VIEW moodle_sits_management_pp2.sf2_v_enrolcourses AS select `cr`.`id` AS `moodle_id`,`cr`.`idnumber` AS `moodle_idnumber`,`cr`.`fullname` AS `course_name`,`cr`.`category` AS `category_id`,`ct`.`name` AS `category_name` from ((`moodle_pp_20170124`.`mdl_course` `cr` left join `moodle_pp_20170124`.`mdl_course_categories` `ct` on((`ct`.`id` = `cr`.`category`))) join `moodle_sits_management_pp2`.`sf2_v_enrolcourse_ids` `en` on((`en`.`moodle_id` = `cr`.`id`)));

--
CREATE OR REPLACE VIEW moodle_sits_management_pp2.sf2_v_enrolmemberships AS select distinct `cr`.`id` AS `moodle_id`,`cr`.`idnumber` AS `moodle_idnumber`,`em`.`student_code` AS `student_code`,`em`.`username` AS `username`,`em`.`map_action` AS `map_action` from (`moodle_sits_management_pp2`.`sf2_v_enrolmembership_maps` `em` join `moodle_pp_20170124`.`mdl_course` `cr` on((`cr`.`id` = `em`.`moodle_id`)));

--
CREATE OR REPLACE VIEW moodle_sits_management_pp2.sf2_v_personaltutorrole AS select `st`.`student_code` AS `student_code`,`st`.`upi` AS `student_upi`,`st`.`username` AS `student_username`,`st`.`firstname` AS `student_firstname`,`st`.`surname` AS `student_surname`,`gn`.`programme_code` AS `student_programme`,`us`.`id` AS `student_id`,`st`.`personal_tutor` AS `sits_tutor_upi`,`up`.`idnumber` AS `tutor_upi`,`up`.`firstname` AS `tutor_firstname`,`up`.`lastname` AS `tutor_surname`,`up`.`id` AS `tutor_id`,'personal_tutor' AS `role`,'direct' AS `source` from ((((`moodle_sits_management_pp2`.`students` `st` join `moodle_sits_management_pp2`.`enrolment_statuses` `en` on(((`en`.`enrolment_status` = `st`.`enrolment_status`) and (`en`.`enrol` = 'Y')))) join `moodle_sits_management_pp2`.`assignments` `gn` on(((`gn`.`student_code` = `st`.`student_code`) and (`gn`.`active` = 'Y')))) left join `moodle_pp_20170124`.`mdl_user` `us` on((`st`.`student_code` = `us`.`idnumber`))) left join `moodle_pp_20170124`.`mdl_user` `up` on((`st`.`personal_tutor` = `up`.`idnumber`))) where ((`st`.`deleted` = 'N') and (`st`.`personal_tutor` is not null) and (`st`.`personal_tutor` <> '')) union select `st`.`student_code` AS `student_code`,`st`.`upi` AS `student_upi`,`st`.`username` AS `student_username`,`st`.`firstname` AS `student_firstname`,`st`.`surname` AS `student_surname`,`gn`.`programme_code` AS `student_programme`,`us`.`id` AS `student_id`,`st`.`personal_tutor` AS `sits_tutor_upi`,`up`.`idnumber` AS `tutor_upi`,`up`.`firstname` AS `tutor_firstname`,`up`.`lastname` AS `tutor_surname`,`up`.`id` AS `tutor_id`,'personal_tutor' AS `role`,'profile_fields' AS `source` from ((((((`moodle_sits_management_pp2`.`students` `st` join `moodle_sits_management_pp2`.`enrolment_statuses` `en` on(((`en`.`enrolment_status` = `st`.`enrolment_status`) and (`en`.`enrol` = 'Y')))) join `moodle_sits_management_pp2`.`assignments` `gn` on(((`gn`.`student_code` = `st`.`student_code`) and (`gn`.`active` = 'Y')))) join `moodle_pp_20170124`.`mdl_user_info_data` `nd` on((`nd`.`data` = `st`.`personal_tutor`))) join `moodle_pp_20170124`.`mdl_user_info_field` `nf` on(((`nf`.`id` = `nd`.`fieldid`) and (`nf`.`shortname` = 'upi')))) left join `moodle_pp_20170124`.`mdl_user` `us` on((`st`.`student_code` = `us`.`idnumber`))) left join `moodle_pp_20170124`.`mdl_user` `up` on((`nd`.`userid` = `up`.`id`))) where ((`st`.`deleted` = 'N') and (`st`.`personal_tutor` is not null) and (`st`.`personal_tutor` <> '') and (not(exists(select 1 from `moodle_pp_20170124`.`mdl_user` `ux` where (`ux`.`idnumber` = `st`.`personal_tutor`)))));



--
SELECT id FROM `mdl_user` where username like "%tool_generator_%"


-- get enrolled users for a course 
SELECT c.id AS id, c.fullname, u.username, u.firstname, u.lastname, u.email
FROM mdl_role_assignments ra, mdl_user u, mdl_course c, mdl_context cxt
WHERE ra.userid = u.id
AND ra.contextid = cxt.id
AND cxt.contextlevel =50
AND cxt.instanceid = c.id
AND c.shortname ='your course shortname'
AND (roleid =5 OR roleid=3);

-- MYFEEDBACK REPORT
--To summarise, the columns that would be useful to have indexed (in order) are:

--*        component

--*        timecreated

--*        action (might be useful in future)

--*        userid
select
    l.eventname,
    l.contextlevel,
    l.component,
    l.action,
    l.userid,
    l.relateduserid,
    l.timecreated
from
    mdl_logstore_standard_log l
where
timecreated > unix_timestamp('2017-03-22 00:00:00') AND
component = 'report_myfeedback';

--But I would also like to run this:
select
    DISTINCT l.userid,
    u.department,
    u.email
from
    mdl_logstore_standard_log l
join
    mdl_user u ON l.userid = u.id
where
l.timecreated > unix_timestamp('2017-03-22 00:00:00') AND
l.component = 'report_myfeedback';

--
-- ucl_tools query: courses viewed in the last year
--
SELECT count(distinct contextid) as courses FROM mdl_logstore_standard_log 
                WHERE target = 'course' 
                AND action = 'viewed'
                AND timecreated > unix_timestamp( date_sub( now() , INTERVAL 1 YEAR  ) );
--

mysql> select FROM_UNIXTIME(l.timecreated, '%d %m %Y') 'time', 
    -> l.eventname 'event name', l.action 'action', 
    -> l.origin 'origin', l.ip 'IP address',
    -> c.id 'course id', c.shortname 'course shortname',
    -> CONCAT (u.firstname, ' ',u.lastname) 'Name', u.username 'username'
    -> from `mdl_logstore_standard_log` l 
    -> join mdl_course c on c.id = l.contextinstanceid
    -> join mdl_user u on u.id = l.userid
    -> where `eventname` like '%course_reset%' 
    -> -- and l.contextlevel = 50
    -> -- AND l.timecreated > UNIX_TIMESTAMP('2017/07/23 00:00:00')
    -> ORDER BY l.timecreated DESC
    -> limit 50;
