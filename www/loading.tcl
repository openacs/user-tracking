ad_page_contract {
    @author sergiog (sergiog@tid.es)
    @author doa (doa@tid.es)
    @creation-date 2005-01-10
} -query { 
} -properties {
}

if {![exists_and_not_null onlyuser] & ![exists_and_not_null onlylines]} {
	set message "[_ user-tracking.making_statistics_site]"
} elseif {![exists_and_not_null onlylines]} {
	set message "[_ user-tracking.making_statistics_users] $onlyuser"
	set onlyuser [string trimleft $onlyuser " "]
} elseif {![exists_and_not_null onlyuser]} {
	set message "[_ user-tracking.making_statistics_communities] $onlylines"
	set onlylines [string trimleft $onlylines " "]
} else {
	set message "[_ user-tracking.making_statistics_advanced]"
	set onlylines [string trimleft $onlylines " "]
	set onlyuser [string trimleft $onlyuser " "]
}

ad_progress_bar_begin \
    -title "" \
    -message_1 "#user-tracking.updating_datafile#" \
    -message_2 "#user-tracking.we_will_continue#"

ns_write "<h2>$message</h2><blockquote>"

set execAnalyzer [list "perl" "[user-tracking::get_user_tracking_dir]/www/awstats/cgi-bin/awstats_dotlrn.pl" "-config=$config" "-update" "-onlycoms=$onlylines" "-onlyusers=$onlyuser"]
ns_log notice $execAnalyzer
catch {exec [lindex $execAnalyzer 0] [lindex $execAnalyzer 1] [lindex $execAnalyzer 2] [lindex $execAnalyzer 3] [lindex $execAnalyzer 4] [lindex $execAnalyzer 5]} aux

set DataFileName [user-tracking::get_data_file_name $onlylines $onlyuser $config $year $month]
ns_log notice $DataFileName
set nodata_p "0"
set noloading 1
if {![file exists $DataFileName]} {
	set nodata_p "1"
set noloading 0
	
}

ad_progress_bar_end -url "${url}type=$type&onlyuser=$onlyuser&onlylines=$onlylines&year=$year&month=$month&nodata_p=$nodata_p&noloading=$noloading"

