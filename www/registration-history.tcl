ad_page_contract {
    displays a table of number of registrations by month

    @author philg@mit.edu
    @creation-date Jan 1999
    @cvs-id $Id$
    @modified by sergiog@tid.es
} -properties {
    context:onevalue
    user_rows:multirow
    MaxReg:onevalue
    temp:onevalue
}


#Only Admin can see this stats
ad_require_permission [ad_conn package_id] "admin"


set context [list [list "./site-card" "#user-tracking.lt_Site_Stats#"] "[_ user-tracking.lt_Site_Stats]"]
set page_title [_ user-tracking.ut_Registration_Historic]

# we have to query for pretty month and year separately because Oracle pads
# month with spaces that we need to trim

set temp 0
set MaxReg 10


set query registrations

db_0or1row max_register {}

template::list::create \
    -name registrations \
    -multirow registrations \
    -pass_properties temp \
    -elements {
        year {
            label #user-tracking.year#
	    display_col pretty_year
	}
        month {
            label #user-tracking.month#
	    display_col pretty_month
	}
	MaxReg {
	    label "#user-tracking.registers#"
	    display_template {
	    	<img src=img/vh.png height=13 width=@registrations.temp1@>
	    }
	}
        NofReg {
            label "#user-tracking.registers_number#"
	    display_col n_new
	}

    } -filters {
        sort_key {}
    }

db_multirow -extend { 
    temp1
} registrations $query {} {
set temp1 [expr $n_new*100/$MaxReg]
}

#ad_return_template
