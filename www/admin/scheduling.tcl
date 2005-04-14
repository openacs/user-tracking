ad_page_contract {
    
    Creating a new Scheduling process
    
    @author David Ortega (doa@tid.es)
    @author Sergio González (sergiog@tid.es)
    @creation-date 2004/09/28
} {


}
set page_title "#user-tracking.lt_Program_Data_Charge#"
set context [list $page_title]

#Pages in this directory are only runnable by dotlrn-wide admins.
dotlrn::require_admin 


ad_form -name ut_sched  -form {
    {ut_sched_id:key}

    {start_time:date
        {label "#user-tracking.init_time#"}
        {format {[lc_get formbuilder_time_format]}}
    }
 
    {perioricidad:text(radio)     
        {label "#user-tracking.perioricity#"}
        {html {onClick "javascript:TimePChanged(this);"}} 
        {options {{"#user-tracking.every_x_hours#" 1}
        	  {"#user-tracking.Daily#" 2}
                  {"#user-tracking.weekly#" 3}}}
    }
    
    {horas:date,optional
    	{label "#user-tracking.every_how_many_hours#"}
    	{format {[lc_get formbuilder_time_format]}}
    }
    
    {informes:text(checkbox),multiple
    	{label "#user-tracking.reports_types#"}
    	{options {{"#user-tracking.all_users#" 1}
    		  {"#user-tracking.all_communities#" 2}
    		  {"#user-tracking.every_user_in_every_comm#" 3}
    		  {"#user-tracking.all_site#" 4}}}
    }
    
} 
#----------------------------------------------------------------------
# LARS: Hack to make enable/disable time widgets work with i18n
#----------------------------------------------------------------------

set format_string [lc_get formbuilder_time_format]

multirow create time_format_elms name

while { ![empty_string_p $format_string] } {
    # Snip off the next token
    regexp {([^/\-.: ]*)([/\-.: ]*)(.*)} \
          $format_string match word sep format_string
    # Extract the trailing "t", if any
    regexp -nocase $template::util::date::token_exp $word \
          match token type

    # Output the widget
    set fragment_def $template::util::date::fragment_widgets([string toupper $token])

    multirow append time_format_elms [lindex $fragment_def 1]
}

ad_form -extend -name ut_sched -validate { 

   #HAbria que comprobar que es superior a la fecha actual.
   # {start_date
   #     { [template::util::date::compare $start_date $end_date] <= 0 }
   #     "The term must start before it ends"
   # }
   
   {horas
   	{!(($perioricidad == 1) && ([lindex $horas 3] == 0) && ([lindex $horas 4] == 0))}
   	"Ilegal time scheduling"
    }

} -new_request {
    
	set start_time "{} {} {} 0 0 {} {HH24:MI}"
	set horas "{} {} {} 0 0 {} {HH24:MI}"
	#set start_date "0 0 0 0 0 {} {DDMM}"
	set perioricidad 1
} -on_submit {
    
    #deleting before progrmas 
    db_foreach get_scheduled_processes {} {
    	ns_unschedule_proc $process_id
    	db_dml delete_scheduled_process {}
    	ns_log notice "Deleting process $process_id"
    }
  
    if {$perioricidad == 1 } {
    	
    	#estimating seconds to start_time
    	
    	set time [ns_localtime]
    	set minutes [ns_parsetime min $time]
    	set hour [ns_parsetime hour $time]   
    	set seconds [ns_parsetime sec $time]
     	set hours_diff [expr [lindex $start_time 3] - $hour]
    	set minutes_diff [expr [lindex $start_time 4] - $minutes]
     	set diff [expr [expr [expr $hours_diff * 3600] + [expr $minutes_diff * 60]] - $seconds]
     	
     	ns_log notice "Process will be launched in $diff seconds"
	if {$diff < 0 } {
		#seconds in a day
		incr diff 86400
	}
	#scheduling first execution
   	set id [ad_schedule_proc -once "t" -thread "t" $diff user-tracking::launch_process $horas $informes]
    	ns_log notice "\n\nScheduled proc id: $id\n"
    	db_dml insert_scheduled_process_id {}
    	ns_log notice "[ns_info scheduled]"   	

    } elseif {$perioricidad == 2} {
    	set id [ad_schedule_proc -thread "t" -schedule_proc ns_schedule_daily [list [lindex $start_time 3] [lindex $start_time 4]] user-tracking::do_data_load $informes]
    	ns_log notice "\n\nScheduled proc id: $id\n"
    	db_dml insert_scheduled_process_id {}

    } else { #perioricidad=3 
    	set id [ad_schedule_proc -thread "t" -schedule_proc ns_schedule_weekly [list [lindex $start_time 3] [lindex $start_time 4]] user-tracking::do_data_load $informes]
    	ns_log notice "\n\nScheduled proc id: $id\n"
    	db_dml insert_scheduled_process_id {}

    }

    ad_returnredirect ""
    ad_script_abort
}