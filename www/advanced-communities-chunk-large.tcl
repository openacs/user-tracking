

ad_page_contract {
    @author yon (yon@openforce.net)
    @creation-date 2002-01-30
    @version $Id$
} -query {
    {search_text ""}
} -properties {    
    communities_list:multirow
}

if {![exists_and_not_null type_request]} {   
    set type_request community
}

if {![exists_and_not_null type]} {
    set type "dotlrn_club"
}

if {![exists_and_not_null referer]} {
    set referer "[user-tracking::get_package_url]/advanced-stats"
}


form create community_search -action "/user-tracking/pruebas/advanced-stats"

element create community_search search_text \
    -label [_ dotlrn.Search] \
    -datatype text \
    -widget text \
    -value $search_text

element create community_search type \
    -label [_ dotlrn.Type] \
    -datatype text \
    -widget hidden \
    -value $type

element create community_search referer \
    -label [_ dotlrn.Referer] \
    -datatype text \
    -widget hidden \
    -value $referer

element create community_search type_request \
    -label type_request \
    -datatype text \
    -widget hidden \
    -value $type_request

if {[form is_valid community_search]} {
    form get_values community_search search_text referer

    set dotlrn_package_id [dotlrn::get_package_id]
    set root_object_id [acs_magic_object security_context_root]
    set i 1

    if {[string equal $type "dotlrn_club"] == 1} {
        db_multirow communities_list select_dotlrn_clubs {} {
            incr i
        }
    } else {
        db_multirow communities_list select_dotlrn_classes {} {
            incr i
        }
    }

} else {
    multirow create communities_list dummy
}

ad_return_template


