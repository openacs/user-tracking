ad_page_contract {
    @author sergiog (sergiog@tid.es)
    @author doa (doa@tid.es)
    @creation-date 2004-11-23
} -query { 
    {user_id ""}
    {community_id ""}
} -properties {
    surveys:multirow
    first_names:onevalue
    last_name:onevalue
    email:onevalue
    user_id:onevalue
    
}

if {![exists_and_not_null referer]} {
    set referer "[user-tracking::get_package_url]/users-stats"
}

# First of all, we have to delete all blank spaces
regsub -all -- "(%20)+" $user_id " " user_id
regsub -all -- "\[\\t \\r\\n\]+" $user_id " " user_id
regsub -all -- "(%20)+" $community_id " " community_id
regsub -all -- "\[\\t \\r\\n\]+" $community_id " " community_id

template::multirow create Users ID Name Mail RegistrationDate LastVisit
template::multirow create Communities ID Name CreationDate Key

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
				foreach oneCom $ComsList {
					if {![empty_string_p $oneCom]} {
						set query select_survey
						db_multirow -append -extend { 
						    survey_url
						    posting_date_pretty
						    url
						    goto
						} surveys $query {} {
						   set posting_date_ansi [lc_time_system_to_conn $creation_date]
						   set posting_date_pretty [lc_time_fmt $posting_date_ansi "%x %X"]
						   set url [site_node::get_url_from_object_id -object_id $package_id]
						   set survey_url "${url}one-respondent?survey_id=$survey_id#$response_id"
						   set url "${url}one-survey?survey_id=${survey_id}"
						   set goto "#user-tracking.survey_goto#"	
						}
					}
				}
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
				    ad_return_complaint 1 "<li>[_ dotlrn.couldnt_find_user_id [list user_id $oneUser]]</li>"
				    ad_script_abort
				}
				multirow append Users $oneUser "$first_names $last_name" $email $registration_date $last_visit
				set query select_survey_by_user
				db_multirow -append -extend { 
				    survey_url
				    posting_date_pretty
				    url
				    goto
				} surveys $query {} {
				   set posting_date_ansi [lc_time_system_to_conn $creation_date]
				   set posting_date_pretty [lc_time_fmt $posting_date_ansi "%x %X"]
				   set url [site_node::get_url_from_object_id -object_id $package_id]
				   set survey_url "${url}one-respondent?survey_id=$survey_id#$response_id"
				   set url "${url}one-survey?survey_id=${survey_id}"
				   set goto "#user-tracking.survey_goto#"	
				}
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
		    		#Professor
				set query select_survey_by_com
				db_multirow -append -extend { 
					posting_date_pretty
			    		url
			    		goto
				} surveys $query {} {
				   set posting_date_ansi [lc_time_system_to_conn $creation_date]
				   set posting_date_pretty [lc_time_fmt $posting_date_ansi "%x %X"]
				   set url [site_node::get_url_from_object_id -object_id $package_id]
				   set url "${url}one-survey?survey_id=${survey_id}"
				   set goto "#user-tracking.survey_goto#"
				}
			}
		}
	} else {
		#Admin
		ad_require_permission [ad_conn package_id] "admin"
		set query select_site_surveys
		db_multirow -append -extend { 
			posting_date_pretty
	    		url
	    		goto
		} surveys $query {} {
		   set posting_date_ansi [lc_time_system_to_conn $creation_date]
		   set posting_date_pretty [lc_time_fmt $posting_date_ansi "%x %X"]
		   set url [site_node::get_url_from_object_id -object_id $package_id]
		   set url "${url}one-survey?survey_id=${survey_id}"
		   set goto "#user-tracking.survey_goto#"
		}
	}
}

if {![exists_and_not_null user_id]} {	
	if {![exists_and_not_null community_id]} {
    	} else {
    	}   	
} else {
	set new_user_id [ad_conn user_id]	
        if {![string equal $new_user_id $user_id]} {
		ad_require_permission [ad_conn package_id] "admin"
	}
	
	if {![db_0or1row select_user_info {}]} {
	    ad_return_complaint 1 "<li>[_ dotlrn.couldnt_find_user_id [list user_id $user_id]]</li>"
	    ad_script_abort
	}
}   	

set page_title [_ user-tracking.Surveys_Stats]
set context [list $page_title]

template::list::create \
    -name surveys \
    -multirow surveys \
    -elements {
        title {
            label "#user-tracking.survey_title#"
            link_url_col url
            display_col name
        }
        posting_date {
            label "#user-tracking.Post_Date#"
            display_col posting_date_pretty
        }
    } -filters {
        package_id {}
    }

template::list::create \
    -name surveys_responses \
    -multirow surveys \
    -elements {
        title {
            label "#user-tracking.survey_title#"
            link_url_col url
            display_col name
        }
        posting_date {
            label "#user-tracking.Post_Date#"
            display_col posting_date_pretty
        }
        goto {
            label "#user-tracking.survey_goto#"
            link_url_col survey_url
	    display_col goto
        }

    } -filters {
        package_id {}
    }

template::list::create \
    -name Users \
    -multirow Users \
    -elements {
        id {
            label "ID"
            display_col ID
        }
        name {
            label "User Name"
            display_col Name            
        }
        mail {
            label "Mail"
            display_col Mail
        }
        registration_date {
            label "Registration Date"
            display_col RegistrationDate
        }
        last {
            label "Last Visit"
            display_col LastVisit
        }
     }

template::list::create \
    -name Communities \
    -multirow Communities \
    -elements {
        id {
            label "ID"
            display_col ID
        }
        name {
            label "Community Name"
            display_col Name            
        }
        creation_date {
            label "Creation Date"
            display_col CreationDate
        }
        key {
            label "Key"
            display_col Key
        }
     }
    

ad_return_template
