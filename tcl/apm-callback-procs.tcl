ad_library {

    user-tracking Package APM callbacks library
    
    Procedures that deal with installing, instantiating, mounting.

    @creation-date 2004-10-29
    @author David Ortega <doa@tid.es>
}

namespace eval user-tracking::apm_callbacks {}

ad_proc -private user-tracking::apm_callbacks::package_install {} {

    Update config files

    @author David Ortega (doa@tid.es)

} {


   #Leer un parámetro de config.tcl
   set logdir [ns_config "ns/parameters" serverlog]
   #Me quedo con lo que me interesa
   set patron "(.*)(\/(.)*\.log$)"
   regexp $patron $logdir all dir part2 ]
   append dir "/"

   set server [ns_info server]
   set system_name [ad_system_name]
   set http_port [ns_conn location]
   
   set ip [util_current_location]
   
   #Busco ficheros de configuración
   set ut_dir [acs_package_root_dir "user-tracking"]
   append config_dir $ut_dir "/config" 
   set files [exec "find" $config_dir "-maxdepth" "1" "-type" "f"] 
   #Escribo los parámetros al final de cada fichero
   	
   for {set x 0} {$x<[llength $files]} {incr x} {
   	set file_name [lindex $files $x]
   	
   	if { [file exists $file_name] == 1} {   

   		set config_file [open $file_name a]
		set logdir [ns_config "ns/server/[ns_info server]/module/nslog" file] 
		set patron "(.*)(\.log$)"
		regexp $patron $logdir all part1 part2 ]
		
		puts $config_file "LogFile=\"${ut_dir}/tools/logresolvemerge.pl ${part1}* | \""
		puts $config_file "SiteDomain=\"${server}\""
		puts $config_file "HostAliases=\"${server} www.${server} ${system_name} www.${system_name} ${ip} 127.0.0.1 localhost\""
		puts $config_file "DirData=\"${dir}awstat\""
		#puts $config_file "Lang=\"es\""
		#puts $config_file "ShowFlagLinks=\"en fr de\""
 
   		close $config_file
   	}
   }


   # Escribo fichero de users.txt
   exec "/bin/mkdir" ${dir}awstat
   set touch [exec "/bin/touch" ${dir}awstat/userinfo.txt]
   set filename "${dir}awstat/userinfo.txt"
   ns_log notice "Escribiendo en $filename"	
   set config_file [open $filename w]
   db_foreach get_users "select person_id, first_names, last_name from persons" {
   	puts $config_file "$person_id \t $first_names $last_name"
   }   
   close $config_file   
   
   set touch [exec "/bin/touch" ${config_dir}/AllowedUrls.conf]
   set filename "${config_dir}/AllowedUrls.conf"	
   ns_log notice "Escribiendo en $filename"	
   set config_file [open $filename w]
   puts $config_file $ip

   close $config_file   





   #Leer un parámetro del paquete
   #set paquete [parameter::get -parameter "logsDir"]     
   #Fijar un parámetro del paquete
   #parameter::set_value  -parameter "logsDir" -value $dir  
     
}
