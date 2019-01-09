<?php
function listcat ($cat) {
   $sql1 = "SELECT id, name from mdl_course_categories where parent=$cat order by sortorder";
   $res1 = mysql_query($sql1);
   while ($row1 = mysql_fetch_assoc($res1)) {
      $categoryname = $row1['name'];
      $id = $row1['id'];
      $sql2 = "SELECT fullname from mdl_course WHERE category = $id ORDER BY fullname";
      $res2 = mysql_query($sql2) or die(mysql_error());
      $rows = mysql_num_rows($res2);
      echo "<h4>$categoryname ($rows course" . ($rows==1 ? "" : "s") . ")</h4>\n";
      echo "<blockquote>\n";
      while ($row2 = mysql_fetch_assoc($res2)) {
         echo $row2['fullname'] . "<br>\n";
      }
      listcat ($id);
      echo "</blockquote>\n";
   }
}

include '../config.php';
$conn = mysql_connect($CFG->dbhost,$CFG->dbuser,$CFG->dbpass);
mysql_select_db($CFG->dbname,$conn);
listcat(0);
?>
//listcourses.php

<?php
//
// this quick and dirty page lists all the course in moodle at present - then some stats per course
// if called with ?xls=y in the querystring - it delivers the content as excel (sort of)
// and opt in the querystring determines the report delivered
//
// peter roberts
// June 17 2009
// updated Jul 2010 to use jquery and datatables
//
//
$xls=false;
if (isset($_REQUEST['xls'])) {
    if ($_REQUEST['xls']=="y") {
        $xls=true;
    }
}
if ($xls){
    header("Content-type: application/vnd.ms-excel");
    // filename for download
    $filename = "ucl_moodle_course_stats_" . date('Ymd') . ".xls";
    header("Content-Disposition: attachment; filename=\"$filename\"");
}
if ($_REQUEST['opt'] !='')
{
    $opt=$_REQUEST['opt'];
}
else
{
    die('no option selected');
}
$sortcol="2,'asc'";
include '../config.php';
include '../course/lib.php';
global $DB; 
//set some styles
echo "<html><head>";
// make it sortable if on screen
if (!$xls) {
    echo "<link rel=stylesheet type=text/css href=tools.css>";
    ?>
    <script type="text/javascript" language="javascript" src="jquery.js"></script>
    <script type="text/javascript" language="javascript" src="datatables/media/js/jquery.dataTables.js"></script>
    <link rel="stylesheet" type="text/css" href="datatables/media/css/demo_table.css" />

<?php

}

echo "</head><body>";
// table header

//get categories for later
$displaylist = array();
$catparentlist = array();
$capabilities = array('moodle/course:create', 'moodle/category:manage');
make_categories_list($displaylist);


//print_r ($displaylist);
//die();

