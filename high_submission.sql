
-- turn it in submissions
SELECT DATE_FORMAT(FROM_UNIXTIME(timecreated), '%d-%m-%Y') as 'time created', count(id) as 'tii2 submissions' 
FROM `mdl_logstore_standard_log`
WHERE component = 'mod_turnitintooltwo' 
and eventname = '\\mod_turnitintooltwo\\event\\add_submission'
and timecreated BETWEEN UNIX_TIMESTAMP('2015/09/01') AND UNIX_TIMESTAMP('2016/03/01')
GROUP BY timecreated DIV (60*60*24)
INTO OUTFILE 'tti_in_log.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

--turn it in 2 assignment modified on a given day
SELECT DATE_FORMAT(FROM_UNIXTIME(submission_modified), '%d-%m-%Y') AS 'date modified', count(id) AS 'Assignments' 
FROM `mdl_turnitintooltwo_submissions`  
WHERE submission_modified > unix_timestamp('2015/09/01') 
AND submission_modified < unix_timestamp('2017/03/01') 
group BY submission_modified DIV (60*60*24)

-- time slot tii2 file created 
SELECT DATE_FORMAT(FROM_UNIXTIME(timecreated), '%d-%m-%Y') as 'time slot', count(id) as 'No files created'
FROM `mdl_files` 
WHERE filename IS NOT NULL
and filename <> '.'
and component = 'mod_turnitintooltwo'
and timecreated BETWEEN UNIX_TIMESTAMP('2015/09/01') AND UNIX_TIMESTAMP('2016/03/01')
GROUP BY timecreated DIV (60*60*24)
INTO OUTFILE 'tii_files_created.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- No of assgmt uploads. time slot. NOT tii2 09/01/2017
--SELECT DATE_FORMAT(FROM_UNIXTIME(timecreated), '%d-%m-%Y') AS 'time slot' , count(id) as 'No of uploads' 
--FROM `mdl_logstore_standard_log` 
WHERE `action` LIKE "%upload%" 
AND eventname like "%assignsubmission%"
AND timecreated BETWEEN UNIX_TIMESTAMP('2015/09/01') AND UNIX_TIMESTAMP('2016/03/01') 
GROUP BY timecreated DIV (60*60*24)
INTO OUTFILE 'num_uploads.csv'
FIELDS TERMINATED BY ','
--ENCLOSED BY '"'
--LINES TERMINATED BY '\n';

--NORMAL ASSIGNMENTS created on a given day
SELECT DATE_FORMAT(FROM_UNIXTIME(timecreated), '%d-%m-%Y') AS 'time created', count(id) as 'submissions (not tii)' 
FROM `mdl_assign_submission` 
WHERE timecreated > unix_timestamp('2015/09/01') AND timecreated < unix_timestamp('2016/03/01') 
GROUP BY timecreated DIV (60*60*24)

-- mdlfiles created on a given day
SELECT  DATE_FORMAT(FROM_UNIXTIME(timecreated), '%d-%m-%Y') as 'time created', count(id) as 'files created'
FROM `mdl_files` 
WHERE timecreated BETWEEN UNIX_TIMESTAMP('2015/09/01') AND UNIX_TIMESTAMP('2016/03/01')
GROUP BY timecreated DIV (60*60*24)


-- quiz attempts on a given day
SELECT  DATE_FORMAT(FROM_UNIXTIME(timestart), '%d-%m-%Y') as 'date started', count(id) as 'quiz attempts'
FROM `mdl_quiz_attempts` 
WHERE timestart BETWEEN UNIX_TIMESTAMP('2015/09/01') AND UNIX_TIMESTAMP('2016/03/01')
GROUP BY timestart DIV (60*60*24)

--
--
-- myfeedback related events
SELECT * 
FROM `mdl_logstore_standard_log` 
WHERE eventname like "%myfeedback%"
limit 5
;
--
SELECT DATE_FORMAT(FROM_UNIXTIME(l.timecreated), '%d-%m-%Y %T') as 'time created', 
l.eventname 'eventname', 
l.component 'component',
l.action 'action',
concat(u1.firstname, ' ', u1.lastname) 'Name',
u1.department 'department',
u1.username 'username',
u1.email 'email',
concat(u1.firstname, ' ', u1.lastname) 'related user'
FROM `mdl_logstore_standard_log` l
join mdl_user u1 ON l.userid = u1.id
join mdl_user u2 ON l.relateduserid = u2.id
WHERE l.eventname like "%myfeedback%"
and l.timecreated BETWEEN UNIX_TIMESTAMP('2017/03/23') AND UNIX_TIMESTAMP('2017/04/24')
limit 2
;
--
SELECT u1.department 'department', count(l.id) 'No of actions'
FROM `mdl_logstore_standard_log` l
join mdl_user u1 ON l.userid = u1.id
WHERE l.eventname like "%myfeedback%"
and l.timecreated BETWEEN UNIX_TIMESTAMP('2017/03/23') AND UNIX_TIMESTAMP('2017/04/24')
group by u1.department
limit 15
;

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
