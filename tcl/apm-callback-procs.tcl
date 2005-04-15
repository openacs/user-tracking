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

   #Reading logdir from config.tcl
   set logdir [ns_config "ns/parameters" serverlog]
   set patron "(.*)(\/(.)*\.log$)"
   regexp $patron $logdir all dir part2 ]
   append dir "/"

   set server [ns_info server]
   set system_name [ad_system_name]
   set http_port [ns_conn location]
   
   set ip [util_current_location]
   
   #Look for config files
   set ut_dir [acs_package_root_dir "user-tracking"]
   append config_dir $ut_dir "/config"
   set file_name "${config_dir}/awstats_dotlrn.site.conf"
   if { [file exists $file_name] == 1} {   
 	set config_file [open $file_name a]
	set logdir [ns_config "ns/server/[ns_info server]/module/nslog" file] 
	set patron "(.*)(\.log$)"
	regexp $patron $logdir all part1 part2 ]
		
	puts $config_file "LogFile=\"${ut_dir}/tools/logresolvemerge.pl ${part1}* | \""
	puts $config_file "SiteDomain=\"${server}\""
	puts $config_file "HostAliases=\"${server} www.${server} ${system_name} www.${system_name} ${ip} 127.0.0.1 localhost\""
	puts $config_file "DirData=\"${dir}awstat\""
 
   	close $config_file
   }
    
}

ad_proc -private user-tracking::apm_callbacks::my_upgrade_callback {
        {-from_version_name:required}
        {-to_version_name:required}
    } {

    Write config file after an upgrade

    @author David Ortega (doa@tid.es)

} {

        apm_upgrade_logic -from_version_name $from_version_name \
        	-to_version_name $to_version_name \
        	-spec {
            	
            		0.1d 0.1d2 {
                		user-tracking::apm_callbacks::package_install
               		}
               		
         	}
    }