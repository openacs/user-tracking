
ad_page_contract {
    @author yon (yon@openforce.net)
    @creation-date 2002-01-30
    @version $Id$
} -query { 
    {community_id ""}
    {type ""}
    {NofSub ""}
    {NofMembers ""}
    {NofUsers ""}
    {NofAdmin ""}
    {NofForums ""}
    {NofFaqs ""}
    {NofNews ""}
    {NofSurveys ""}
    {name ""}
    {creation_date ""}
    {id ""}
    
} -properties {
    type:onevalue
    NofSub:onevalue
    NofMembers:onevalue
    NofUsers:onevalue
    NofAdmin:onevalue
    NofForums:onevalue
    NofFaqs:onevalue
    NofNews:onevalue
    NofSurveys:onevalue
    name:onevalue
    creation_date:onevalue
    id:onevalue
}

if {![exists_and_not_null referer]} {
    set referer "[user-tracking::get_package_url]/communities-stats"
}


if {![exists_and_not_null community_id]} {
    ad_returnredirect $referer
}

#Only proffesor of a class could see class stats
ad_require_permission $community_id "admin"


#Hay que modificar el titulo de la pagina
set page_title [_ user-tracking.User_Stats]
set context [list $page_title]

#Each kind of community is a number: Club 1, Class 2, other 3
if {![db_0or1row select_class_data {}]} { 	
	set rol_users_list {dotlrn_member_rel}
	set rol_admin_list {dotlrn_admin_rel}
	if {![db_0or1row select_club_data {}]} {		
		if {![db_0or1row select_com_data {}]} {
			ad_returnredirect $referer
		} else {
			set type 3		
		}	
	} else {
		set type 1
	}
} else {
	set type 2
	set rol_users_list {dotlrn_student_rel dotlrn_member_rel}
	set rol_admin_list {dotlrn_admin_rel dotlrn_cadmin_rel dotlrn_instructor_rel}
}

set NofSub [db_string select_subgroup_count {} ]
set NofMembers [db_string select_members_count {} ]

set rels $rol_users_list
set NofUsers [db_string select_members_count_by_type {} ]

set rels $rol_admin_list
set NofAdmin [db_string select_members_count_by_type {} ]

set package_key "forums"
if {[db_0or1row select_package_exists {}]} {
	set NofForums [db_string select_forums_count {} ]
}

set package_key "faq"
if {[db_0or1row select_package_exists {}]} {
	set NofFaqs [db_string select_faqs_count {} ]
}

set package_key "news"
if {[db_0or1row select_package_exists {}]} {
	set NofNews [db_string select_news_count {} ]
}

set package_key "survey"
if {[db_0or1row select_package_exists {}]} {
	set NofSurveys [db_string select_surveys_count {} ]
}

ad_return_template

