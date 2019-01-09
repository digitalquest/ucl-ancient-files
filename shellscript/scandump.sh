#!/usr/bin/perl

if ($ARGV[0] eq '--skipuse') {
   $copydb = 0;
   $db = $ARGV[1];
   $table = $ARGV[2];
}
else {
   $copydb = 1;
   $db = $ARGV[0];
   $table = $ARGV[1];
}

print << 'END';
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
END

while ($input = <STDIN> and $input !~ /^-- Current Database: `$db`$/) {}
if (!$input) {
   die "Can't find database `$db`\n";
}
print $input;

while ($input = <STDIN> and $input !~ /^USE /) {
   if ($copydb) {
      print $input;
   }
}
if ($copydb) {
   print $input;
}

if ($table) {
   while ($input = <STDIN>
          and $input !~ /^-- Current Database:/
          and $input !~ /^-- Table structure for table `$table`$/) {}
   if (!$input or $input =~ /^-- Current Database:/) {
      die "Can't find table `$table`\n";
   }
   print $input;
   while ($input = <STDIN>
          and $input !~ /^-- Current Database:/
          and $input !~ /^-- Dumping routines for database/
          and $input !~ /^-- Temporary table structure for view/
          and $input !~ /^-- Table structure for table/) {
      print $input;
   }
}
else {
   $view = 0;
   while ($input = <STDIN> and $input !~ /^-- Current Database:/) {
      print $input;
      if ($input =~ /^-- Temporary table structure for view/) {
         $view = 1;
      }
   }
   if ($view) {
      while ($input = <STDIN> and $input !~ /^-- Current Database: `$db`$/) {}
      if (!$input) {
         die "Can't find view definition for database `$db`\n";
      }
      while ($input = <STDIN> and $input !~ /^-- Final view structure for view/) {}
      while ($input = <STDIN> and $input !~ /^-- Current Database:/) {
         print $input;
      }
   }
}


if ($input) {
print << 'END';
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
END
}
