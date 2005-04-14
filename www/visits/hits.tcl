ad_page_contract {
    @author sergiog (sergiog@tid.es)
    @author doa (doa@tid.es)
    @creation-date 2005-03-10
} -query { 
	{config "site"}
	{user_id ""}
	{community_id ""}
	{DataFileName ""}	
	
} -properties {
	
	Hits:onelist
	
}

dotlrn::require_admin 

set dataFile [open "$DataFileName" r] 


#Getting map
set linea [gets $dataFile]
set fin [eof $dataFile]
set patron "(BEGIN_MAP) (.*)"
while { $fin == 0} {
	set linea [gets $dataFile]
	set fin [eof $dataFile]
	if { [regexp $patron $linea todo part1 SectionCount] ==1 } {
		set fin 1
	}
}

set fin 0
set patron "^(\[A-Z\\_0-9\]*) (.*)"
while { $fin == 0} {
	set linea [gets $dataFile]
	set fin [eof $dataFile]
	if { [regexp $patron $linea todo part1 part2] ==1 } {
		set Map($part1) $part2 
	}
	if { $linea == "END_MAP"} {
		set fin 1
	}
}


#Getting data about maximum hits

set pos $Map(POS_EXTRA_9)
seek $dataFile $pos
set linea [gets $dataFile]
set patron "(PETITION_BEGIN) (.*)"
while { ![regexp $patron $linea todo part1 part2] } {	
	set linea [gets $dataFile]	
	if {[eof $dataFile]} {
		set part2 0
		break;
	}
}

set i $part2

template::multirow create Hits Date Number

while { $i > 0} {	
	set linea [gets $dataFile]
	set campos [split $linea]
	multirow append Hits [user-tracking::converts_date [lindex $campos 0]] [lindex $campos 1] 
	set i [expr $i - 1]
	if {[eof $dataFile]} { #Wrong file?
		break;
	}
}

close $dataFile

#template::multirow sort Hits -integer -decreasing Number

template::list::create \
    -name Hits \
    -multirow Hits \
    -elements {
        date {
            label "#user-tracking.Date#"
            display_col Date     
	    html {align center}
        }
        Number {
            label "#user-tracking.Hits#"
            display_col Number
	    html {align center}
        }

     }\
     -html {align center}

ad_return_template
