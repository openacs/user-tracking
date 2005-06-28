ad_page_contract {
    @author sergiog (sergiog@tid.es)
    @author doa (doa@tid.es)
    @creation-date 2005-01-10
} -query { 
} -properties {
aux:onevalue
}

if {![exists_and_not_null onlyuser] & ![exists_and_not_null onlylines]} {
	set message "[_ user-tracking.making_statistics_site]"
} elseif {![exists_and_not_null onlylines]} {
	set message "[_ user-tracking.making_statistics_users] $onlyuser"
	set onlyuser [string trimleft $onlyuser " "]
} elseif {![exists_and_not_null onlyuser]} {
	set message "[_ user-tracking.making_statistics_communities] $onlylines"
	set onlylines [string trimleft $onlylines " "]
} else {
	set message "[_ user-tracking.making_statistics_advanced]"
	set onlylines [string trimleft $onlylines " "]
	set onlyuser [string trimleft $onlyuser " "]
}

if { [string length $month] == 1} {
	set month "0${month}"
}

set logs [ns_config "ns/server/[ns_info server]/module/nslog" file] 
set patron "(.*)([ns_info server]\.log$)"
regexp $patron $logs all logdir part2 ]
ns_log notice "LOGDIR=$logdir"

set todayyear [template::util::date::get_property year [template::util::date::today]]
set todaymonth [template::util::date::get_property month [template::util::date::today]]
set todayday [template::util::date::get_property day [template::util::date::today]]

   if {$month < 12} {
   	set nextmonth [expr $month +1]
   	set nextyear $year
   } else {
   	set nextmonth 1
   	set nextyear [expr $year + 1]
   }
   if { [string length $nextmonth] == 1} {
	set nextmonth "0${nextmonth}"
   }   

if {[exists_and_not_null LastTime]} {
      set campos [split $LastTime "/-"]
      set lastyear [lindex $campos 2]
      set lastmonth [lindex $campos 1]
      set lastday [lindex $campos 0]
      
      set lastdate [clock scan "$lastyear-$lastmonth-$lastday"]
      set todaydate [clock scan "$todayyear-$todaymonth-$todayday"]

      set logresolvemerge ""
      if { $lastmonth == $todaymonth  } {
        if {[expr $lastday + 1] <= [expr $todayday - 1]} {
           set expresion "\[[expr $lastday + 1]"
           for {set x [expr $lastday + 2]} {$x<=[expr $todayday - 1]} {incr x} {
              append expresion ",$x"
           }
           append expresion "\]"
           set logresolvemerge "-LogFile=[user-tracking::get_user_tracking_dir]/tools/logresolvemerge.pl ${logdir}elane.log.$year-$month-${expresion}* ${logdir}elane.log |"
           ns_log notice $logresolvemerge
        } else {
           set logresolvemerge "-LogFile=${logdir}elane.log"
        }
      } else {
      	if {[expr $lastday + 1] <= [template::util::date::get_property days_in_month "$lastyear$lastmonth"] } {
           set expresion "\[[expr $lastday + 1]"
           for {set x [expr $lastday + 2]} {$x<=[template::util::date::get_property days_in_month "$lastyear$lastmonth"]} {incr x} {
              append expresion ",$x"
           }
           append expresion "\]"
           ns_log notice $expresion  
           set logresolvemerge "-LogFile=[user-tracking::get_user_tracking_dir]/tools/logresolvemerge.pl ${logdir}elane.log.$year-$month-${expresion}* ${logdir}elane.log.$nextyear-$nextmonth-01* |"
           ns_log notice $logresolvemerge
   	}  	
      }
} else {
   set logresolvemerge "-LogFile=[user-tracking::get_user_tracking_dir]/tools/logresolvemerge.pl "
   append logresolvemerge " ${logdir}elane.log.$year-$month-0\[2-9\]* "
   append logresolvemerge " ${logdir}elane.log.$year-$month-1\[0-9\]* "
   append logresolvemerge " ${logdir}elane.log.$year-$month-2\[0-9\]* "
   append logresolvemerge " ${logdir}elane.log.$year-$month-3\[0-1\]* "
   append logresolvemerge " ${logdir}elane.log.$nextyear-$nextmonth-01* "
   if {$month == $todaymonth} {
  	append logresolvemerge  " ${logdir}elane.log |"
   } else {
   	   append logresolvemerge " |"
   }
}

ad_progress_bar_begin \
    -title "" \
    -message_1 "#user-tracking.updating_datafile#" \
    -message_2 "#user-tracking.we_will_continue#"

ns_write "<h2>$message</h2><blockquote>"

set binPerl [parameter::get -parameter "PerlPath"]
set execAnalyzer [list "$binPerl" "[user-tracking::get_user_tracking_dir]/www/awstats/cgi-bin/awstats_dotlrn.pl" "-config=$config" "-update" "-onlycoms=$onlylines" "-onlyusers=$onlyuser" "-month=$month" $logresolvemerge "-year=$year"]
ns_log notice "$execAnalyzer"
catch {exec [lindex $execAnalyzer 0] [lindex $execAnalyzer 1] [lindex $execAnalyzer 2] [lindex $execAnalyzer 3] [lindex $execAnalyzer 7] [lindex $execAnalyzer 8] [lindex $execAnalyzer 4] [lindex $execAnalyzer 5] [lindex $execAnalyzer 6]} aux
ns_log notice $aux
set DataFileName [user-tracking::get_data_file_name $onlylines $onlyuser $config $year $month]
ns_log notice $DataFileName
set nodata_p "0"
set noloading 1
if {![file exists $DataFileName]} {
	set nodata_p "1"
set noloading 0
	
}

ad_progress_bar_end -url "${url}type=$type&onlyuser=$onlyuser&onlylines=$onlylines&year=$year&month=$month&nodata_p=$nodata_p&noloading=$noloading"

