

ad_page_contract {
    @author yon (yon@openforce.net)
    @creation-date 2002-01-30
    @version $Id$
} -query { 
	{user_id ""}
	{first_names ""}
	{last_name ""}
	{email ""}
	{screen_name ""}
	{user_id ""}
	{registration_date ""}
	{last_visit ""}
	{total_posted ""}
	{faq_posted ""}
	{news_posted ""}
	{surveys_posted ""}
	{forum_posted ""}
	{files_posted ""}
} -properties {
    first_names:onevalue
    last_name:onevalue
    email:onevalue
    screen_name:onevalue
    user_id:onevalue
    registration_date:onevalue
    last_visit:onevalue
    member_classes:multirow
    member_clubs:multirow
    member_subgroups:multirow
    total_posted:onevalue
    faq_posted:onevalue
    news_posted:onevalue
    surveys_posted:onevalue
    forum_posted:onevalue
    files_posted:onevalue
}

if {![exists_and_not_null referer]} {
    set referer "[user-tracking::get_package_url]/users-stats"
}

if {![exists_and_not_null user_id]} {    
    ad_returnredirect $referer
}

if {![empty_string_p $user_id]} {
	set new_user_id [ad_conn user_id]
        if {![string equal $new_user_id $user_id]} {		
        	ad_require_permission [ad_conn package_id] "admin"
	}
}


#Hay que modificar el titulo de la pagina
set page_title [_ user-tracking.User_Stats]
set context [list $page_title]

if {![db_0or1row select_user_info {}]} {
    ad_return_complaint 1 "<li>[_ dotlrn.couldnt_find_user_id [list user_id $user_id]]</li>"
    ad_script_abort
}

if {[empty_string_p $screen_name]} {
    set screen_name "&lt;[_ dotlrn.none_set_up]&gt;"
}
set registration_date [lc_time_fmt $registration_date "%q"]
if {![empty_string_p $last_visit]} {
    set last_visit [lc_time_fmt $last_visit "%q"]
}

db_multirow member_classes select_member_classes {} {
    set role_pretty_name [dotlrn_community::get_role_pretty_name -community_id $class_instance_id -rel_type $rel_type]
}
db_multirow member_clubs select_member_clubs {} {
    set role_pretty_name [dotlrn_community::get_role_pretty_name -community_id $club_id -rel_type $rel_type]
}
db_multirow member_subgroups select_member_subgroups {} {
    set role_pretty_name [dotlrn_community::get_role_pretty_name -community_id $community_id -rel_type $rel_type]
}

set package_key "faq"
if {[db_0or1row select_package_exists {}]} {
	set object_type "faq"
	set faq_posted [db_string select_faq_count {} ]
} else {
	set faq_posted 0
}

set package_key "news"
if {[db_0or1row select_package_exists {}]} {
	set object_type "content_item"    
	set news_posted [db_string select_news_count {} ]
} else {
	set news_posted 0
}

set package_key "survey"
if {[db_0or1row select_package_exists {}]} {
	set object_type "survey_response"
	set surveys_posted [db_string select_total_posts_by_type {} ]
} else {
	set surveys_posted 0
}

set package_key "forums"
if {[db_0or1row select_package_exists {}]} {
	set object_type "forums_message"
	set forum_posted [db_string select_total_posts_by_type {} ]
} else {
	set forum_posted  0
}

set package_key "file-storage"
if {[db_0or1row select_package_exists {}]} {
	set object_type "file_storage_object"
	set files_posted [db_string select_total_posts_by_type {} ]
} else {
	set files_posted 0
}


set total_posted [expr $faq_posted+$news_posted+$surveys_posted+$files_posted+$forum_posted]


set class_instances_pretty_name [parameter::get -localize -parameter class_instances_pretty_name]
set clubs_pretty_name [parameter::get -localize -parameter clubs_pretty_name]
set subcommunities_pretty_name [parameter::get -localize -parameter subcommunities_pretty_name]

ad_return_template

