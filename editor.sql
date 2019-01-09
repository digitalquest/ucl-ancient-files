select 
ggh.id 'grade-value history id',
FROM_UNIXTIME(ggh.timemodified, '%d/%m/%Y %T') 'time grade value was modified',
(SELECT CASE ggh.action WHEN 0 THEN 'insert'
                        WHEN 1 THEN 'update'
                        ELSE 'delete'
END) 'action',
gi.itemname 'item name',
gi.itemtype 'item type',
gi.itemmodule 'item module',
c.shortname 'course',
ggh.source 'module from which the action originated',
concat(u1.firstname , ' ', u1.lastname) 'person who performed the action',
concat(u2.firstname , ' ', u2.lastname) 'person who last modified the raw grade value',
concat(u.firstname , ' ', u.lastname) 'user who is graded'
from mdl_grade_grades_history ggh
join mdl_grade_grades gg on gg.id = ggh.oldid
join mdl_user u1 on u1.id = ggh.loggeduser 
join mdl_user u2 on u2.id = gg.usermodified 
join mdl_user u on u.id = gg.userid 
join mdl_grade_items gi on gi.id = gg.itemid
join mdl_course c on c.id = gi.courseid
where ggh.loggeduser = 425019;

CREATE OR REPLACE VIEW moodle_live.fia_v_gradechanged AS 
select 
ggh.id AS 'grade-value history id',
FROM_UNIXTIME(ggh.timemodified, '%d/%m/%Y %T') 'time grade value was modified',
(SELECT CASE ggh.action WHEN 0 THEN 'insert'
                        WHEN 1 THEN 'update'
                        ELSE 'delete'
END) 'action',
gi.itemname 'item name',
gi.itemtype 'item type',
gi.itemmodule 'item module',
c.shortname 'course',
ggh.source 'module from which the action originated',
concat(u1.firstname , ' ', u1.lastname) 'person who performed the action',
concat(u2.firstname , ' ', u2.lastname) 'person who last modified the raw grade value',
concat(u.firstname , ' ', u.lastname) 'user who is graded'
from mdl_grade_grades_history ggh
join mdl_grade_grades gg on gg.id = ggh.oldid
join mdl_user u1 on u1.id = ggh.loggeduser 
join mdl_user u2 on u2.id = gg.usermodified 
join mdl_user u on u.id = gg.userid 
join mdl_grade_items gi on gi.id = gg.itemid
join mdl_course c on c.id = gi.courseid
where ggh.loggeduser = 425019;

--
--
select 
gih.id 'grade-item history id',
FROM_UNIXTIME(gih.timemodified, '%d/%m/%Y %T') 'time grade item was modified',
(SELECT CASE gih.action WHEN 0 THEN 'insert'
                        WHEN 1 THEN 'update'
                        ELSE 'delete'
END) 'action',
gih.itemname 'item name',
gih.itemtype 'item type',
gih.itemmodule 'item module',
c.shortname 'course',
gih.source 'module from which the action originated',
FROM_UNIXTIME(gih.timemodified, '%d/%m/%Y %T') 'timemodified',
concat(u1.firstname , ' ', u1.lastname) 'person who performed the action'
from mdl_grade_items_history gih 
join mdl_user u1 on u1.id = gih.loggeduser
join mdl_course c on c.id = gih.courseid
where gih.loggeduser = 425019;

select * from mdl_grade_outcomes where usermodified = 425019;
Empty set (0.09 sec)
select * from mdl_grade_outcomes_history where loggeduser = 425019;
Empty set (0.04 sec)
select * from mdl_grade_categories_history where loggeduser = 425019;
Empty set (0.04 sec)

--eventname like '\core\event\user_loggedout'
--action like 'loggedout'
select * from mdl_logstore_standard_log where userid = 425019
and action like '%graded%'
or eventname like '%graded%'
--
select * from mdl_logstore_standard_log where userid = 425019
and eventname like '%logged%'
--
select * from mdl_logstore_standard_log where action like '%out%' limit 5
--
-- find cmis token
select
s.id 'service id', s.name 'service name', 
t.id 'token id', t.token 'token', FROM_UNIXTIME(t.timecreated, '%d/%m/%Y') 'timecreated',
concat(u.firstname , ' ', u.lastname) 'creator'
from mdl_external_services s 
join mdl_external_tokens t on t.externalserviceid = s.id
join mdl_user u on u.id = t.creatorid
where s.id = 5;
--
update mdl_external_tokens set token = '*******' where id = 357;
--

