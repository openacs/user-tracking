
ad_page_contract {
    @author yon (yon@openforce.net)
    @creation-date 2002-01-30
    @version $Id$
} -query {
    {section A}
} -properties {
    control_bar:onevalue
    communities:multirow
}

set dotlrn_package_id [dotlrn::get_package_id]
set root_object_id [acs_magic_object security_context_root]

if {![exists_and_not_null type]} {
    set type "dotlrn_club"
}

if {![exists_and_not_null referer]} {
    set referer "[user-tracking::get_package_url]/communities-stats"
}

set dimension_list {A B C D E F G H I J K L M N O P Q R S T U V W X Y Z}
foreach dimension $dimension_list {
    lappend dimensions [list $dimension $dimension {}]
}
lappend dimensions [list Other Other {}]

set control_bar [portal::dimensional -no_bars [list [list section {} $section $dimensions]]]

set i 1
if {[string equal $type "dotlrn_club"] == 1} {
    set query select_dotlrn_clubs
    if {[string match Other $section]} {
        append query "_other"
    }
    db_multirow communities $query {} {
        incr i
    }
} else {
    set query select_dotlrn_classes
    if {[string match Other $section]} {
        append query "_other"
    }
    db_multirow communities $query {} {
        incr i
    }
}

ad_return_template

