
ad_page_contract {
    Displays the stats users page

    @author yon (elane@tid.es)
    @creation-date 2004-09-15
    @version $Id$
} -query {
    {type_request "user"}
} -properties {
    control_bar_users:onevalue
    n_vals:onevalue
}

set n_vals [db_string select_dotlrn_user_count {}]

set context_bar [_ dotlrn.Users]

ad_return_template

