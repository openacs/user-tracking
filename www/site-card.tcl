
ad_page_contract {
    @author yon (yon@openforce.net)
    @creation-date 2002-01-30
    @version $Id$
} -query { 
    {NofMembers ""}
    {NofUsers ""}
    {LastVisit ""}
    {LastRegistration ""}
    {TotalVisits ""}
    {NofClasses ""}
    {NofCommunities ""}
    {NofForums ""}
    {NofFaqs ""}
    {NofNews ""}
    {NofSurveys ""}

} -properties {    
    NofMembers:onevalue
    NofUsers:onevalue
    LastVisit:onevalue
    LastRegistration:onevalue
    TotalVisits:onevalue
    NofClasses:onevalue
    NofCommunities:onevalue
    NofForums:onevalue
    NofFaqs:onevalue
    NofNews:onevalue
    NofSurveys:onevalue    
}

if {![exists_and_not_null referer]} {
    set referer "[user-tracking::get_package_url]/users-stats"
}

#Admin
ad_require_permission [ad_conn package_id] "admin"

#Hay que modificar el titulo de la pagina
set page_title [_ user-tracking.lt_Site_Stats]
set context [list $page_title]

db_1row select_n_users {}
set NofMembers $n_users
   set LastRegistration_ansi [lc_time_system_to_conn $last_registration]
   set LastRegistration [lc_time_fmt $LastRegistration_ansi "%x %X"]
   
   set LastVisit_ansi [lc_time_system_to_conn $last_visit]
   set LastVisit [lc_time_fmt $LastVisit_ansi "%x %X"]
set TotalVisits $total_visits



set rol_users_list {dotlrn_student_rel dotlrn_member_rel membership_rel dotlrn_non_guest_rel dotlrn_student_profile_rel}
set rol_admin_list {dotlrn_admin_rel dotlrn_cadmin_rel dotlrn_instructor_rel dotlrn_admin_profile_rel dotlrn_professor_profile_rel}

set rels $rol_users_list
set NofUsers [db_string select_members_count_by_type {} ]

set rels $rol_admin_list
set NofAdmin [db_string select_members_count_by_type {} ]


set NofClasses [db_string select_classes_count {} ]

set NofCommunities [db_string select_clubs_count {} ]

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

