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
	# return "[acs_root_dir][pkg_home [apm_package_key_from_id [ad_conn package_id]]]"
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
		# Se procesa la variable "linea" 
		# Hay un pb con el nombre del mes. No se puede meter directamente, ya que viene en español y la bd lo espera en inglés
		# o en formato numérico. Por eso lo paso a formato numérico.
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
    	ns_log notice "\n\nId del proc programado $id. Se ejecutará dentro de [expr [expr [lindex $horas 3] * 3600] + [expr [lindex $horas 4] * 60]] segundos\n"
    	db_dml insert_scheduled_process_id {}
    }
    
    ad_proc -public do_data_load {
    	informes
    } {
    	Execute awstats 
    } {
    
     #Proceso la variable "informes"
     
     foreach elm $informes {
    	switch $elm {
    		1 { set all_users_p 1}
    		2 { set all_communities_p 1}
    		3 { set all_all_p 1}
    		4 { set site_p 1}
    	}
     }
	
     if {[exists_and_not_null all_users_p]} {
     	
     	ns_log notice "Ejecuto script para cada usuario"
     	
     	db_foreach user "select user_id  from cc_users" {
     		#Ejecuto script para cada usuario
     		#ns_log notice "USUARIO: $user_id"
		set execAnalyzer [list "/usr/bin/perl" "[get_user_tracking_dir]/www/awstats/cgi-bin/awstatsDirecto.pl" "-config=elane" "-update" "-onlyusers=$user_id"]
		#ns_log notice "User: $user_id, ejecutamos: $execAnalyzer"

		catch {exec [lindex $execAnalyzer 0] [lindex $execAnalyzer 1] [lindex $execAnalyzer 2] [lindex $execAnalyzer 3] [lindex $execAnalyzer 4]} aux

	}
     }
     if {[exists_and_not_null all_communities_p]} {
     	
     	ns_log notice "Ejecuto script para cada comunidad"
     	
     	db_foreach community "select community_id from dotlrn_communities" {
     		
     		#ejecuto script para cada comunidad
     		#ns_log notice "Comunidad: $community_id"
                set execAnalyzer [list "[get_user_tracking_dir]/www/awstats/cgi-bin/awstatsDirecto.pl" "-config=elane" "-update" "-onlylines=REGEX[.*community_id=$community_id.*]"] 
                catch {exec [lindex $execAnalyzer 0] [lindex $execAnalyzer 1] [lindex $execAnalyzer 2] [lindex $execAnalyzer 3]} aux
     	}
     }
 
     if {[exists_and_not_null all_all_p]} {
     	ns_log notice "Ejecuto script para cada usuario en cada comunidad"
     	db_foreach community "select community_id from dotlrn_communities" {
     	     	db_foreach user "select user_id  from cc_users" {
     	     		#ejecuto para cada user en cada comunidad
     	     		ns_log notice "Comunidad: $community_id - User: $user_id"
	                set execAnalyzer [list "[get_user_tracking_dir]/www/awstats/cgi-bin/awstatsDirecto.pl" "-config=elane" "-update" "-onlylines=REGEX[.*community_id=$community_id.*]" "-onlyusers=$user_id"]
                catch {exec [lindex $execAnalyzer 0] [lindex $execAnalyzer 1] [lindex $execAnalyzer 2] [lindex $execAnalyzer 3] [lindex $execAnalyzer 4]} aux
		}
        }

     }
     if {[exists_and_not_null site_p]} {
     	ns_log notice "Ejecuto script sólo para el sitio web"
        set execAnalyzer [list "[get_user_tracking_dir]/www/awstats/cgi-bin/awstatsDirecto.pl" "-config=elane" "-update"]
        catch {exec [lindex $execAnalyzer 0] [lindex $execAnalyzer 1] [lindex $execAnalyzer 2]} aux

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

    ad_proc -public write_users_file {
    } {
    	Writes users in db to usersinfo.txt
    } {
    
   	   #Leer un parámetro de config.tcl
	   set logdir [ns_config "ns/parameters" serverlog]
	   #Me quedo con lo que me interesa
	   set patron "(.*)(\/(.)*\.log$)"
	   regexp $patron $logdir all dir part2 ]
	   append dir "/" 

	   #Escribo fichero de users.txt
	   set filename "${dir}awstat/userinfo.txt"
	   ns_log notice "Escribiendo en $filename"	
	   set config_file [open $filename w]
	   db_foreach get_users "select person_id, first_names, last_name from persons" {
	   	puts $config_file "$person_id \t $first_names $last_name"
	   }   
	   close $config_file 
	}

}

