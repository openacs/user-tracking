
ad_page_contract {
    Displays the stats users page

    @author Sergio (sergiog@tid.es)
    @creation-date 2004-09-15
} -query {
} -properties {
    n_users:onevalue
}

set page_title [_ user-tracking.User_Stats]
set context [list $page_title]

set n_users [db_string select_dotlrn_users_count {}]

ad_return_template

