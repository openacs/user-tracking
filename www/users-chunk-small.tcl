
ad_page_contract {
    @author yon (yon@openforce.net)
    @creation-date 2002-01-30
    @version $Id$
} -query {
} -properties {
    user_id:onevalue
    users:multirow
}

set user_id [ad_conn user_id]
set dotlrn_package_id [dotlrn::get_package_id]
set root_object_id [acs_magic_object security_context_root]

if {![exists_and_not_null referer]} {
    set referer "[user-tracking::get_package_url]/users-stats"
}

# Currently, just present a list of dotLRN users
set i 1
    db_multirow users select_dotlrn_users {} {
        if {[dotlrn::user_can_browse_p -user_id $user_id]} {
            set users:${i}(access_level) Full
        } else {
            set users:${i}(access_level) Limited
        }
        incr i
    }


ad_return_template

