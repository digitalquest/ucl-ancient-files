--
-- https://infiniterooms.wordpress.com/2015/08/10/moodle-component-heatmap-who-uses-what/
--running cron jobs
SELECT classname
  ,DATE_FORMAT(FROM_UNIXTIME(lastruntime), '%H:%i [%d]') AS 'last'
  ,DATE_FORMAT(now(), '%H:%i') AS 'now'
  ,DATE_FORMAT(FROM_UNIXTIME(nextruntime), '%H:%i [%d]') AS 'next'
  ,DATE_FORMAT(FROM_UNIXTIME(UNIX_TIMESTAMP()-nextruntime), '%i') AS 'next in min'
FROM mdl_task_scheduled
WHERE now() > FROM_UNIXTIME(nextruntime)

--config cahnges
SELECT 
DATE_FORMAT( FROM_UNIXTIME( g.timemodified ) , '%Y-%m-%d' ) AS DATE, 
u.username AS USER, 
g.name AS setting, 
CASE 
 WHEN g.plugin IS NULL THEN "core"
 ELSE g.plugin
END AS plugin, 
g.VALUE AS new_value, 
g.oldvalue AS original_value
FROM mdl_config_log  AS g
JOIN mdl_user AS u ON g.userid = u.id
ORDER BY DATE DESC

--
--
--
--
select  mdl_logstore_standard_log.id,
  mdl_logstore_standard_log.ip,
        mdl_logstore_standard_log.courseid,
        mdl_logstore_standard_log.target,
  mdl_logstore_standard_log.action,
        mdl_user.username,
  mdl_course.fullname,
        mdl_course_categories.name as Category,
  concat (mdl_user.firstname, ' ', mdl_user.lastname) as Who,
        mdl_user.email,
        from_unixtime(mdl_logstore_standard_log.timecreated) as TheTime
     From mdl_logstore_standard_log
Left join mdl_course on mdl_logstore_standard_log.courseid = mdl_course.id
Left join mdl_user on mdl_logstore_standard_log.userid = mdl_user.id
Left join mdl_course_categories on mdl_course.category = mdl_course_categories.id
WHERE
(mdl_logstore_standard_log.courseid ='630' or
mdl_logstore_standard_log.courseid ='631' or
mdl_logstore_standard_log.courseid ='610' or
mdl_logstore_standard_log.courseid ='635' or
mdl_logstore_standard_log.courseid ='607' or
mdl_logstore_standard_log.courseid ='581' or
mdl_logstore_standard_log.courseid ='640' or
mdl_logstore_standard_log.courseid ='625') and
    (mdl_logstore_standard_log.timecreated > unix_timestamp('2017-01-09 00:00:00') AND
    mdl_logstore_standard_log.timecreated < unix_timestamp('2017-01-12 00:00:00')) and
    action = 'viewed' and
    target = 'course'
--
--
SELECT
(SELECT COUNT(id) FROM mdl_course) - 1 AS courses,
(SELECT COUNT(id) FROM mdl_user WHERE deleted = 0 AND confirmed = 1) AS users,
(SELECT COUNT(DISTINCT ra.userid)
 FROM mdl_role_capabilities rc
 JOIN mdl_role_assignments ra ON ra.roleid = rc.roleid
 WHERE rc.capability IN ('moodle/course:upd' || 'ate', 'moodle/site:doanything')) AS teachers,
(SELECT COUNT(id) FROM mdl_role_assignments) AS enrolments,
(SELECT COUNT(id) FROM mdl_forum_posts) AS forum_posts,
(SELECT COUNT(id) FROM mdl_resource) AS resources,
(SELECT COUNT(id) FROM mdl_question) AS questions
--
--
--
--
SELECT from_unixtime(asb.submission_modified) AS 'time created', u.firstname AS 'First', u.lastname AS 'Last', c.fullname AS 'Course', a.name AS 'Assignment' FROM `mdl_turnitintooltwo_submissions` AS asb JOIN mdl_turnitintooltwo AS a ON a.id = asb.turnitintooltwoid JOIN mdl_user AS u ON u.id = asb.userid JOIN mdl_course AS c ON c.id = a.course
	WHERE asb.submission_modified > unix_timestamp('2017/01/09 00:00:00') AND asb.submission_modified < unix_timestamp('2017/01/09 23:59:00')
	ORDER BY c.fullname, a.name, u.lastname

--
--Lists "loggedin users" from the last 3 days
SELECT id,username,FROM_UNIXTIME(`lastlogin`) AS days 
FROM `mdl_user` 
WHERE DATEDIFF( NOW(),FROM_UNIXTIME(`lastlogin`) ) < 3

-- and user count for that same population:
SELECT COUNT(id) AS Users  FROM `mdl_user` 
WHERE DATEDIFF( NOW(),FROM_UNIXTIME(`lastlogin`) ) < 3

Users
1105

-- view action
SELECT l.action, COUNT( l.userid ) AS counter , r.name
FROM `mdl_log` AS l
JOIN `mdl_role_assignments` AS ra ON l.userid = ra.userid
JOIN `mdl_role` AS r ON ra.roleid = r.id
WHERE (ra.roleid IN (3,4,5)) AND (l.action LIKE '%view%' )
GROUP BY roleid,l.action
ORDER BY r.name,counter DESC


-- upload
SELECT FROM_UNIXTIME(timecreated,'%Y %M %D %h:%i:%s') AS TIME ,ip,userid,eventname,action  
FROM `mdl_logstore_standard_log` 
WHERE `action` LIKE "%upload%" 
AND eventname like "%assignsubmission%"
AND timecreated BETWEEN UNIX_TIMESTAMP('2017/01/09 00:00:00') AND UNIX_TIMESTAMP('2017/01/09 23:59:00') 
ORDER BY timecreated DESC

-- Summary (of what???)
SELECT 
    u.id AS userid,
    u.username,
    from_unixtime(l.TIMEcreated) AS rvisit,
    c.id AS rcourseid,
    c.fullname AS rcourse,
    agg.days AS days,
    agg.numdates,
    agg.numcourses,
    agg.numlogs
 FROM 
    mdl_logstore_standard_log l INNER JOIN mdl_user u
        ON l.userid = u.id
    INNER JOIN mdl_course c
        ON l.course = c.id
    INNER JOIN ( 
        SELECT
            days,
            userid,
            MAX(TIMEcreated) AS maxtime,
            COUNT(DISTINCT DATE(from_unixtime(TIMEcreated))) AS "numdates", 
            COUNT(DISTINCT course) AS numcourses,
            COUNT(*) AS numlogs
        FROM 
            mdl_logstore_standard_log l INNER JOIN mdl_course c
                ON l.course = c.id
            INNER JOIN (
                SELECT 3 AS days
           ) var 
        WHERE 
            l.TIMEcreated > (unix_timestamp() - ((60*60*24)*days))
            AND c.format != "site"
        GROUP BY userid) agg
  ON l.userid = agg.userid
  WHERE 
    l.TIMEcreated = agg.maxtime 
    AND c.format != "site"
  GROUP BY userid
  ORDER BY l.TIMEcreated DESC
  