//get list of courses
//
// note the 'salientdata' is used to show in the table
//
switch ($opt)
{
case 'inactive':
    //salientdata is inactivity in days
    $records=$DB->get_records_sql('SELECT c.id,
                          c.idnumber,
                          c.shortname,
                          c.fullname,
                          c.startdate,
                          cc.name as category,
                          cc.id as categoryid,
                          DATEDIFF(CURDATE(),FROM_UNIXTIME(max(timeaccess))) As salientdata
                          FROM mdl_course c,
                          mdl_user_lastaccess,
                          mdl_course_categories cc
                          where courseid=c.id
                          and c.category=cc.id
                          GROUP BY courseid
                          HAVING salientdata>364
                          ORDER BY salientdata DESC');
                          
                          $salientdatalabel="Inactivity in days";
						  $headinglabel="Inactive courses";
                          $sortcol="5,'desc'";
break;
case 'unlive':
    $records=$DB->get_records_sql('SELECT c.id,
                          c.idnumber,
                          c.shortname,
                          c.fullname,
                          c.startdate,
                          cc.name as category,
                          cc.id as categoryid,
                          c.visible as salientdata

                          FROM mdl_course c,
                          mdl_course_categories cc
                          Where c.visible=0
                          and c.category=cc.id
                          ORDER BY c.startdate asc
    ');
                          $salientdatalabel="visibility" ;
						  $headinglabel="Hidden courses";
                          $sortcol="4,'asc'";

break;
case 'dupeidnumbers':
    $records=$DB->get_records_sql("SELECT c.id,
                          c.idnumber,
                          c.shortname,
                          c.fullname,
                          c.startdate,
                          cc.name as category,
                          cc.id as categoryid,
                          c.visible as salientdata
                          FROM mdl_course c,
                          mdl_course_categories cc
                          WHERE c.idnumber != ''
                          and cc.id=c.category
                          AND c.idnumber
                          IN (
                              SELECT idnumber
                                FROM (
                                SELECT idnumber, count( idnumber ) AS cnt
                                FROM mdl_course AS dt1
                                GROUP BY idnumber
                                HAVING cnt >1
                            ) AS dt2
                          ) order by c.idnumber");

                          $salientdatalabel="visibility" ;
						  $headinglabel="Duplicate Portico ID numbers";
                          $sortcol="5,'asc'";

  break;
case 'coursemenu':
    $records=$DB->get_records_sql("SELECT c.id,
                          c.idnumber,
                          c.shortname,
                          c.fullname,
                          c.startdate,
                          cc.name as category,
                          cc.id as categoryid,
                          c.visible as salientdata
                          FROM mdl_course c,
                          mdl_course_categories cc,
                          mdl_block_instances b
                          WHERE  cc.id=c.category
                          AND c.id=b.parentcontextid
                          and b.blockname = 'course_menu'
                          order by c.idnumber");

                          $salientdatalabel="visibility" ;
						  $headinglabel="???? Course menu";
                          $sortcol="0,'asc'";

  break;

case 'mycourses':
    $records=$DB->get_records_sql("SELECT c.id,
                          c.idnumber,
                          c.shortname,
                          c.fullname,
                          c.startdate,
                          cc.name as category,
                          cc.id as categoryid,
                          c.visible as salientdata
                          FROM mdl_course c,
                          mdl_course_categories cc,
                          mdl_block_instances b
                          WHERE  cc.id=c.category
                          AND c.id=b.parentcontextid
                          and b.blockname = 'myCourses'
                          order by c.idnumber");

                          $salientdatalabel="visibility" ;
						  $headinglabel="???? mycourses";
                          $sortcol="0,'asc'";

  break;
  



  default:
 // code to be executed if n is different from both label1 and label2;


}
if (!$xls) {
    echo("<h2>UCL Moodle tools: $headinglabel</h2>");
}

echo "\n<table id=\"sortabl\" class=\"display\">\n";
echo "<thead>\n<tr>\n";
echo "<th>ID</th>\n";
echo "<th>Full name</th>\n";
echo "<th>Category</th>\n";
echo "<th>Path</th>\n";
echo "<th>Portico ID</th>\n";
if (!$xls) {
echo "<th>Actions</th>\n";
}
echo "<th>Start date</th>\n";
echo "<th> $salientdatalabel </th>\n";
if (!$xls) {
echo "<th>Zap</th>\n";
}
echo "</tr>\n</thead>\n<tbody>\n";



// loop through the courses
foreach ($records as $id => $record) {
    //print the  basics - course id, short name and start date
    echo("<tr>\n");
    echo("<td>$record->id</td>\n");
    echo("<td>$record->fullname</td>\n");
    echo("<td>$record->category</td>\n");
    if (isset($displaylist[$record->categoryid])){
        echo("<td>".$displaylist[$record->categoryid]."</td>\n");
    } else {
        echo("<td> (category hidden) </td>\n");
    }
    echo("<td>$record->idnumber</td>\n");
    if (!$xls) {
		echo("<td width=\"200\"><a target=\"_blank\" href=\"". $CFG->wwwroot ."/course/view.php?id=" .$record->id ."\">View course</a></br>");
        echo("<a target=\"_blank\" href=\"". $CFG->wwwroot ."/course/edit.php?id=" .$record->id ."\">View settings</a></br>");
        echo("<a target=\"_blank\" href=\"". $CFG->wwwroot . "/ucl_tools/generate_email.php?id=$record->id\">Email owner(s)</a></td>\n");
    }
    echo("<td>" . date("j/m/Y", date($record->startdate))."</td>\n");
    echo("<td>" . $record->salientdata."</td>\n");
    if (!$xls) {

        echo("<td width=60><a target=\"_blank\" href=\"". $CFG->wwwroot . "/course/delete.php?id=$record->id\">delete</a></td>\n");

    }
    echo "</tr>\n";
}

//all done
echo "</tbody>\n</table>\n";
if (!$xls){
?>
<script type="text/javascript">
    $(document).ready(function() {
	$('#sortabl').dataTable({
        
        "sPaginationType": "full_numbers",
        "iDisplayLength": 80,
        "aaSorting": [[<?php print $sortcol; ?>]]
        });
} );
</script>
<?php
}
echo "</body></html>";

?>
// courses.php


<?php
//
// this quick and dirty page lists all the course in moodle at present - then some stats per course
// if called with ?xls=y in the querystring - it delivers the content as excel (sort of)
//
// peter roberts
// June 17 2009
// last updated Aug 2010 to make it sortable with jquery/datatables
// also added CATEGORY to the results
//
//

$xls=false;

if (isset($_REQUEST['xls'])) {
    if ($_REQUEST['xls']=="y") {
        $xls=true;
    }
}

if ($xls) {
    header("Content-Type: application/vnd.ms-excel");
    // filename for download
    $filename = "ucl_moodle_course_stats_" . date('Ymd') . ".xls";
    header("Content-Disposition: attachment; filename=\"$filename\"");
}

include '../config.php';
require_once("../course/lib.php");
global $DB;


//get categories for later
$displaylist = array();
$parents=array();
make_categories_list($displaylist,$parents);
//set some styles
echo "<html><head>";


if (!$xls) {

    echo "<link rel=stylesheet type=text/css href=tools.css />";
    echo "<script type=\"text/javascript\" language=\"javascript\" src=\"jquery.js\"></script>";
    echo "<script type=\"text/javascript\" language=\"javascript\" src=\"datatables/media/js/jquery.dataTables.js\"></script>";
    echo "<link rel=\"stylesheet\" type=\"text/css\" href=\"datatables/media/css/demo_table.css\" />";

}
echo "</head><body>";
// table header

if (!$xls) {
    echo "<h2>UCL tools: Moodle report for all courses</h2>";
}
echo "<table id=\"sortabl\" class=\"display\">";
echo "<thead><tr>";
echo "<th>course id</th>";
echo "<th>full name</th>";
echo "<th>idnumber</th>";
echo "<th>category</th>";
echo "<th>path</th>";
echo "<th>start date</th>";
echo "<th>sections</th>";
echo "<th>quizzes</th>";
echo "<th>forum posts</th>";
echo "<th>lessons</th>";
echo "<th>assignment submissions</th>";
echo "<th>resources</th>";
echo "<th>enrolled</th>";
echo "<th>days inactive</th>";
echo "</tr></thead><tbody>\n";

//get list of courses

$sql1="SELECT c.id, c.shortname, c.idnumber, c.fullname, c.startdate, cc.name as category, cc.id as categoryid,
        DATEDIFF(CURDATE(),FROM_UNIXTIME(max(timeaccess))) As inactivity
        FROM mdl_course c, mdl_course_categories cc, mdl_user_lastaccess ma
        WHERE cc.id=c.category  and ma.courseid=c.id
        GROUP BY courseid
        ORDER BY c.id";
//echo $sql1;
$records=$DB->get_records_sql($sql1);
// loop through the courses
foreach ($records as $id => $record) {
    //print the  basics - course id, short name and start date
    echo("<tr>");
    echo("<td>".$record->id ."</td><td><a target=_blank href=". $CFG->wwwroot ."/course/view.php?id=" .$record->id .">".$record->fullname ."</a></td>");
    echo("<td>".$record->idnumber ."</a></td>");
    echo("<td>".$record->category ."</a></td>");
    if (isset($displaylist[$record->categoryid])){
        echo("<td>".$displaylist[$record->categoryid]."</td>\n");
    } else {
        echo("<td> (category hidden) </td>\n");
    }
    echo("<td>" . date("j/m/Y", date($record->startdate)) ."</td>");

// get number of sections in the course
    $sql2 = "SELECT count( mdl_course_sections.id ) AS pc
            FROM mdl_course_sections, mdl_course
            WHERE mdl_course_sections.course = mdl_course.id
            AND mdl_course.id=" . $record->id;
    $pc=$DB->get_record_sql($sql2);
    echo "<td>". $pc->pc ."</td>";

// number of quizzes
    $sql2 = "SELECT count( mdl_quiz.id ) AS pc
            FROM mdl_course, mdl_quiz
            WHERE mdl_quiz.course = mdl_course.id
            AND mdl_course.id=" . $record->id;
    $pc=$DB->get_record_sql($sql2);
    echo "<td>". $pc->pc ."</td>";

// number of forum posts
    $sql2 = "SELECT count( mdl_forum_posts.id ) AS pc
            FROM mdl_course, mdl_forum, mdl_forum_discussions, mdl_forum_posts
            WHERE mdl_forum.course = mdl_course.id
            AND mdl_forum_discussions.forum = mdl_forum.id
            AND mdl_forum_posts.discussion = mdl_forum_discussions.id
            AND mdl_course.id=" . $record->id;
    $pc=$DB->get_record_sql($sql2);
    echo "<td>". $pc->pc ."</td>";

// number of lessons
$sql2 = "SELECT count( mdl_lesson.id ) AS pc
            FROM mdl_course, mdl_lesson
            WHERE mdl_lesson.course = mdl_course.id
            AND mdl_course.id=" . $record->id;
    $pc=$DB->get_record_sql($sql2);
    echo "<td>". $pc->pc ."</td>";

//number of assignment submissions
$sql2 = "SELECT count( mdl_assignment_submissions.id ) AS pc
            FROM mdl_course, mdl_assignment_submissions,mdl_assignment
            WHERE mdl_assignment.course = mdl_course.id
            AND mdl_assignment_submissions.assignment=mdl_assignment.id
            AND mdl_course.id=" . $record->id;
    $pc=$DB->get_record_sql($sql2);
    echo "<td>".  $pc->pc ."</td>";

//number of resources
$sql2 = "SELECT count( mdl_resource.id ) AS pc
            FROM mdl_course, mdl_resource
            WHERE mdl_resource.course = mdl_course.id
            AND mdl_course.id=" . $record->id;
    $pc=$DB->get_record_sql($sql2);
    echo "<td>". $pc->pc ."</td>";


//number enrolled

    $sql2 = "SELECT count( ra.id ) AS pc
    FROM mdl_course cr
    JOIN mdl_context ct ON ( ct.instanceid = cr.id )
    LEFT JOIN mdl_role_assignments ra ON ( ra.contextid = ct.id )
    WHERE ct.contextlevel =50
    AND cr.id=" . $record->id;
    $pc=$DB->get_record_sql($sql2);

    echo "<td>". $pc->pc ."</td>";
//inactive days
    echo("<td>".$record->inactivity ."</a></td>");

//finish this row
    echo "</tr>\n";
}

//all done
echo "</tbody></table>";

?>
<script type="text/javascript">
    $(document).ready(function() {
	$('#sortabl').dataTable({

        "sPaginationType": "full_numbers",
        "iDisplayLength": 50
        
        });
} );
</script>
<?php
echo "</body></html>";
?>
//all_courses.php