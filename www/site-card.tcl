
ad_page_contract {
    @author doa (doa@tid.es)
    @author sergiog (sergiog@tid.es)
    @creation-date 2005-03-01
} -query { 
    {NofMembers ""}
    {NofUsers ""}
    {LastVisit ""}
    {LastRegistration ""}
    {TotalVisits ""}
    {type "general"}
    {config "site"}
    {onlyuser ""}
    {onlylines ""}
    {nodata_p "0"}
    {noloading "1"}
    {pretype ""}
    {month ""}
    {year ""}
    {mydate:array ""}
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
    onlyuser:onevalue
    onlylines:onevalue
    config:onevalue
    pretype:onevalue   
    datebox:onevalue
    mydate:onevalue
    today:onevalue
    asked_day:onevalue
    server:onevalue
    system_name:onevalue
}


#Only available for admin users
ad_require_permission [ad_conn package_id] "admin"

if {![exists_and_not_null referer]} {
    set referer "[user-tracking::get_package_url]/users-stats"
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

set page_title [_ user-tracking.lt_Site_Stats]
set context [list $page_title]



set DataFileName [user-tracking::get_data_file_name $onlylines $onlyuser $config $year $month]

   set rol_users_list {dotlrn_student_rel dotlrn_member_rel membership_rel dotlrn_non_guest_rel dotlrn_student_profile_rel}
   set rol_admin_list {dotlrn_admin_rel dotlrn_cadmin_rel dotlrn_instructor_rel dotlrn_admin_profile_rel dotlrn_professor_profile_rel}
   
   set rels $rol_users_list
   set NofUsers [db_string select_members_count_by_type {} ]
   
   set rels $rol_admin_list
   set NofAdmin [db_string select_members_count_by_type {} ]

   set NofClasses [db_string select_classes_count {} ]
   
   set NofCommunities [db_string select_clubs_count {} ]
   db_1row select_n_users {}
   set NofMembers $n_users  

   set server [ns_info server]
   set system_name [ad_system_name]
       
if {$asked_date <= $today } {
   set nodata_p 0
   if {[file exists $DataFileName]} {
      set nodata_p 1
      set LastRegistration_ansi [lc_time_system_to_conn $last_registration]
      set LastRegistration [lc_time_fmt $LastRegistration_ansi "%x %X"]
      set LastVisit_ansi [lc_time_system_to_conn $last_visit]
      set LastVisit [lc_time_fmt $LastVisit_ansi "%x %X"]
      set TotalVisits $total_visits
   
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
      
      #Getting data about general section
      
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
      		default {}
      	}
      	set i [expr $i - 1]
      	if {[eof $dataFile]} { #Wrong file?
      		break;
      	}
      }
      
      #Getting number of visited pages
      
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

