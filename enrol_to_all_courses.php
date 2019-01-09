<?php
require_once(PATH_TO_MOODLE_ROOT . '/config.php');
define('CLI_SCRIPT', true);
$courses = get_courses("all", "c.sortorder ASC", "c.id");

require_once($CFG->dirroot . '/lib/coursecatlib.php');
$allcourses = coursecat::get(0)->get_courses(array('recursive' => true));

//
// enroll student to course (roleid = 5 is student role)
function enroll_to_course($courseid, $userid, $roleid=5, $extendbase=3, $extendperiod=0)  {
    global $DB;

    $instance = $DB->get_record('enrol', array('courseid'=>$courseid, 'enrol'=>'manual'), '*', MUST_EXIST);
    $course = $DB->get_record('course', array('id'=>$instance->courseid), '*', MUST_EXIST);
    $today = time();
    $today = make_timestamp(date('Y', $today), date('m', $today), date('d', $today), 0, 0, 0);

    if(!$enrol_manual = enrol_get_plugin('manual')) { throw new coding_exception('Can not instantiate enrol_manual'); }
    switch($extendbase) {
        case 2:
            $timestart = $course->startdate;
            break;
        case 3:
        default:
            $timestart = $today;
            break;
    }  
    if ($extendperiod <= 0) { $timeend = 0; }   // extendperiod are seconds
    else { $timeend = $timestart + $extendperiod; }
    $enrolled = $enrol_manual->enrol_user($instance, $userid, $roleid, $timestart, $timeend);
    add_to_log($course->id, 'course', 'enrol', '../enrol/users.php?id='.$course->id, $course->id);

    return $enrolled;
}