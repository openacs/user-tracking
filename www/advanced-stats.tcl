
ad_page_contract {
    Displays the stats users page

    @author yon (elane@tid.es)
    @creation-date 2004-09-15
    @version $Id$
} -query {
    {type_request "user"}
    Users:optional 
    {Communities ""}    
} -properties {
    control_bar:onevalue
    n_vals:onevalue
}

if {![exists_and_not_null Users]} {
	set Users ""
}
set page_title [_ user-tracking.lt_Advanced_Stats]
set context [list $page_title]

set n_users [db_string select_dotlrn_user_count {}]
set n_communities [db_string select_dotlrn_communities_count {}]

set dotlrn_types [list]
lappend dotlrn_types [list user "[_ dotlrn.Users] ($n_users)"]
lappend dotlrn_types [list community "[_ dotlrn.Communities] ($n_communities)"]

set control_bar [ad_dimensional [list [list type_request "Tipo:" $type_request $dotlrn_types]]]

if {[string equal $type_request "user"] == 1} {
    set n_vals $n_users
} else {
    set n_vals $n_communities
}

ad_return_template

