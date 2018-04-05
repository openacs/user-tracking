
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
    {community_id}
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
    community_id:onevalue
    hidden:onevalue
    hidden2:onevalue
    NofSub:onevalue
    NofMembers:onevalue
    NofUsers:onevalue
    NofAdmin:onevalue    

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


# -----------------------------------------------

if {![exists_and_not_null referer]} {
    set referer "[user-tracking::get_package_url]/communities-stats"
}


if {![exists_and_not_null community_id]} {
    ad_returnredirect $referer
}

#Only professor of a class could see class stats
ad_require_permission $community_id "admin"


set page_title [_ user-tracking.lt_Communities_Stats]
set context [list $page_title]

#Each kind of community is a number: Club 1, Class 2, other 3
if {![db_0or1row select_class_data {}]} { 	
	set rol_users_list {dotlrn_member_rel}
	set rol_admin_list {dotlrn_admin_rel}
	if {![db_0or1row select_club_data {}]} {		
		if {![db_0or1row select_com_data {}]} {
			ad_returnredirect $referer
		} else {
			set type 3		
		}	
	} else {
		set type 1
	}
} else {
	set type 2
	set rol_users_list {dotlrn_student_rel dotlrn_member_rel}
	set rol_admin_list {dotlrn_admin_rel dotlrn_cadmin_rel dotlrn_instructor_rel}
}

set NofSub [db_string select_subgroup_count {} ]
set NofMembers [db_string select_members_count {} ]

set rels $rol_users_list
set NofUsers [db_string select_members_count_by_type {} ]

set rels $rol_admin_list
set NofAdmin [db_string select_members_count_by_type {} ]
# -------------------------------------------

set DataFileName [user-tracking::get_data_file_name $community_id "" $config $year $month]
set hidden [export_vars -form {community_id}]
set hidden2 [export_vars -form { {config} {url "communities-card"} {onlylines $community_id} }]

if {$asked_date <= $today } {

   set nodata_p 0
   
   if {[file exists $DataFileName]} {
      
      set nodata_p 1
      set dataFile [open "$DataFileName" r]
      
      #Getting map
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
      	if {[eof $dataFile]} { #wrong file?
      		break;
      	}
      }
      
      close $dataFile
      
      template::multirow create summary from to nvisitors nsessions npages nhits
      multirow append summary $FirstTime $LastTime $TotalUnique $TotalVisits $TotalPages $TotalAsked
      set medSes [expr $TotalVisits/$TotalUnique]
      template::list::create \
          -name summary \
          -multirow summary \
          -elements {
              from {
                  label "#user-tracking.Data_from#"
                  display_col from
                  html {align center}
              }
              to {
                  label "#user-tracking.Data_to#"
                  display_col to
                   html {align center}
             }
              nvisitors {
                  label "#user-tracking.Number_of_visitors#"
                  display_col nvisitors
                  html {align center}
      	}        
              nsessions {
                  label "#user-tracking.Number_of_sessions#"
      	    display_template {
      	    	<center>@summary.nsessions@ <BR> <small>($medSes #user-tracking.visits_by_user#)</small></center>
      	    } 
              }
              npages {
                  label "#user-tracking.Visited_Pages#"
      	    display_col npages        
                  html {align center}
      	}
              nhits {
                  label "#user-tracking.Hits#"
                  display_col nhits
                  html {align center}
             }
          
           } \
           -html { align center }
         
   } else {
     if {$noloading eq 0} {
      	set nodata_p 1
     }
}
}
ad_return_template

