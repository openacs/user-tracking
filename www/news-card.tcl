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

if {![exists_and_not_null user_id]} {
	if {![exists_and_not_null community_id]} {
		#Admin
		ad_require_permission [ad_conn package_id] "admin"    		
		set query select_site_active_news
		set queryb select_site_non_active_news
    	} else {
    		#Profesor
    		ad_require_permission $community_id "admin"
    		if {![db_0or1row select_com_data {}]} {
		    ad_return_complaint 1 "<li>[_ dotlrn.couldnt_find_user_id [list user_id $user_id]]</li>"
		    ad_script_abort
		}
		set query select_active_news_by_com
		set queryb select_non_active_news_by_com
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
	set query select_active_news
	set queryb select_non_active_news
}   	

#if {![exists_and_not_null user_id]} {
#    #Si no hay user_id redireccionamos a la seleccion de usuarios
#    ad_returnredirect $referer
#}

#if {![db_0or1row select_user_info {}]} {
#    ad_return_complaint 1 "<li>[_ dotlrn.couldnt_find_user_id [list user_id $user_id]]</li>"
#    ad_script_abort
#}

#Hay que modificar el titulo de la pagina
set page_title [_ user-tracking.News_Stats]
set context [list $page_title]

# db_multirow active_news select_active_news {} {}

# db_multirow non_active_news select_non_active_news {} {}

#set query select_active_news
#ad_return_template

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

db_multirow -extend { 
    news_url
    posting_date_pretty
} active_news $query {} {

   set posting_date_pretty [lc_time_fmt $publish_date_ansi "%x %X"]
   set news_url "${url}item?item_id=$item_id"

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

db_multirow -extend { 
    news_url
    posting_date_pretty
} non_active_news $queryb {} {

   set posting_date_pretty [lc_time_fmt $publish_date_ansi "%x %X"]
   set news_url "${url}item?item_id=$item_id"

}

if {[exists_and_not_null alt_template]} {
  ad_return_template $alt_template
}