select FROM_UNIXTIME(l.timecreated, '%D %M %Y') 'time', l.eventname 'event name', l.action 'action', l.component 'component', 
l.origin 'origin', l.ip 'IP address' 
from `mdl_logstore_standard_log` l where `eventname` like '%course_reset%' 
ORDER BY l.timecreated DESC
limit 50;

select FROM_UNIXTIME(l.timecreated, '%d %m %Y') 'time', 
l.eventname 'event name', l.action 'action', 
l.origin 'origin', l.ip 'IP address',
c.id 'course id', c.shortname 'course shortname',
CONCAT (u.firstname, ' ',u.lastname) 'Name', u.username 'username'
from `mdl_logstore_standard_log` l 
join mdl_course c on c.id = l.contextinstanceid
join mdl_user u on u.id = l.userid
where `eventname` like '%course_reset%' 
-- and l.contextlevel = 50
-- AND l.timecreated > UNIX_TIMESTAMP('2017/07/23')
ORDER BY l.timecreated DESC
limit 50;

-- number of logins (total, excluding guest logins)
mysql -u moodleuser -pkw+2_nE, moodle_live

SELECT
    COUNT(*) as num_logins
FROM mdl_logstore_standard_log lsl
    INNER JOIN mdl_user u
        ON lsl.userid = u.id
WHERE 1 = 1
AND lsl.timecreated BETWEEN UNIX_TIMESTAMP(DATE_FORMAT(CURDATE() - INTERVAL 1 MONTH, '%Y/%m/01' )) AND (UNIX_TIMESTAMP(DATE_FORMAT(CURDATE(), '%Y/%m/01' )) - 1)
AND lsl.`action` = 'loggedin'
AND lsl.target = 'user'
AND lsl.component = 'core'
AND u.auth = 'ldap'
LIMIT 1;


-- test queries. a kind of clipboard
SELECT r.name, l.action, COUNT( l.userid ) AS counter
FROM prefix_log AS l
JOIN prefix_context AS context ON context.instanceid = l.course AND context.contextlevel = 50
JOIN prefix_role_assignments AS ra ON l.userid = ra.userid AND ra.contextid = context.id
JOIN prefix_role AS r ON ra.roleid = r.id
WHERE ra.roleid IN ( 3, 4, 5 ) 
GROUP BY roleid, l.action

--
 select count(id) from mdl_course;
+-----------+
| count(id) |
+-----------+
|     10989 |
+-----------+
1 row in set (0.06 sec)

select count(id) from mdl_course where timemodified BETWEEN DATE_FORMAT(CURDATE() - INTERVAL 1 YEAR, '%y-01-01' ) AND DATE_FORMAT(CURDATE(), '%y-01-01' );
select count(id) from mdl_course where year(from_unixtime(timemodified)) = year('2015');
select count(id) from mdl_course where year(from_unixtime(timemodified)) = year(2015);

select id from mdl_course where year(from_unixtime(timemodified)) = year(2015);

select id, timecreated, timemodified from mdl_course LIMIT 10;
select id, from_unixtime(timecreated), from_unixtime(timemodified) from mdl_course LIMIT 10;
select id, DATE_FORMAT(timecreated, '%y-%m-%d' ), DATE_FORMAT(timemodified, '%y-%m-%d' ) from mdl_course LIMIT 10;

select year(from_unixtime(timecreated)) from mdl_course where id = 65;
select count(id) from mdl_course where year(from_unixtime(timecreated)) = 2015;

--
Record link for BMC Remedyforce user: https://ucl--bmcservicedesk.eu0.visual.force.com/apex/BMCServiceDesk__RemedyforceConsole?record_id=a1N2000000J1cF6EAJ&objectName=Incident__c
Record link for Self Service Client: https://login.salesforce.com?startURL=/apex/bmcservicedesk__ssredirect?inc=a1N2000000J1cF6EAJ&iscalledFromEmail=true

Hi Jason,

