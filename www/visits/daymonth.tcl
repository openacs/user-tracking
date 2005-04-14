ad_page_contract {
    @author sergiog (sergiog@tid.es)
    @author doa (doa@tid.es)
    @author pablomp (pablomp@tid.es)
    @creation-date 2005-01-10
} -query { 
	{config "site"}
	{user_id ""}
	{community_id ""}	
	{DataFileName ""}	
	
} -properties {
	HitsByDay:onelist
	PagesByDay:onelist
	VisitsByDay:onelist	
}

# First of all, we have to delete all blank spaces

regsub -all -- "(%20)+" $user_id " " user_id
regsub -all -- "\[\\t \\r\\n\]+" $user_id " " user_id
regsub -all -- "(%20)+" $community_id " " community_id
regsub -all -- "\[\\t \\r\\n\]+" $community_id " " community_id

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
	} else {
		#Site-card
		ad_require_permission [ad_conn package_id] "admin"
	}
}




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

#Getting data about monthly visits
set VisitsByDay [list 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
set PagesByDay [list 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
set HitsByDay [list 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]

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

while { $i > 0} {	
	set linea [gets $dataFile]
	set campos [split $linea]
	

	set day [string range [lindex $campos 0] 6 7]
	set then [clock scan [lindex $campos 0]]
	
	set patron "(0)(\[1-9\])"
	if { [regexp $patron $day todo part1 part2] } {
		set day $part2	
	}
	#list interval 0-30, not 1-31
	set day [expr $day - 1]
	set VisitsByDay [lreplace $VisitsByDay $day $day [lindex $campos 4]]
	set PagesByDay [lreplace $PagesByDay $day $day [lindex $campos 1]]
	set HitsByDay [lreplace $HitsByDay $day $day [lindex $campos 2]]

	set i [expr $i - 1]
	if {[eof $dataFile]} { 
		break;
	}
	
}
close $dataFile
     
template::multirow create DayMonth Day Visits VisitsGraphic Pages PagesGraphic Hits HitsGraphic
set intervalos [list 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31]

for {set i 0} { $i < [llength $VisitsByDay]} {incr i 1} { 
    multirow append DayMonth [lindex $intervalos $i] \
   	[lindex $VisitsByDay $i] [expr [lindex $VisitsByDay $i]*100/[f::lmax $VisitsByDay]] \
    	[lindex $PagesByDay $i] [expr [lindex $PagesByDay $i]*100/[f::lmax $PagesByDay]] \
    	[lindex $HitsByDay $i] [expr [lindex $HitsByDay $i]*100/[f::lmax $HitsByDay]]
}

template::list::create \
    -name DayMonth \
    -multirow DayMonth \
    -elements {
        day {
            label "#user-tracking.Day#"
            display_col Day
	    html { align center}
        }
        Visits {
            label "#user-tracking.Visits#"
            display_col Visits
	    html { align center}
        }
        VisitsGraphic {
            label ""
	    display_template {
	    	<img src=../img/vh.png height=12 width=@DayMonth.VisitsGraphic@>
	    }        }        
        Pages {
            label "#user-tracking.Visited_Pages#"
            display_col Pages
	    html { align center}
        }
        PagesGraphic {
            label ""
	    display_template {
	    	<img src=../img/vp.png height=12 width=@DayMonth.PagesGraphic@>
	    }        }
        Hits {
            label "#user-tracking.Hits#"
            display_col Hits
	    html { align center}
        }
        HitsGraphic {
            label ""
	    display_template {
	    	<img src=../img/vk.png height=12 width=@DayMonth.HitsGraphic@>
	    }        }	    
     }\
     -html {align center}
