
ad_page_contract {
    @author yon (yon@openforce.net)
    @creation-date 2002-01-30
    @version $Id$
} -query {
} -properties {
    communities_list:multirow
}

set dotlrn_package_id [dotlrn::get_package_id]
set root_object_id [acs_magic_object security_context_root]

if {![exists_and_not_null type]} {
    set type "dotlrn_club"
}

if {![exists_and_not_null referer]} {
    set referer "[user-tracking::get_package_url]/advanced-stats"
}

set i 1
if {[string equal $type "dotlrn_club"] == 1} {
    db_multirow communities_list select_dotlrn_clubs {} {
        incr i
    }
} elseif {[string equal $type "dotlrn_class"] == 1} {
    db_multirow communities_list select_dotlrn_classes {} {        
        incr i
    }
} else {
    db_multirow communities_list select_dotlrn_communities {} {        
        incr i
    }
}

ad_return_template

