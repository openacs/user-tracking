ad_library {

    User-tracking Library

    @creation-date 2004-08-10
    @author David Ortega (doa@tid.es)
    
}

namespace eval user-tracking {

    ad_proc -public get_package_url {
    
    } {
    	Returns url of user-tracking package
    } {
    	
    	return [util_current_location][site_node::get_package_url -package_key [apm_package_key_from_id [ad_conn package_id]]]
    }
    
    ad_proc -public get_user_tracking_dir {
    } {
	Return directoy of user-tracking package
    } {
	return "[acs_root_dir][pkg_home "user-tracking"]"
    }

    ad_proc -public process_sessions {
        
    } {
        process file with sessions info
    } {
    	
	ns_log notice "user-tracking::process_sessions INIT"
	set file_name "[acs_root_dir]/www/results.dat"
	
	
	if { [file exists $file_name] == 1} {
	
		ns_log notice "Opening file $file_name ..."
		set sessions_file [open [acs_root_dir]/www/results.dat r]
		
		while { [gets $sessions_file linea ] >= 0} { 

		scan $linea "%u %u %s %u/%3s/%u %s %u/%3s/%u %s" session_id user_id ip day month year init_time f_day f_month f_year finish_time
		set lista [lc_get abmon]
		set init_date ""
		set finish_date ""
		append init_date "${year}-[expr [lsearch $lista $month] + 1]-${day} $init_time"
		append finish_date "${f_year}-[expr [lsearch $lista $f_month] + 1]-${f_day} $finish_time"
		db_dml write_to_db ""
		} 
		close $sessions_file 

	}
	
    }
    
    ad_proc -public launch_process {
    	horas
    	informes
    } {
    	launches do_data_load if perioricidad=1
    } {
	db_dml delete_scheduled_processes {}
	user-tracking::do_data_load $informes
	set id [ad_schedule_proc  -thread "t" [expr [expr [lindex $horas 3] * 3600] + [expr [lindex $horas 4] * 60]] user-tracking::do_data_load $informes]
    	ns_log notice "\n\nScheduled proc id: $id.  Process will be launched in [expr [expr [lindex $horas 3] * 3600] + [expr [lindex $horas 4] * 60]] seconds\n"
    	db_dml insert_scheduled_process_id {}
    }
    
    ad_proc -public do_data_load {
    	informes
    } {
    	Execute awstats 
    } {
    
        #Processing var "informes"
        
        foreach elm $informes {
       	switch $elm {
       		1 { set all_users_p 1}
       		2 { set all_communities_p 1}
       		3 { set all_all_p 1}
       		4 { set site_p 1}
       	}
        }
	set binPerl [parameter::get -parameter "PerlPath" -default "/usr/bin/perl" ]
	ns_log notice "LEIDO $binPerl"
                   	
        if {[exists_and_not_null all_users_p]} {
        	
        	ns_log notice "USER-TRACKING-->every user"
        	
        	db_foreach user "select user_id  from cc_users" {
         		ns_log notice "USER: $user_id"
			set execAnalyzer [list "$binPerl" "[user-tracking::get_user_tracking_dir]/www/awstats/cgi-bin/awstats_dotlrn.pl" "-config=site" "-update" "-onlyusers=$user_id"]        	     		
   			ns_log notice $execAnalyzer
   			catch {exec [lindex $execAnalyzer 0] [lindex $execAnalyzer 1] [lindex $execAnalyzer 2] [lindex $execAnalyzer 3] [lindex $execAnalyzer 4]} aux
   			ns_log notice $aux
   		}
        }
        if {[exists_and_not_null all_communities_p]} {
        	
        	ns_log notice "USER-TRACKING-->every community"
        	
        	db_foreach community "select community_id from dotlrn_communities" {
        	   ns_log notice "Community: $community_id"
		   set execAnalyzer [list "$binPerl" "[user-tracking::get_user_tracking_dir]/www/awstats/cgi-bin/awstats_dotlrn.pl" "-config=site" "-update" "-onlycoms=$community_id"]        		
   		   catch {exec [lindex $execAnalyzer 0] [lindex $execAnalyzer 1] [lindex $execAnalyzer 2] [lindex $execAnalyzer 3] [lindex $execAnalyzer 4]} aux
        	}
        }
    
        if {[exists_and_not_null all_all_p]} {
        	ns_log notice "USER-TRACKING-->every user in every community"
        	db_foreach community "select community_id from dotlrn_communities" {
        	     	db_foreach user "select user_id  from cc_users" {
	       	     		ns_log notice "Community: $community_id - User: $user_id"
				set execAnalyzer [list "$binPerl" "[user-tracking::get_user_tracking_dir]/www/awstats/cgi-bin/awstats_dotlrn.pl" "-config=site" "-update" "-onlycoms=$community_id" "-onlyusers=$user_id"]        	     		
                   catch {exec [lindex $execAnalyzer 0] [lindex $execAnalyzer 1] [lindex $execAnalyzer 2] [lindex $execAnalyzer 3] [lindex $execAnalyzer 4] [lindex $execAnalyzer 5]} aux
   		}
           }
   
        }
        if {[exists_and_not_null site_p]} {
           ns_log notice "USER-TRACKING-->site"
           set execAnalyzer [list "$binPerl" "[user-tracking::get_user_tracking_dir]/www/awstats/cgi-bin/awstats_dotlrn.pl" "-config=site" "-update"]        	     		
           catch {exec [lindex $execAnalyzer 0] [lindex $execAnalyzer 1] [lindex $execAnalyzer 2] [lindex $execAnalyzer 2]} aux
   
        }
    }

