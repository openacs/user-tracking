
ad_page_contract {
    The display logic for the dotlrn main (Groups) portlet

    @author Arjun Sanyal (arjun@openforce.net)
    @version $Id$
} {
} -properties {
    title:onevalue
    context:onevalue 
}

set context {}
set title {}
if {![exists_and_not_null show_buttons_p]} {
    set show_buttons_p 0
}

set user_id [ad_conn user_id]
set user_can_browse_p [dotlrn::user_can_browse_p -user_id $user_id]

set comm_type ""
ns_log notice "hola"
db_multirow communities select_communities {} {
    set tree_level [expr $tree_level - $community_type_level]
    if {![string equal $simple_community_type dotlrn_community]} {
        set comm_type $simple_community_type
    } else {
        set simple_community_type $comm_type
    }
}

set dotlrn_url [dotlrn::get_url]

ad_return_template
