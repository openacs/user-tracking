
ad_page_contract {
    Displays the stats users page

    @author yon (elane@tid.es)
    @creation-date 2004-09-15
    @version $Id$
} -query {
    {type_request "community"}
    {type dotlrn_club}
} -properties {    
    control_bar_communities:onevalue
    n_vals:onevalue
}


set n_vals [db_string select_dotlrn_communities_count {}]

set n_clubs [db_string select_dotlrn_clubs_count {}]
set n_classes [db_string select_dotlrn_classes_count {}]


set dotlrn_community_types [list]
lappend dotlrn_community_types [list dotlrn_club "[_ dotlrn.Communities] ($n_clubs)"]
lappend dotlrn_community_types [list dotlrn_class "[_ dotlrn.Classes] ($n_classes)"]

set control_bar_communities [ad_dimensional [list [list type "[_ dotlrn.Community_Type]:" $type $dotlrn_community_types]]]

ad_return_template

