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

if {![exists_and_not_null user_id]} {	
	if {![exists_and_not_null community_id]} {
		#Admin
		ad_require_permission [ad_conn package_id] "admin"
		set query select_site_surveys
		db_multirow -extend { 
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
    	} else {
    		#Proffesor
    		ad_require_permission $community_id "admin"
    		if {![db_0or1row select_com_data {}]} {
		    ad_return_complaint 1 "<li>[_ dotlrn.couldnt_find_user_id [list user_id $user_id]]</li>"
		    ad_script_abort
		}
		set query select_survey_by_com
		db_multirow -extend { 
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
} else {
	set new_user_id [ad_conn user_id]	
        if {![string equal $new_user_id $user_id]} {
		ad_require_permission [ad_conn package_id] "admin"
	}
	
	if {![db_0or1row select_user_info {}]} {
	    ad_return_complaint 1 "<li>[_ dotlrn.couldnt_find_user_id [list user_id $user_id]]</li>"
	    ad_script_abort
	}
	set query select_survey
	db_multirow -extend { 
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

#if {![exists_and_not_null user_id]} {
#    #Si no hay user_id redireccionamos a la seleccion de usuarios
#    ad_returnredirect $referer
#}

#if {![db_0or1row select_user_info {}]} {
#    ad_return_complaint 1 "<li>[_ dotlrn.couldnt_find_user_id [list user_id $user_id]]</li>"
#    ad_script_abort
#}

set page_title [_ user-tracking.Surveys_Stats]
set context [list $page_title]

#db_multirow surveys select_survey {} {
#}

#ad_return_template
#set query select_survey

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

ad_return_template