    ad_proc -public select_children_communities {
    	parent_id
    } {
    	Select subcommunities
    } {
    
    	set ComList [list $parent_id]
    	set i 0
    	
    	while {$i < [llength $ComList] } {
    		set aux [lindex $ComList $i]
		set query "select distinct community_id from dotlrn_communities where parent_community_id= $aux"
    		db_foreach com $query {
     			#add child id
			lappend ComList $community_id
     		}
		incr i
     	}
     	
     	return [join $ComList]
     }
     
     ad_proc -public converts_date {
     	fecha_larga 
     } {
     	Returns a pretty date
     } {
	set anyo [string range $fecha_larga 0 3]
	set mes [string range $fecha_larga 4 5]
	set dia [string range $fecha_larga 6 7]
	set hor [string range $fecha_larga 8 9]
	set min [string range $fecha_larga 10 11]
	set seg [string range $fecha_larga 12 13]
	return "$dia/$mes/$anyo - $hor:$min:$seg"
     }

     ad_proc -public get_data_file_name {
     	onlylines
     	onlyuser
     	config
     	{year ""}
     	{month ""}
     } {
     	Returs the name of the DataFileName related with these params
     } {
    
	set config_dir [acs_package_root_dir "user-tracking"]
	append config_dir "/config"
	set configFile [open "${config_dir}/awstats_dotlrn.${config}.conf" r]
	
	set linea [gets $configFile]
	set fin [eof $configFile]
	set patron "\^(DirData)=(.*)"
	
	while { ![eof $configFile] && !$fin} {
		set fin [eof $configFile]
		set linea [gets $configFile]	
		if { [regexp $patron $linea todo part1 DirData] ==1 } {
			set err "Hemos encontrado el patron"
			set fin 1
		}
	}
	
	# Symbol " is needed in the config file
	set data_dir [lindex [split $DirData {"}] 1]
	close $configFile    
	
	# Creating DataFileName
	set date [template::util::date::today]
	if {![exists_and_not_null year]} {
		set year "[template::util::date::get_property year $date]"
	}
	if {![exists_and_not_null month]} {
		set month "[template::util::date::get_property month $date]"
	}
	if { [string length $month] == 1} {
		set month "0${month}"
	}
	set DataFileName "${data_dir}/awstats_dotlrn${month}${year}.${config}"
	
	if {[exists_and_not_null onlyuser]} {
		set onlyuser_aux [lsort -integer -increasing $onlyuser]
		foreach user $onlyuser_aux {
			append DataFileName "ou$user"
		}
	}
	if {[exists_and_not_null onlylines]} {
		set onlylines_aux [lsort -integer -increasing $onlylines]
		foreach group $onlylines_aux {
	   		append DataFileName "oc$group"
		}
	}
	append DataFileName ".txt"
	return $DataFileName
}
	
}

