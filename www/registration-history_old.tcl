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

set context [list [list "./" "Users"] "Registration History"]

# we have to query for pretty month and year separately because Oracle pads
# month with spaces that we need to trim

set temp 0
set MaxReg 10

db_multirow user_rows user_rows "select to_char(creation_date,'YYYYMM') as sort_key, rtrim(to_char(creation_date,'Month')) as pretty_month, to_char(creation_date,'YYYY') as pretty_year, count(*) as n_new
	from users, acs_objects
	where users.user_id = acs_objects.object_id
	and creation_date is not null
	group by to_char(creation_date,'YYYYMM'), to_char(creation_date,'Month'), to_char(creation_date,'YYYY')
	order by 1" 

db_0or1row max_register {}

template::list::create \
    -name registrations \
    -multirow user_rows \
    -pass_properties { MaxReg } \
    -elements {
        year {
            label "A&ntilde;o"
	    display_col pretty_year
	}
        month {
            label "Mes"
	    display_col pretty_month
	}
	MaxReg {
	    label "Registros"
	    display_template {
	    	<% set temp [expr @n_new@*100/@MaxReg@] %>
	    	<img src=img/vh.png height=@ancho_col@>@ancho_col@
	    }
	}
        NofReg {
            label "N&uacute;mero de registros"
	    display_col n_new
	}

    } -filters {
        sort_key {}
    }


ad_return_template
