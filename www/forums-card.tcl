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

#if {![exists_and_not_null user_id]} {
#    #Si no hay user_id redireccionamos a la seleccion de usuarios
#    ad_returnredirect $referer
#}

#if {![db_0or1row select_user_info {}]} {
#    ad_return_complaint 1 "<li>[_ dotlrn.couldnt_find_user_id [list user_id $user_id]]</li>"
#    ad_script_abort
#}

set page_title [_ user-tracking.Forums_Stats]
set context [list $page_title]

#set query select_forums
#ad_return_template

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

if {![exists_and_not_null user_id]} {
	if {![exists_and_not_null community_id]} {
		#Admin
		ad_require_permission [ad_conn package_id] "admin"
    		set query select_site_forums
		db_multirow -extend { 
		    forum_url
		    posting_date_pretty
		} forums $query {} {
		
		   set posting_date_ansi [lc_time_system_to_conn $posting_date]
		   set posting_date_pretty [lc_time_fmt $posting_date_ansi "%x %X"]
		   set forum_url "${url}forum-view?forum_id=$forum_id"
		
		}
    	} else {
    		#Proffesor
    		ad_require_permission $community_id "admin"
    		if {![db_0or1row select_com_data {}]} {
		    ad_return_complaint 1 "<li>[_ dotlrn.couldnt_find_user_id [list user_id $user_id]]</li>"
		    ad_script_abort
		}
    		set query select_forums_by_com
		db_multirow -extend { 
		    forum_url
		    posting_date_pretty
		} forums $query {} {
		
		   set posting_date_ansi [lc_time_system_to_conn $posting_date]
		   set posting_date_pretty [lc_time_fmt $posting_date_ansi "%x %X"]
		   set forum_url "${url}forum-view?forum_id=$forum_id"
		
		}
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
	set query select_forums
	db_multirow -extend { 
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



if {[exists_and_not_null alt_template]} {
  ad_return_template $alt_template
}


