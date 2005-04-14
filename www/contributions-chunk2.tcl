ad_page_contract {
    @author doa (doa@tid.es)
    @author sergiog (sergiog@tid.es)
    @creation-date 2005-03-09
} -query { 

} -properties {    
    NofForums:onevalue
    NofFaqs:onevalue
    NofNews:onevalue
    NofSurveys:onevalue
    NofMessages:onevalue
    NofFiles:onevalue    
    link:onevalue
}


# First of all, we have to delete all blank spaces
if {[exists_and_not_null user_id]} {
regsub -all -- "(%20)+" $user_id " " user_id
regsub -all -- "\[\\t \\r\\n\]+" $user_id " " user_id
} else { 
set user_id ""
}
if {[exists_and_not_null community_id]} {
regsub -all -- "(%20)+" $community_id " " community_id
regsub -all -- "\[\\t \\r\\n\]+" $community_id " " community_id
} else {
set community_id ""
}


set total_posted 0
set NofFaqs 0
set NofNews 0
set NofSurveys 0
set NofMessages 0
set NofFiles 0
set NofForums 0


#Creamos 4 multirows:
# * Users: con los datos de los usuarios seleccionados
# * Communities: con los datos de las comunidades seleccionadas
# * UsersPosts: con los datos de los usuarios dentro de las comunidades seleccionadas
# * CommunitiesData: con los datos de las comunidades, por si no hay usuarios seleccionados

template::multirow create Users ID Name Mail RegistrationDate LastVisit
template::multirow create Communities ID Name CreationDate Key
template::multirow create UsersPosts ID Name CreationDate Key
template::multirow create CommunitiesData ID Name CreationDate Key

if {![empty_string_p $user_id]} {
	if {![empty_string_p $community_id]} {
		#Advanced-card
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
				set new_user_id [ad_conn user_id]
				if {![string equal $new_user_id [lindex $UsersList 0]]} {
					#Stats of a different user
					ad_require_permission [lindex $ComsList 0] "admin"
				}
				#Only read permission is necessary
				ad_require_permission [lindex $ComsList 0] "read"

			}
		}	
		set link "?community_id=$community_id&user_id=$user_id"
		
		foreach oneUser $UsersList {
			if {![empty_string_p $oneUser]} {
				if {![db_0or1row select_user_info {}]} {
				    ad_return_complaint 1 "<li>[_ dotlrn.couldnt_find_user_id [list user_id $oneUser]]</li>"
				    ad_script_abort
				}
				multirow append Users $oneUser "$first_names $last_name" $email $registration_date $last_visit
				foreach oneCom $ComsList {
					set package_key "forums"
					if {[db_0or1row select_package_exists {}]} {
						set NofForums [expr $NofForums+[db_string select_advanced_forums_count {} ]]
					}
					set package_key "faq"
					if {[db_0or1row select_package_exists {}]} {
						set NofFaqs [expr $NofFaqs+[db_string select_advanced_faq_count {} ]]
					}
					set package_key "news"
					if {[db_0or1row select_package_exists {}]} {
						set NofNews [expr $NofNews+[db_string select_advanced_news_count {} ]]
					}
					set package_key "survey"
					if {[db_0or1row select_package_exists {}]} {
						set object_type "survey_response"
						set NofSurveys [expr $NofSurveys+[db_string select_advanced_surveys_count {}]]
					}
	
					set package_key "forums"
					if {[db_0or1row select_package_exists {}]} {
						set object_type "forums_message"
						set NofMessages [expr $NofMessages+[db_string select_advanced_total_messages_post {} ]]
					}
	
					set package_key "file-storage"
					if {[db_0or1row select_package_exists {}]} {
						set object_type "file_storage_object"
						set NofFiles [expr $NofFiles+[db_string select_advanced_total_posts_by_type {} ]]
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
		#Users-card
		set link "?user_id=$user_id"
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
				    ad_return_complaint 1 "<li>[_ dotlrn.couldnt_find_user_id [list user_id $user_id]]</li>"
				    ad_script_abort
				}
				multirow append Users $oneUser "$first_names $last_name" $email $registration_date $last_visit
				set package_key "forums"
				if {[db_0or1row select_package_exists {}]} {
					set object_type "forums_forum"
					set NofForums [expr $NofForums+[db_string select_user_total_posts_by_type {} ]]
				}
				set package_key "faq"
				if {[db_0or1row select_package_exists {}]} {
					set NofFaqs [expr $NofFaqs+[db_string select_user_faq_count {} ]]
				}
				set package_key "news"
				if {[db_0or1row select_package_exists {}]} {
					set NofNews [expr $NofNews+[db_string select_user_news_count {} ]]
				}
				set package_key "survey"
				if {[db_0or1row select_package_exists {}]} {
					set object_type "survey_response"
					set NofSurveys [expr $NofSurveys+[db_string select_user_total_posts_by_type {} ]]
				}
				set package_key "forums"
				if {[db_0or1row select_package_exists {}]} {
					set object_type "forums_message"
					set NofMessages [expr $NofMessages+[db_string select_user_total_posts_by_type {} ]]
				}
				set package_key "file-storage"
				if {[db_0or1row select_package_exists {}]} {
					set object_type "file_storage_object"
					set NofFiles [expr $NofFiles+[db_string select_user_total_posts_by_type {} ]]
				}
			}
		}
	}
} else {
	if {![empty_string_p $community_id]} {
		#communities-card
		set link "?community_id=$community_id"
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
				set package_key "faq"
				if {[db_0or1row select_package_exists {}]} {
					set NofFaqs [expr $NofFaqs+[db_string select_community_faq_count {} ]]
				}
				set package_key "news"
				if {[db_0or1row select_package_exists {}]} {
					set NofNews [expr $NofNews+[db_string select_community_news_count {} ]]
				}
				set package_key "survey"
				if {[db_0or1row select_package_exists {}]} {
					set NofSurveys [expr $NofSurveys+[db_string select_community_surveys_count {} ]]
				}
				set package_key "forums"
				if {[db_0or1row select_package_exists {}]} {
					set NofMessages [expr $NofMessages+[db_string select_community_total_messages_post {} ]]
				}
			}
		}
	} else {
		#Site-card
		set link ""
		ad_require_permission [ad_conn package_id] "admin"
		set package_key "forums"
		if {[db_0or1row select_package_exists {}]} {
			set NofForums [expr $NofForums+[db_string select_forums_count {} ]]
		}
		set package_key "faq"
		if {[db_0or1row select_package_exists {}]} {
			set NofFaqs [expr $NofFaqs+[db_string select_faq_count {} ]]
		}
		set package_key "news"
		if {[db_0or1row select_package_exists {}]} {
			set NofNews [expr $NofNews+[db_string select_news_count {} ]]
		}
		set package_key "survey"
		if {[db_0or1row select_package_exists {}]} {
			set NofSurveys [expr $NofSurveys+[db_string select_surveys_count {}]]
		}
		set package_key "forums"
		if {[db_0or1row select_package_exists {}]} {
			set object_type "forums_message"
			set NofMessages [expr $NofMessages+[db_string select_total_posts_by_type {} ]]
		}
		set package_key "file-storage"
		if {[db_0or1row select_package_exists {}]} {
			set object_type "file_storage_object"
			set NofFiles [expr $NofFiles+[db_string select_total_posts_by_type {} ]]
		}		
	}
}

set total_posted [expr $NofForums+$NofFaqs+$NofNews+$NofSurveys+$NofFiles+$NofMessages]
