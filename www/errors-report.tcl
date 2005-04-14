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
	Errors:multirow
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

set page_title [_ user-tracking.Errors_Report]
set context [list $page_title]

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

#Getting data about errors


set pos $Map(POS_ERRORS)
seek $dataFile $pos
set linea [gets $dataFile]
set patron "(BEGIN_ERRORS) (.*)"
while { ![regexp $patron $linea todo part1 part2] } {	
	set linea [gets $dataFile]	
	if {[eof $dataFile]} {
		set part2 0
		break;
	}
}
set i $part2

#Creamos un multirow con el tipo del error, el numero de errores de cada tipo y el ancho de banda
template::multirow create Errors ID Name Number AdB

#Tenemos un array con los tipos de errores
array set ErrorsTypes {
	206 "#user-tracking.error_206#"
	301 "#user-tracking.error_301#"
	302 "#user-tracking.error_302#"
	304 "#user-tracking.error_304#"
	400 "#user-tracking.error_400#"
	401 "#user-tracking.error_401#"
	403 "#user-tracking.error_403#"
	404 "#user-tracking.error_404#"
	405 "#user-tracking.error_405#"
	500 "#user-tracking.error_500#"
	501 "#user-tracking.error_501#"
	502 "#user-tracking.error_502#"
	503 "#user-tracking.error_503#"
	504 "#user-tracking.error_504#"
	505 "#user-tracking.error_505#"}

while { $i > 0} {	
	set linea [gets $dataFile]
	set campos [split $linea]
	set error_id [lindex $campos 0]
	multirow append Errors [lindex $campos 0] $ErrorsTypes($error_id) [lindex $campos 1] [lindex $campos 2]	
	set i [expr $i - 1]
	if {[eof $dataFile]} { #Wrong file?
		break;
	}
}

template::multirow sort Errors -integer -increasing ID

close $dataFile

template::list::create \
    -name Errors \
    -multirow Errors \
    -elements {
        id {
            label "#user-tracking.ID#"
            display_col ID
            html {align center}
        }
        title {
            label "#user-tracking.Name#"
            display_col Name           
            html {align center}
        }
        visits {
            label "#user-tracking.Number#"
            display_col Number
            html {align center}
        }
     } -html {align center} 


ad_return_template
