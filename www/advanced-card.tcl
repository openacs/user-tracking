
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
    {user_id ""}
    {community_id ""}    
} -properties {    
    DataFileName:onevalue
    config:onevalue
    pretype:onevalue   
    datebox:onevalue
    mydate:onevalue
    today:onevalue
    asked_day:onevalue
    hidden:onevalue
    hidden2:onevalue
    Users:multirow
    Communities:multirow
    user_id:onevalue
    community_id:onevalue
    onlyuser:onevalue
    onlylines:onevalue

}
set user_id $onlyuser
set community_id $onlylines
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

# First of all, we have to delete all blank spaces

regsub -all -- "(%20)+" $user_id " " user_id
regsub -all -- "\[\\t \\r\\n\]+" $user_id " " user_id
regsub -all -- "(%20)+" $community_id " " community_id
regsub -all -- "\[\\t \\r\\n\]+" $community_id " " community_id


set total_posted 0
set faq_posted 0
set news_posted 0
set surveys_posted 0
set forum_posted 0
set files_posted 0


template::multirow create Users ID Name Mail RegistrationDate LastVisit
template::multirow create Communities ID Name CreationDate Key
template::multirow create UsersPosts ID Name CreationDate Key
template::multirow create CommunitiesData ID Name CreationDate Key

if {![empty_string_p $user_id]} {
	if {![empty_string_p $community_id]} {
		set mUserList [string trimleft $user_id " "]
		set UsersList [split $mUserList]

		set ComsList [string trimleft $community_id " "]
		list ComsList [split $community_id]
		#Permission control
		if {[llength $ComsList] > 1} {
			#Advanced stats, site admin
			ad_require_permission [ad_conn package_id] "admin"
		} else {
			#Stats of one community
			if {[llength $UsersList] > 1} {
				#Advanced stats of a community, professor
				ad_require_permission [lindex $ComsList 0] "admin"
			} else {				
				#Stats of a user in a community
				set new_user_id [ad_conn user_id]
				if {![string equal $new_user_id [lindex $UsersList 0]]} {
					#Stats of a different user
					ad_require_permission [lindex $ComsList 0] "admin"
				}
				#Only read permission is necessary
				ad_require_permission [lindex $ComsList 0] "read"
			}
		}			
		foreach oneUser $UsersList {
			if {![empty_string_p $oneUser]} {
				if {![db_0or1row select_user_info {}]} {
				    ad_return_complaint 1 "<li>[_ dotlrn.couldnt_find_user_id [list user_id $oneUser]]</li>"
				    ad_script_abort
				}
				multirow append Users $oneUser "$first_names $last_name" $email $registration_date $last_visit
			}
		}
		foreach oneCom $ComsList {
			if {![empty_string_p $oneCom]} {
				if {![db_0or1row select_com_data {}]} {
				    ad_return_complaint 1 "<li>[_ dotlrn.couldnt_find_user_id [list user_id $user_id]]</li>"
				    ad_script_abort
				}
				multirow append Communities $oneCom $pretty_name $creation_date $key
			}
		}		
	} else {
		set UsersList [split $user_id]
		#Permission control
		if {[llength $UsersList] > 1} {
			#Advanced stats, need to be admin
			ad_require_permission [ad_conn package_id] "admin"
		} else {
			#User Stats
			set new_user_id [ad_conn user_id]
			if {![string equal $new_user_id [lindex $UsersList 0]]} {
				#Stats of a different user
				ad_require_permission [ad_conn package_id] "admin"
			}
			#Permission not necessary
		}			
		foreach oneUser $UsersList {
			if {![empty_string_p $oneUser]} {
				if {![db_0or1row select_user_info {}]} {
				    ad_return_complaint 1 "<li>[_ dotlrn.couldnt_find_user_id [list user_id $user_id]]</li>"
				    ad_script_abort
				}
				multirow append Users $oneUser "$first_names $last_name" $email $registration_date $last_visit
				
			}
		}
	}
} else {
	if {![empty_string_p $community_id]} {
		set ComsList [split $community_id]		
		#Permission control
		if {[llength $ComsList] > 1} {
			#Advanced stats, site admin
			ad_require_permission [ad_conn package_id] "admin"
		} else {
			#Advanced stats of a community, professor
			ad_require_permission [lindex $ComsList 0] "admin"
		}			
		foreach oneCom $ComsList {
			if {![empty_string_p $oneCom]} {
				if {![db_0or1row select_com_data {}]} {
				    ad_return_complaint 1 "<li>[_ dotlrn.couldnt_find_user_id [list user_id $user_id]]</li>"
				    ad_script_abort
				}
				multirow append Communities $oneCom $pretty_name $creation_date $key			
				
			}
		}
	} else {
		ad_return_complaint 1 "Error no Data"
		ad_script_abort
	}
}

set page_title [_ user-tracking.lt_Advanced_Stats]
set context [list $page_title]

template::list::create \
    -name Users \
    -multirow Users \
    -elements {
        id {
            label "#user-tracking.ID#"
            display_col ID
            html {align center}
        }
        name {
            label "#user-tracking.User_Name#"
            display_col Name            
            html {align center}
        }
        mail {
            label "#user-tracking.Mail#"
            display_col Mail
            html {align center}
        }
        registration_date {
            label "#user-tracking.Registration_Date#"
            display_col RegistrationDate
            html {align center}
        }
        last {
            label "#user-tracking.Last_Visit#"
            display_col LastVisit
            html {align center}
        }
     } \

template::list::create \
    -name Communities \
    -multirow Communities \
    -elements {
        id {
            label "#user-tracking.ID#"
            display_col ID
            html {align center}
        }
        name {
            label "#user-tracking.Community_Name#"
            display_col Name            
            html {align center}
        }
        creation_date {
            label "#user-tracking.Creation_Date#"
            display_col CreationDate
            html {align center}
        }
        key {
            label "#user-tracking.Key#"
            display_col Key
            html {align center}
        }
     }
     
# -------------------------------------------

set DataFileName [user-tracking::get_data_file_name $onlylines $onlyuser $config $year $month]
set hidden [export_vars -form {{onlylines $community_id} {onlyuser $user_id}}]
set hidden2 [export_vars -form { {config} {url "advanced-card"} {onlylines $community_id} {onlyuser $user_id}}]

if {$asked_date <= $today } {

set nodata_p 0
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
   
   #Getting data for general section
   
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

