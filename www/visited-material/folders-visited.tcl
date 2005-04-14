ad_page_contract {
    @author sergiog (sergiog@tid.es)
    @author doa (doa@tid.es)
    @creation-date 2005-01-10
} -query { 
	{config "site"}
	{user_id ""}
	{community_id ""}
	{DataFileName ""}	
} -properties {
	Folders:multirow
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

#EXTRA 5
set pos $Map(POS_EXTRA_5)
seek $dataFile $pos
set linea [gets $dataFile]
set patron "(BEGIN_EXTRA_5) (.*)"
while { ![regexp $patron $linea todo part1 part2] } {	
	set linea [gets $dataFile]	
	if {[eof $dataFile]} {
		set part2 0
		break;
	}
}


set i $part2

template::multirow create Folders ID Visits LastTime FoldersUrl Name

while { $i > 0} {	
	set linea [gets $dataFile]
	set campos [split $linea]
	set folder_id [lindex $campos 0]
	if { [db_0or1row select_folders {} ] } {
		multirow append Folders $folder_id [lindex $campos 2] [user-tracking::converts_date [lindex $campos 4]] "${url}index?folder_id=$folder_id" $name
	} else {
		multirow append Folders " " [lindex $campos 2] [user-tracking::converts_date [lindex $campos 4]] "${url}index?folder_id=$folder_id" $name
	}
	set i [expr $i - 1]
	if {[eof $dataFile]} { #Wrong file?
		break;
	}
}

close $dataFile

template::multirow sort Folders -integer -decreasing Visits

template::list::create \
    -name Folders \
    -multirow Folders \
    -elements {
        id {
            label "#user-tracking.ID#"
            display_col ID
 	    html {align center}            
        }
        title {
            label "#user-tracking.Folder_Name#"
            display_col Name
            link_url_col FoldersUrl     
 	    html {align center}            
        }
        visits {
            label "#user-tracking.Number_of_Visits#"
            display_col Visits
 	    html {align center}            
        }
        last {
            label "#user-tracking.Last_Visit#"
            display_col LastTime
 	    html {align center}            
        }
     } -html {align center}            

ad_return_template
