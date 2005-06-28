ad_page_contract {
    @author sergiog (sergiog@tid.es)
    @author doa (doa@tid.es)
    @creation-date 2005-01-10
} -query { 
	{config ""}
	{onlyuser ""}
	{onlylines ""}
	{url ""}
	{LastTime ""}
	{month ""}
	{year ""}
} -properties {
aux:onevalue
}

if { [string length $month] == 1} {
	set month "0${month}"
}

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

set logs [ns_config "ns/server/[ns_info server]/module/nslog" file] 
set patron "(.*)([ns_info server]\.log$)"
regexp $patron $logs all logdir part2 ]

set message "[_ user-tracking.updating_statistics]"
if {[exists_and_not_null LastTime]} {

      set campos [split $LastTime "/-"]
      
      set lastyear [lindex $campos 2]
      set lastmonth [lindex $campos 1]
      set lastday [lindex $campos 0]

      set todayyear [template::util::date::get_property year [template::util::date::today]]
      set todaymonth [template::util::date::get_property month [template::util::date::today]]
      set todayday [template::util::date::get_property day [template::util::date::today]]
      
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
}

ad_progress_bar_begin \
    -title "" \
    -message_1 "#user-tracking.updating_datafile#" \
    -message_2 "#user-tracking.we_will_continue#"

ns_write "<h2>$message</h2><blockquote>"

set aux ""
if { [exists_and_not_null logresolvemerge] } {
set execAnalyzer [list "perl" "[user-tracking::get_user_tracking_dir]/www/awstats/cgi-bin/awstats_dotlrn.pl" "-config=$config" "-update" "-onlycoms=$onlylines" "-onlyusers=$onlyuser" "$logresolvemerge" "-month=$month" "-year=$year"]
ns_log notice "$execAnalyzer"
catch {exec [lindex $execAnalyzer 0] [lindex $execAnalyzer 1] [lindex $execAnalyzer 2] [lindex $execAnalyzer 3] [lindex $execAnalyzer 6] [lindex $execAnalyzer 4] [lindex $execAnalyzer 5] [lindex $execAnalyzer 7] [lindex $execAnalyzer 8]} aux
ns_log notice $aux
}

if {[exists_and_not_null url]} {
	switch $url {
		users-card { ad_progress_bar_end -url $url?user_id=$onlyuser&year=$year&month=$month}
		communities-card {ad_progress_bar_end -url $url?community_id=$onlylines&year=$year&month=$month}
		advanced-card {ad_progress_bar_end -url $url?onlylines=$onlylines&onlyuser=$onlyuser&year=$year&month=$month}
	}
} else {
	ad_progress_bar_end -url site-card?year=$year&month=$month
}

