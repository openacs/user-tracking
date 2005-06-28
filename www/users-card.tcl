
ad_page_contract {
    @author doa (doa@tid.es)
    @author sergiog (sergiog@tid.es)
    @creation-date 2005-03-01
} -query { 
    {type "general"}
    {onlyuser ""}
    {onlylines ""}    
    {config "site"}
    {nodata_p "0"}
    {noloading "1"}
    {pretype ""}
    {month ""}
    {year ""}
    {mydate:array ""}
    {user_id}
} -properties {    
    TotalUnique:onevalue
    TotalPages:onevalue
    TotalAsked:onevalue
    NofMembers:onevalue
    NofUsers:onevalue
    LastVisit:onevalue
    LastRegistration:onevalue
    TotalVisits:onevalue
    DataFileName:onevalue
    FirstTime:onevalue
    LastTime:onevalue
    LastUp:onevalue
    config:onevalue
    pretype:onevalue   
    datebox:onevalue
    mydate:onevalue
    today:onevalue
    asked_day:onevalue
    user_id:onevalue
    hidden:onevalue
    LastLine:onevalue

}


if {![exists_and_not_null referer]} {
    set referer "[user-tracking::get_package_url]/users-stats"
}

if {![exists_and_not_null user_id]} {    
    ad_returnredirect $referer
}

if {![empty_string_p $user_id]} {
	set new_user_id [ad_conn user_id]
        if {![string equal $new_user_id $user_id]} {		
        	ad_require_permission [ad_conn package_id] "admin"
	}
}


set page_title [_ user-tracking.User_Stats]
set context [list $page_title]

if {![db_0or1row select_user_info {}]} {
    ad_return_complaint 1 "<li>[_ dotlrn.couldnt_find_user_id [list user_id $user_id]]</li>"
    ad_script_abort
}

if {[empty_string_p $screen_name]} {
    set screen_name "&lt;[_ dotlrn.none_set_up]&gt;"
}
set registration_date [lc_time_fmt $registration_date "%q"]
if {![empty_string_p $last_visit]} {
    set last_visit [lc_time_fmt $last_visit "%q"]
}

if {[exists_and_not_null year] & [exists_and_not_null month]} {
	set datebox [dt_widget_datetime -default "$year-$month-01" mydate "months"]
} elseif {[exists_and_not_null mydate(year)] & [exists_and_not_null mydate(month)]} {
	set datebox [dt_widget_datetime -default "$mydate(year)-$mydate(month)-01" mydate "months"]
	set year $mydate(year)
	set month $mydate(month)
} else {
set datebox [dt_widget_datetime -default now mydate "months"]
	set year [template::util::date::get_property year [template::util::date::today]]
	set month [template::util::date::get_property month [template::util::date::today]]
}

set fmt "%Y-%m-%d"
set today [clock seconds]
set asked_date [clock scan "$year-$month-1"]

set DataFileName [user-tracking::get_data_file_name "" $user_id $config $year $month]

set hidden [export_vars -form {user_id}]


if {$asked_date <= $today } {
   set nodata_p 0
   set LastLine ""
   
   if {[file exists $DataFileName]} {
      set nodata_p 1
      set dataFile [open "$DataFileName" r]
      
      #Getting file map
      set linea [gets $dataFile]
      set fin [eof $dataFile]
      set patron "(BEGIN_MAP) (.*)"
      while { $fin == 0} {
      	set linea [gets $dataFile]
      	set fin [eof $dataFile]
      	if { [regexp $patron $linea todo part1 SectionCount] ==1 } {
      		set fin 1
      	}
      }
      
      set fin 0
      set patron "^(\[A-Z\\_0-9\]*) (.*)"
      while { $fin == 0} {
      	set linea [gets $dataFile]
      	set fin [eof $dataFile]
      	if { [regexp $patron $linea todo part1 part2] ==1 } {
      		set Map($part1) $part2 
      	}
      	if { $linea == "END_MAP"} {
      		set fin 1
      	}
      }
      
      #Getting data in general section
      
      set pos $Map(POS_GENERAL)
      seek $dataFile $pos
      set linea [gets $dataFile]
      set patron "(BEGIN_GENERAL) (.*)"
      while { ![regexp $patron $linea todo part1 part2] } {	
      	set linea [gets $dataFile]	
      	if {[eof $dataFile]} {
      		set part2 0
      		break;
      	}
      }
      set i $part2
      
      while { $i > 0} {	
      	set linea [gets $dataFile]
      	set campos [split $linea]
      	switch [lindex $campos 0] {
      		FirstTime { 
      			set FirstTime [user-tracking::converts_date [lindex $campos 1]]
      			}
      		LastTime { 
      			set LastTime [user-tracking::converts_date [lindex $campos 1]]
      			}
      		LastUpdate { 
      			set LastUp [user-tracking::converts_date [lindex $campos 1]]
      			}
      		TotalVisits { 
      			set TotalVisits [lindex $campos 1]
      			}
      		TotalUnique { 
      			set TotalUnique [lindex $campos 1]
      			}
      		LastLine { 
      			set LastLine [user-tracking::converts_date [lindex $campos 1]]
      			} 
      		default {}
      	}
      	set i [expr $i - 1]
      	if {[eof $dataFile]} { #Wrong file?
      		break;
      	}
      }
      
      #Getting the number of visited pages
      
      set pos $Map(POS_DAY)
      seek $dataFile $pos
      set linea [gets $dataFile]
      set patron "(BEGIN_DAY) (.*)"
      while { ![regexp $patron $linea todo part1 part2] } {	
      	set linea [gets $dataFile]	
      	if {[eof $dataFile]} {
      		set part2 0
      		break;
      	}
      }
      
      set i $part2
      
      set TotalPages 0
      set TotalAsked 0
      
      while { $i > 0} {	
      	set linea [gets $dataFile]
      	set campos [split $linea]
      	set TotalPages [expr $TotalPages+ [lindex $campos 1]]
      	set TotalAsked [expr $TotalAsked+ [lindex $campos 2]]
      	set i [expr $i - 1]
      	if {[eof $dataFile]} { #Wrong file?
      		break;
      	}
      }
      
      close $dataFile
   
} else {
  if {$noloading eq 0} {
   	set nodata_p 1
  }
}
}
ad_return_template

