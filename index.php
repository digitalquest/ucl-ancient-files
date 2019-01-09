<html>
<head>
<title>UCL Moodle tools</title>
<link rel=stylesheet type="text/css" href="tools.css">
<!-- BOOTSTRAP -->
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
</head>
<body>
<h1>UCL Moodle tools</h1>
<i>This is the May 2016 release of UCL tools</i><br>
<?php
$machine = `hostname`;
echo "You are currently using <b>$machine</b><br>\n";
?>

<h3>Course Admin </h3>
<ul>
	<li><a href=listcourses.php>List all courses within their categories</a>
    <li>Courses inactive for 365 days or more: <a target=_blank href=courses.php?opt=inactive>on screen (sortable)</a> | <a target=_blank href=courses.php?opt=inactive&xls=y>spreadsheet</a> - <i>As Matt spotted - items drop off the inactive course report if you look at the courses listed! Workaround - use the spreadsheet!</i> <span class="label label-danger">Not working</span></li>
    <li>Courses not currently visible: <a target=_blank href=courses.php?opt=unlive>on screen (sortable)</a> | <a target=_blank href=courses.php?opt=unlive&xls=y>spreadsheet</a> <span class="label label-danger">Not working</span></li>
    <li>Courses with duplicate idnumbers: <a target=_blank href=courses.php?opt=dupeidnumbers>on screen (sortable)</a> | <a target=_blank href=courses.php?opt=dupeidnumbers&xls=y>spreadsheet</a> (sort by idnumber after the page has loaded)  <span class="label label-danger">Not working</span></li>
   <!--
	<li>NEW! Courses with course menu block: <a target=_blank href=courses.php?opt=coursemenu>on screen (sortable)</a> | <a target=_blank href=courses.php?opt=dupeidnumbers&xls=y>spreadsheet</a> (sort by idnumber after the page has loaded)</li>
    <li>NEW! Courses with my courses block: <a target=_blank href=courses.php?opt=mycourses>on screen (sortable)</a> | <a target=_blank href=courses.php?opt=dupeidnumbers&xls=y>spreadsheet</a> (sort by idnumber after the page has loaded)</li>
    -->
    <li>All courses with extra stats:  <a target=_blank href=all_courses.php>on screen (sortable)</a> - SLOW and somewhat intensive | <a target=_blank href=all_courses.php?xls=y>spreadsheet (recommended)</a> <span class="label label-danger">Not working</span></li>
    
</ul>

<h3>Users and roles</h3>
<ul>
<li><a target=_blank href=roles.php>List all administrators, course creators, tutors, course admins and non-editing teachers</a>
<li><a target=_blank href=ucl-mdl-usersync.php>Import new staff accounts into Moodle database</a> - should be run once a day by a cron job, see SCP 3275 <span class="label label-danger">Not working</span>
<li><a target=_blank href="get_mdl_tutors.php">Get all Moodle tutors for a category</a>
<li><a target=_blank href="mdl_manual_accounts.php">Manual accounts report with custom profile fields (sortable)</a>
<li><a target=_blank href=query_mdl_accounts.php>View non-UCL accounts in the Moodle database</a>
</ul>

<h3>Assignments and Quizzes</h3>

<ul>
course IDs between two dates</a></li>
	<li><a target=_blank href=turnitin2.php>Show closing dates of TurnItIn assignments with assignment names and course IDs between two dates</a></li>
	<li><a target=_blank href=turnitin_expected.php>Show number of TurnItIn assignments expected by day</a></li>
	<li><a target=_blank href=assgt_submission.php>Number of Moodle assignment submissions by date range </a> <span class="label label-success">New</span></li>
	<li><a target=_blank href=assgt_due.php>Number of active Moodle assignments by date range </a> <span class="label label-success">New</span></li>
	<li><a target=_blank href=mdl_assignments.php>Show what Moodle assignments are due</a></li>
	<li><a target=_blank href=quiz_close.php>Find when quizzes close with a date range</a></li>
</ul>

<h3>Stats</h3>
<ul>
	<li><a target=_blank href=active-courses.php>Number of active courses in the last X months</a></li>
	<li><a target=_blank href=logins-in-last.php>Number of active accounts showing activity in the last X months</a></li>
	<li><a target=_blank href=logins-per-month.php>Logins per month for current year from January</a></li>
	<li><a target=_blank href=total_courses.php>Number of courses in Moodle</a></li> 
	<li><a target=_blank href=courses_created_this_year.php>Number of courses created this year</a></li> 
	<li><a target=_blank href=courses_created_last_year.php>Number of course created last year</a></li> 
	<!-- hidden because it creates heavy load on db
     <li><a target=_blank href="mdl_log-stats.php">Log Stats</a> - gives last month's Unique logins, Total logins and New courses created. Plus total all and active courses (can be SLOW)</li>
	 -->
</ul>

<i>please email LTA-learning@ucl.ac.uk with queries</i>
</body>
</html>
