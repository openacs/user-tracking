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
	
	SessionTime:onelist
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

#Getting data about visits duration

set SessionTime [list 0 0 0 0 0 0 0]

set pos $Map(POS_SESSION)
seek $dataFile $pos
set linea [gets $dataFile]
set patron "(BEGIN_SESSION) (.*)"
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
		0s-30s { 
			set SessionTime [lreplace $SessionTime 0 0 [lindex $campos 1]]		
			}
		30s-2mn { 
			set SessionTime [lreplace $SessionTime 1 1 [lindex $campos 1]]			
			}
		2mn-5mn { 
			set SessionTime [lreplace $SessionTime 2 2 [lindex $campos 1]]			
			}
		5mn-15mn { 
			set SessionTime [lreplace $SessionTime 3 3 [lindex $campos 1]]			
			}
		15mn-30mn { 
			set SessionTime [lreplace $SessionTime 4 4 [lindex $campos 1]]			
			}
		30mn-1h { 
			set SessionTime [lreplace $SessionTime 5 5 [lindex $campos 1]]			
			}
		1h+ { 
			set SessionTime [lreplace $SessionTime 6 6 [lindex $campos 1]]			
			}
		default {}
	}
	set i [expr $i - 1]
	if {[eof $dataFile]} { #Wrong file?
		break;
	}

}
close $dataFile

template::multirow create visitsLength Duration Hits Graphic
set intervalos [list "0s-30s" "30s-2mn" "2mn-5mn" "5mn-15mn" "15mn-30mn" "30mn-1h" "1h+"]
if {$part2 != 0} {
for {set i 0} { $i < [llength $SessionTime]} {incr i 1} { 
    #puts [lindex $SessionTime $i] 
    multirow append visitsLength [lindex $intervalos $i] [lindex $SessionTime $i] [expr [lindex $SessionTime $i]*100/[f::lmax $SessionTime]]
}
}
template::list::create \
    -name visitsLength \
    -multirow visitsLength \
    -elements {
        duration {
            label "#user-tracking.Duration#"
            display_col Duration
	    html { align center}
        }
        visits {
            label "#user-tracking.Number_of_Visits#"
            display_col Hits
	    html { align center}
        }
        graphics {
            label ""
	    display_template {
	    	<img src=../img/vh.png height=12 width=@visitsLength.Graphic@>
	    }        }
     }\
 -html {align center}

