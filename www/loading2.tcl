ad_page_contract {
    @author sergiog (sergiog@tid.es)
    @author doa (doa@tid.es)
    @creation-date 2005-01-10
} -query { 
	{config ""}
	{onlyuser ""}
	{onlylines ""}
	{url ""}
} -properties {
}

set message "[_ user-tracking.updating_statistics]"


ad_progress_bar_begin \
    -title "" \
    -message_1 "#user-tracking.updating_datafile#" \
    -message_2 "#user-tracking.we_will_continue#"

ns_write "<h2>$message</h2><blockquote>"

set execAnalyzer [list "perl" "[user-tracking::get_user_tracking_dir]/www/awstats/cgi-bin/awstats_dotlrn.pl" "-config=$config" "-update" "-onlycoms=$onlylines" "-onlyusers=$onlyuser"]
ns_log notice $execAnalyzer
catch {exec [lindex $execAnalyzer 0] [lindex $execAnalyzer 1] [lindex $execAnalyzer 2] [lindex $execAnalyzer 3] [lindex $execAnalyzer 4] [lindex $execAnalyzer 5]} aux
if {[exists_and_not_null url]} {
	switch $url {
		users-card { ad_progress_bar_end -url $url?user_id=$onlyuser }
		communities-card {ad_progress_bar_end -url $url?community_id=$onlylines}
		advanced-card {ad_progress_bar_end -url $url?onlylines=$onlylines&onlyuser=$onlyuser}
	}
} else {
	ad_progress_bar_end -url site-card
}

