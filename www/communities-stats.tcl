
ad_page_contract {
    Displays the stats users page

    @author yon (elane@tid.es)
    @creation-date 2004-09-15
    @version $Id$
} -query {
    {type "dotlrn_club"}
} -properties {
    control_bar:onevalue
    n_communities:onevalue
}

set page_title [_ user-tracking.lt_Communities_Stats_1]
set context [list $page_title]

set n_clubs [db_string select_dotlrn_clubs_count {}]
set n_classes [db_string select_dotlrn_classes_count {}]

set dotlrn_community_types [list]
lappend dotlrn_community_types [list dotlrn_club "[_ dotlrn.Communities] ($n_clubs)"]
lappend dotlrn_community_types [list dotlrn_class "[_ dotlrn.Classes] ($n_classes)"]

set control_bar [ad_dimensional [list [list type "[_ dotlrn.Community_Type]:" $type $dotlrn_community_types]]]

if {[string equal $type "dotlrn_club"] == 1} {
    set n_communities $n_clubs
} elseif {[string equal $type "dotlrn_class"] == 1} {
    set n_communities $n_classes
} else {
    set n_communities [db_string select_dotlrn_communities_count {}]
}

ad_return_template

