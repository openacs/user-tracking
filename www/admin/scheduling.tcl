ad_page_contract {
    
    Creating a new Scheduling process
    
    @author David Ortega (doa@tid.es)
    @author Sergio González (sergiog@tid.es)
    @creation-date 2004/09/28
} {


}
set page_title "Programar carga de Datos"
set context [list $page_title]

#Pages in this directory are only runnable by dotlrn-wide admins.
dotlrn::require_admin 


ad_form -name ut_sched  -form {
    {ut_sched_id:key}

#   {start_date:date,to_sql(linear_date),to_html(sql_date)
#	{label "Fecha de inicio"}
#    }
	
    {start_time:date
        {label "Hora de inicio"}
        {format {[lc_get formbuilder_time_format]}}
    }
 
    {perioricidad:text(radio)     
        {label "Perioricidad"}
        {html {onClick "javascript:TimePChanged(this);"}} 
        {options {{"Cada x horas" 1}
        	  {"Diaria" 2}
                  {"Semanal" 3}}}
    }
    
    {horas:date,optional
    	{label "Cada cuántas horas?"}
    	{format {[lc_get formbuilder_time_format]}}
    }
    
    {informes:text(checkbox),multiple
    	{label "Tipos de informes"}
    	{options {{"Todos los usuarios" 1}
    		  {"Todas las comunidades" 2}
    		  {"Todos los usuarios en todas la comunidades" 3}
    		  {"Todo el sitio web" 4}}}
    }
    
  #  {my_key:text(multiselect),multiple       {label "select some values"}
  #                                           {options {first second third fourth fifth}}
  #                                            {html {size 4}}}
    
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
    
    ns_log notice "He obtenido lo siguiente:\n \t\t \n\t\t Hora inicio= $start_time \n\t\t perioricidad=$perioricidad horas=$horas informes=$informes"

    #Programo la ejecución del procedimiento
    #user-tracking::do_data_load $informes
    
    #Borro programaciones anteriores
    db_foreach get_scheduled_processes {} {
    	ns_unschedule_proc $process_id
    	db_dml delete_scheduled_process {}
    	ns_log notice "Desprogramado proceso $process_id"
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
     	
     	ns_log notice "El proceso se lanzará dentro de $diff segundos"
	if {$diff < 0 } {
		#seconds in a day
		incr diff 86400
	}
	#scheduling first execution
   	set id [ad_schedule_proc -once "t" -thread "t" $diff user-tracking::launch_process $horas $informes]
    	ns_log notice "\n\nId del proc programado $id\n"
    	db_dml insert_scheduled_process_id {}
    	ns_log notice "[ns_info scheduled]"   	

    } elseif {$perioricidad == 2} {
    	set id [ad_schedule_proc -thread "t" -schedule_proc ns_schedule_daily [list [lindex $start_time 3] [lindex $start_time 4]] user-tracking::do_data_load $informes]
    	ns_log notice "\n\nId del proc programado $id\n"
    	db_dml insert_scheduled_process_id {}

    } else { #perioricidad=3 
    	set id [ad_schedule_proc -thread "t" -schedule_proc ns_schedule_weekly [list [lindex $start_time 3] [lindex $start_time 4]] user-tracking::do_data_load $informes]
    	ns_log notice "\n\nId del proc programado $id\n"
    	db_dml insert_scheduled_process_id {}

    }


    #Página siguiente
    ad_returnredirect ""
    ad_script_abort
}