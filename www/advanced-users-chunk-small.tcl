
ad_page_contract {
    @author yon (yon@openforce.net)
    @creation-date 2002-01-30
    @version $Id$
} -query {
} -properties {
    Userslist:multirow
}

set dotlrn_package_id [dotlrn::get_package_id]
set root_object_id [acs_magic_object security_context_root]

if {![exists_and_not_null referer]} {
    set referer "[user-tracking::get_package_url]/advanced-stats"
}

# Currently, just present a list of dotLRN users
set i 1

    db_multirow Userslist select_dotlrn_users {} {
        incr i
    }

ad_return_template