You can access the following queries from ucl_tools ( https://moodle.ucl.ac.uk/ucl_tools/ ):
Number of courses in Moodle active (6months)
Number of active accounts  showing activity in the last (1 month, 3 month,   6 month)
Number of logins per month (can you do Last Sept > this Sept)

I've ran the others for you (on moodle-db-b)
Number of courses in Moodle total:

select count(id) from mdl_course;
+-----------+
| count(id) |
+-----------+
|     10989 |
+-----------+
1 row in set (0.06 sec)

Number of courses created so far in 2015:

select count(id) from mdl_course where year(from_unixtime(timecreated)) = 2015;
+-----------+
| count(id) |
+-----------+
|      2612 |
+-----------+
1 row in set (0.01 sec)

We'll add the queries to ucl_tools.

Best wishes

Sam

--

SELECT
    COUNT(*) as num_logins
FROM mdl_logstore_standard_log lsl
    INNER JOIN mdl_user u
        ON lsl.userid = u.id
WHERE 1 = 1
AND lsl.timecreated BETWEEN UNIX_TIMESTAMP('2016/03/01') AND (UNIX_TIMESTAMP('2016/04/01') - 1) 
AND lsl.`action` = 'loggedin'
AND lsl.target = 'user'
AND lsl.component = 'core'
AND u.auth = 'ldap'
LIMIT 1;

--
ns1.ukit.com
ns2.ukit.com

-- New version of the query: get dates dynamically. For previous version, see below
SELECT
    COUNT(*) as num_logins
FROM mdl_logstore_standard_log lsl
    INNER JOIN mdl_user u
        ON lsl.userid = u.id
WHERE 1 = 1
AND lsl.timecreated BETWEEN DATE_FORMAT( LAST_DAY(CURDATE() - INTERVAL 1 MONTH), '%y-%m-01' ) AND DATE_FORMAT(CURDATE() ,'%Y-%m-01')
AND lsl.`action` = 'loggedin'
AND lsl.target = 'user'
AND lsl.component = 'core'
AND u.auth = 'ldap'
LIMIT 1;
 
-- Previous version of the query; dates are entered manually
select count(id) as courses from mdl_course where year(from_unixtime(timecreated)) = year(CURDATE() - INTERVAL 1 YEAR);

-- Moodle
-- Total Logins
SELECT
    COUNT(*) as num_logins
FROM mdl_logstore_standard_log lsl
    INNER JOIN mdl_user u
        ON lsl.userid = u.id
WHERE 1 = 1
AND lsl.timecreated BETWEEN UNIX_TIMESTAMP(DATE_FORMAT(CURDATE() - INTERVAL 1 MONTH, '%Y/%m/01' )) AND (UNIX_TIMESTAMP(DATE_FORMAT(CURDATE(), '%Y/%m/01' )) - 1)
AND lsl.`action` = 'loggedin'
AND lsl.target = 'user'
AND lsl.component = 'core'
AND u.auth = 'ldap'
LIMIT 1;
-- Unique Logins
SELECT
    u.username
  , u.firstname
  , u.lastname
  , u.idnumber
  , u.department
  , A.num_logins
FROM mdl_user u
    INNER JOIN (SELECT lsl.userid, COUNT(*) AS num_logins
                FROM mdl_logstore_standard_log lsl
                    INNER JOIN mdl_user u
                        ON lsl.userid = u.id
                WHERE 1 = 1
                AND lsl.timecreated BETWEEN UNIX_TIMESTAMP(DATE_FORMAT(CURDATE() - INTERVAL 1 MONTH, '%Y/%m/01' )) AND (UNIX_TIMESTAMP(DATE_FORMAT(CURDATE(), '%Y/%m/01' )) - 1)
                AND lsl.`action` = 'loggedin'
                AND lsl.target = 'user'
                AND lsl.component = 'core'
                AND u.auth = 'ldap'
                GROUP BY lsl.userid) A
        ON u.id = A.userid
ORDER BY A.num_logins DESC
LIMIT 100000; 
 
-- 
-- User's courses
-- change "u.id = 2" with a new user id

SELECT u.firstname, u.lastname, c.id, c.fullname
FROM prefix_course AS c
JOIN prefix_context AS ctx ON c.id = ctx.instanceid
JOIN prefix_role_assignments AS ra ON ra.contextid = ctx.id
JOIN prefix_user AS u ON u.id = ra.userid
WHERE u.username IN ('CH1474017',
'CH1271043', 'CH0970726', 'CH4035580',
'CH0671901', 'CH0672965',
'CH4031290', 'CH4031291',
'CH4031295', 'CH4031479',
'CH1473352', 'CH1473487',
'CH1473494', 'CH1473600',
'CH1473606', 'CH1473612',
'CH1473631', 'CH1473674',
'CH1473854', 'CH1474198',
'CH1474291', 'CH1474302',
'CH1474425', 'CH1474572', 'CH1474590', 'CH1570032', 'CH1570068', 'CH4011583', 'CH4022072', 'CH4032347',
'CH4032629', 'CH4032648', 'CH4032653', 'CH4032714', 'CH1472187', 'CH1471875',
'CH4033355', 'CH4033356', 'CH4033417', 'CH4033507', 'CH4033633', 'CH4033647',
'CH4034138', 'CH4034170', 'CH4034703', 'CH4034733', 'CH4034988', 'CH4035143', 'CH4035218',
'CH4035225', 'CH1473767', 'CH4035415', 'CH4035926', 'CH4035961', 'CH4036101', 'CH4036113')

LOAD DATA INFILE 'RoleAccounts.txt' INTO TABLE tbl_name 


SELECT active.filter, fc.name, fc.value
         FROM (SELECT f.filter, MAX(f.sortorder) AS sortorder
             FROM mdl_filter_active f
             JOIN mdl_context ctx ON f.contextid = ctx.id
             WHERE ctx.id IN (1)
             GROUP BY filter
             HAVING MAX(f.active * ctx.depth) > -MIN(f.active * ctx.depth)
         ) active
         LEFT JOIN mdl_filter_config fc ON fc.filter = active.filter AND fc.contextid = 1
         ORDER BY active.sortorder
         
SELECT * FROM mdl_context WHERE contextlevel = '50' AND instanceid = '1'

SELECT * FROM mdl_role   ORDER BY sortorder ASC

SELECT * FROM mdl_user WHERE id = '2' AND deleted = '0'

SELECT name, id, enabled FROM mdl_message_processors   ORDER BY name DESC

SELECT * FROM mdl_portfolio_instance ORDER BY name

SELECT id,name,value FROM mdl_course_format_options WHERE courseid = '1' AND format = 'site' AND sectionid = '0'
SELECT ctx.*
                  FROM mdl_context ctx
                 WHERE ctx.path LIKE '/1/2/%'
                 
SELECT c.id,c.category,c.sortorder,c.shortname,c.fullname,c.idnumber,c.startdate,c.visible,c.groupmode,c.groupmodeforce , ctx.id AS ctxid, ctx.path AS ctxpath, ctx.depth AS ctxdepth, ctx.contextlevel AS ctxlevel, ctx.instanceid AS ctxinstance
              FROM mdl_course c
              JOIN (SELECT DISTINCT e.courseid
                      FROM mdl_enrol e
                      JOIN mdl_user_enrolments ue ON (ue.enrolid = e.id AND ue.userid = '2')
                 WHERE ue.status = '0' AND e.status = '0' AND ue.timestart < 1465311600 AND (ue.timeend = 0 OR ue.timeend > 1465311600)
                   ) en ON (en.courseid = c.id)
           LEFT JOIN mdl_context ctx ON (ctx.instanceid = c.id AND ctx.contextlevel = '50')
             WHERE c.id <> '1'
          ORDER BY c.visible DESC,c.sortorder ASC
          
                   78 Query     SELECT * FROM mdl_context WHERE contextlevel = '30' AND instanceid = '2'
                   
                   78 Query     SELECT r.id, r.name, r.shortname, rn.name AS coursealias 
              FROM mdl_role r
              
              JOIN mdl_role_context_levels rcl ON (rcl.contextlevel = '30' AND r.id = rcl.roleid)
         LEFT JOIN mdl_role_names rn ON (rn.contextid = '0' AND rn.roleid = r.id)
          ORDER BY r.sortorder ASC
          
                   78 Query     SELECT * FROM mdl_repository   ORDER BY sortorder
                   
                   78 Query     SELECT
                    bi.id,
                    bp.id AS blockpositionid,
                    bi.blockname,
                    bi.parentcontextid,
                    bi.showinsubcontexts,
                    bi.pagetypepattern,
                    bi.subpagepattern,
                    bi.defaultregion,
                    bi.defaultweight,
                    COALESCE(bp.visible, 1) AS visible,
                    COALESCE(bp.region, bi.defaultregion) AS region,
                    COALESCE(bp.weight, bi.defaultweight) AS weight,
                    bi.configdata
                    , ctx.id AS ctxid, ctx.path AS ctxpath, ctx.depth AS ctxdepth, ctx.contextlevel AS ctxlevel, ctx.instanceid AS ctxinstance

                FROM mdl_block_instances bi
                JOIN mdl_block b ON bi.blockname = b.name
                LEFT JOIN mdl_block_positions bp ON bp.blockinstanceid = bi.id
                                                  AND bp.contextid = '1'
                                                  AND bp.pagetype = 'admin-report-filetrash-index'
                                                  AND bp.subpage = ''
                LEFT JOIN mdl_context ctx ON (ctx.instanceid = bi.id AND ctx.contextlevel = '80')

                WHERE
                bi.parentcontextid IN ('1', '1')
                AND bi.pagetypepattern IN ('admin-report-filetrash-index','admin-report-filetrash-index-*','admin-report-filetrash-*','admin-report-*','admin-*','*')
                AND (bi.subpagepattern IS NULL OR bi.subpagepattern = '')
                AND (bp.visible = 1 OR bp.visible IS NULL)
                AND b.visible = 1

                ORDER BY
                    COALESCE(bp.region, bi.defaultregion),
                    COALESCE(bp.weight, bi.defaultweight),
                    bi.id
                    
                   78 Query     SELECT COUNT('x') FROM mdl_message WHERE useridto = '2'
                   
                   78 Query     SELECT DISTINCT contenthash from mdl_files
                   
                   78 Quit
                   
                   BETWEEN UNIX_TIMESTAMP(CURDATE() - INTERVAL 1 YEAR ) AND (UNIX_TIMESTAMP(CURDATE()) - 1)
                   
                   
                   
--
-- customers who have not placed orders. try NOT IN
--
SELECT CompanyName, ContactName, Phone
FROM Customers
     LEFT JOIN Orders
     ON Customers.CustomerID = Orders.CustomerID
WHERE Orders.CustomerID is null;

-- 
--
select u.id, u.user_name, u.active from cwd_user u
join cwd_membership m on u.id=m.child_user_id join cwd_group g on m.parent_id=g.id join cwd_directory d on d.id=g.directory_id
where g.group_name = 'confluence-administrators' and d.directory_name='Confluence Internal Directory';
--
select u.id, u.user_name, u.active from cwd_user u
where u.user_name = 'cceamou';
61968003
--
insert into cwd_membership (id, parent_id, child_user_id) values (888888, (select id from cwd_group where group_name='confluence-users' and directory_id=(select id from cwd_directory where directory_name='Confluence Internal Directory')), 61968003);
insert into cwd_membership (id, parent_id, child_user_id) values (999999, (select id from cwd_group where group_name='confluence-administrators' and directory_id=(select id from cwd_directory where directory_name='Confluence Internal Directory')), 61968003);

--
select * from mdl_logstore_standard_log 
where courseid = 39065 order by timecreated DESC;

select * from mdl_logstore_standard_log 
where timecreated BETWEEN UNIX_TIMESTAMP(DATE_FORMAT(CURDATE() - INTERVAL 1 day, '%Y/%m/%d' )) AND (UNIX_TIMESTAMP(DATE_FORMAT(CURDATE(), '%Y/%m/%d' )) - 1)



-- 21/06/2017
-- config changes

SELECT 
DATE_FORMAT( FROM_UNIXTIME( g.timemodified ) , '%Y-%m-%d' ) AS DATE, 
u.username AS USER, 
g.name AS setting, 
CASE 
 WHEN g.plugin IS NULL THEN "core"
 ELSE g.plugin
END AS plugin, 
g.value AS new_value, 
g.oldvalue AS original_value
FROM mdl_config_log  AS g
JOIN mdl_user AS u ON g.userid = u.id
ORDER BY DATE DESC;

select * from mdl_config where name like "%release%";
select * from mdl_config where name like "%version%";

-- Search the old Real Networks streaming server
--
-- check labels' table
select c.shortname 'course shortname', l.name 'label name', l.intro 'label intro' 
from mdl_label l join mdl_course c on l.course = c.id 
where l.intro like "%streaming.mediares.ucl.ac.uk%"
or l.intro like "%www.ucl.ac.uk/stream%";
-- check URLs' table
select c.shortname 'course shortname', u.name 'url name', u.intro 'url intro', u.externalurl 'URL'
from mdl_url u join mdl_course c on u.course = c.id 
where u.externalurl like "%streaming.mediares.ucl.ac.uk%"
or u.externalurl like "%www.ucl.ac.uk/stream%";
-- check forums' table
select c.shortname 'course shortname', f.name 'forum name', f.intro 'forum intro' 
from mdl_forum f join mdl_course c on f.course = c.id 
where f.intro like "%streaming.mediares.ucl.ac.uk%"
or f.intro like "%www.ucl.ac.uk/stream%";
-- check forum posts' table
select c.shortname 'course shortname', f.name 'forum name', fp.subject 'post subject', fp.message 'post message' 
from mdl_forum_posts fp join mdl_forum f on fp.discussion = f.id
join mdl_course c on f.course = c.id 
where fp.message like "%streaming.mediares.ucl.ac.uk%"
or fp.message like "%www.ucl.ac.uk/stream%";
