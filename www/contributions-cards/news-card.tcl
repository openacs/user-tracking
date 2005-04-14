ad_page_contract {
    @author sergiog (sergiog@tid.es)
    @author doa (doa@tid.es)
    @creation-date 2004-11-23
} -query { 
    {user_id ""}
    {community_id ""}
} -properties {
    active_news:multirow
    non_active_news:multirow
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
						set query select_active_news
						set queryb select_non_active_news
						db_multirow -append -extend { 
						    news_url
						    posting_date_pretty
						} active_news $query {} {
						   set posting_date_pretty [lc_time_fmt $publish_date_ansi "%x %X"]
						   set news_url "${url}item?item_id=$item_id"
						}
						db_multirow -append -extend { 
						    news_url
						    posting_date_pretty
						} non_active_news $queryb {} {						
						   set posting_date_pretty [lc_time_fmt $publish_date_ansi "%x %X"]
						   set news_url "${url}item?item_id=$item_id"						
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
				set query select_active_news_by_user
				set queryb select_non_active_news_by_user
				db_multirow -append -extend { 
				    news_url
				    posting_date_pretty
				} active_news $query {} {
				   set posting_date_pretty [lc_time_fmt $publish_date_ansi "%x %X"]
				   set news_url "${url}item?item_id=$item_id"
				}
				db_multirow -append -extend { 
				    news_url
				    posting_date_pretty
				} non_active_news $queryb {} {						
				   set posting_date_pretty [lc_time_fmt $publish_date_ansi "%x %X"]
				   set news_url "${url}item?item_id=$item_id"						
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
				set query select_active_news_by_com
				set queryb select_non_active_news_by_com
				db_multirow -append -extend { 
				    news_url
				    posting_date_pretty
				} active_news $query {} {
				   set posting_date_pretty [lc_time_fmt $publish_date_ansi "%x %X"]
				   set news_url "${url}item?item_id=$item_id"
				}
				db_multirow -append -extend { 
				    news_url
				    posting_date_pretty
				} non_active_news $queryb {} {						
				   set posting_date_pretty [lc_time_fmt $publish_date_ansi "%x %X"]
				   set news_url "${url}item?item_id=$item_id"						
				}
			}
		}
	} else {
		#Admin
		ad_require_permission [ad_conn package_id] "admin"	
		set query select_site_active_news
		set queryb select_site_non_active_news
		db_multirow -append -extend { 
		    news_url
		    posting_date_pretty
		} active_news $query {} {
		   set posting_date_pretty [lc_time_fmt $publish_date_ansi "%x %X"]
		   set news_url "${url}item?item_id=$item_id"
		}
		db_multirow -append -extend { 
		    news_url
		    posting_date_pretty
		} non_active_news $queryb {} {						
		   set posting_date_pretty [lc_time_fmt $publish_date_ansi "%x %X"]
		   set news_url "${url}item?item_id=$item_id"						
		}
	}
}

#Hay que modificar el titulo de la pagina
set page_title [_ user-tracking.News_Stats]
set context [list $page_title]

template::list::create \
    -name active_news \
    -multirow active_news \
    -elements {
        title {
            label "#user-tracking.news_title#"
            link_url_col news_url
            display_col publish_title
        }
        posting_date {
            label "#user-tracking.Post_Date#"
            display_col posting_date_pretty
        }

    } -filters {
        package_id {}
    }


#set queryb select_non_active_news

template::list::create \
    -name non_active_news \
    -multirow non_active_news \
    -elements {
        title {
            label "#user-tracking.news_title#"
            link_url_col news_url
            display_col publish_title
        }
        posting_date {
            label "#user-tracking.Post_Date#"
            display_col posting_date_pretty
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

if {[exists_and_not_null alt_template]} {
  ad_return_template $alt_template
}
