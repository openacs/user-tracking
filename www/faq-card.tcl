ad_page_contract {
    @author sergiog (sergiog@tid.es)
    @author doa (doa@tid.es)
    @creation-date 2004-11-23
} -query { 
    {user_id ""}
    {community_id ""}
} -properties {
    faqs:multirow
    first_names:onevalue
    last_name:onevalue
    email:onevalue
    user_id:onevalue
    
}

if {![exists_and_not_null referer]} {
    set referer "[user-tracking::get_package_url]/communities-stats"
}

if {![exists_and_not_null user_id]} {
	if {![exists_and_not_null community_id]} {
		#Only Admins can see this stats
		ad_require_permission [ad_conn package_id] "admin"
    		set query select_site_faqs
    	} else {
    		#Only Professor can see this stats
    		ad_require_permission $community_id "admin"
    		if {![db_0or1row select_com_data {}]} {
		    ad_return_complaint 1 "<li>[_ dotlrn.couldnt_find_user_id [list user_id $user_id]]</li>"
		    ad_script_abort
		}
    		set query select_faqs_by_com
    	}   	
db_multirow -extend { 
    faqs_url
    posting_date_pretty
    entry_url
} faqs $query {} {

   set posting_date_ansi [lc_time_system_to_conn $creation_date]
   set posting_date_pretty [lc_time_fmt $posting_date_ansi "%x %X"]
   set faqs_url "${url}one-faq?faq_id=${faq_id}"

}
} else {
	set new_user_id [ad_conn user_id]
	#An user can see his / her own stats
        if {![string equal $new_user_id $user_id]} {
		ad_require_permission [ad_conn package_id] "admin"
	}
	if {![db_0or1row select_user_info {}]} {
	    ad_return_complaint 1 "<li>[_ dotlrn.couldnt_find_user_id [list user_id $user_id]]</li>"
	    ad_script_abort
	}
	set query select_faqs
db_multirow -extend { 
    faqs_url
    posting_date_pretty
    entry_url
} faqs $query {} {

   set posting_date_ansi [lc_time_system_to_conn $creation_date]
   set posting_date_pretty [lc_time_fmt $posting_date_ansi "%x %X"]
   set faqs_url "${url}one-faq?faq_id=${faq_id}"
   set entry_url "${url}one-question?entry_id=${entry_id}"

}
}   	


set page_title [_ user-tracking.Faqs_Stats]
set context [list $page_title]

#db_multirow faqs select_faqs {} {}

#ad_return_template
#ad_return_template

template::list::create \
    -name faqs_q_and_as \
    -multirow faqs \
    -elements {
        name {
            label "#user-tracking.faq_name#"
            link_url_col faqs_url
            display_col faq_name
        }
        question {
            label "#user-tracking.faq_question#"
            link_url_col entry_url
            display_col question
        }
        posting_date {
            label "#user-tracking.Post_Date#"
            display_col posting_date_pretty
        }

    } -filters {
        package_id {}
    }

template::list::create \
    -name faqs \
    -multirow faqs \
    -elements {
        name {
            label "#user-tracking.faq_name#"
            link_url_col faqs_url
            display_col faq_name
        }
        posting_date {
            label "#user-tracking.Post_Date#"
            display_col posting_date_pretty
        }

    } -filters {
        package_id {}
    }



