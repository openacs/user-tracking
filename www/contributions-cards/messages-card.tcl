ad_page_contract {
    @author sergiog (sergiog@tid.es)
    @author doa (doa@tid.es)
    @creation-date 2004-11-23
} -query { 
    {user_id ""}
    {community_id ""}
} -properties {
    forums:multirow
}

if {![exists_and_not_null referer]} {
    set referer "[user-tracking::get_package_url]/communities-stats"
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
						set query select_forums_messages
						db_multirow -append -extend { 
						    message_url
						    forum_url
						    posting_date_pretty
						} forums $query {} {
						   set posting_date_ansi [lc_time_system_to_conn $posting_date]
						   set posting_date_pretty [lc_time_fmt $posting_date_ansi "%x %X"]
						   set message_url "${url}message-view?message_id=$message_id"
						   set forum_url "${url}forum-view?forum_id=$forum_id"
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
				set query select_forums_messages_by_user
				db_multirow -append -extend { 
				    message_url
				    forum_url
				    posting_date_pretty
				} forums $query {} {
				   set posting_date_ansi [lc_time_system_to_conn $posting_date]
				   set posting_date_pretty [lc_time_fmt $posting_date_ansi "%x %X"]
				   set message_url "${url}message-view?message_id=$message_id"
				   set forum_url "${url}forum-view?forum_id=$forum_id"
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
		    		set query select_forums_messages_by_com
				db_multirow -append -extend { 
				    forum_url
				    posting_date_pretty
				    message_url
				} forums $query {} {
				   set posting_date_ansi [lc_time_system_to_conn $posting_date]
				   set posting_date_pretty [lc_time_fmt $posting_date_ansi "%x %X"]
				   set message_url "${url}message-view?message_id=$message_id"
				   set forum_url "${url}forum-view?forum_id=$forum_id"
				}
			}
		}
	} else {
		#Admin
		ad_require_permission [ad_conn package_id] "admin"
    		set query select_site_forums_messages
		db_multirow -append -extend { 
		    forum_url
		    posting_date_pretty
		    message_url
		} forums $query {} {
		   set posting_date_ansi [lc_time_system_to_conn $posting_date]
		   set posting_date_pretty [lc_time_fmt $posting_date_ansi "%x %X"]
		   set message_url "${url}message-view?message_id=$message_id"
		   set forum_url "${url}forum-view?forum_id=$forum_id"
		}
	}
}

set page_title [_ user-tracking.Messages_Stats]
set context [list $page_title]


template::list::create \
    -name forums_messages \
    -multirow forums \
    -elements {
        forum {
            label "#user-tracking.Forum_Name#"
            display_template {
		<if @forums.name@ eq @name@>
      		</if> <else>	
      		<a href="@forums.forum_url@">@forums.name@</a>
      		<% set name @forums.name@ %>
      		</else>      	
            }
        }
        message {
            label "#user-tracking.Subject#"
            link_url_col message_url
            display_col subject
        }
        posting_date {
            label "#user-tracking.Post_Date#"
            display_col posting_date_pretty
        }

    } -filters {
        forum_id {}
    }

template::list::create \
    -name forums \
    -multirow forums \
    -elements {
        forum {
            label "#user-tracking.Forum_Name#"
            display_template {
		<if @forums.name@ eq @name@>
      		</if> <else>	
      		<a href="@forums.forum_url@">@forums.name@</a>
      		<% set name @forums.name@ %>
      		</else>      	
            }
        }
        posting_date {
            label "#user-tracking.Post_Date#"
            display_col posting_date_pretty
        }

    } -filters {
        forum_id {}
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


