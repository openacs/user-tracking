# E-Lane 19-10-2004
# Lanzador de awstats, comprobando Permisos
# Version 0.1b
# Author E-Lane TID

ad_page_contract {
    Displays the stats users page

    @author sergiog (sergiog@tid.es)
    @author doa     (doa@tid.es)    
    @creation-date 2004-10-19
    @version $Id$
} -query {
	{community_id ""}
	{user_id ""}
	{onlyusers ""}
	{onlylines ""}
	{config ""}
	{sitedomain ""}
} -properties {
    user_id:onevalue
    community_id:onevalue
}

# First of all, we have to delete all blank spaces
regsub -all -- "(%20)+" $onlylines " " onlylines
regsub -all -- "\[\\t \\r\\n\]+" $onlylines " " onlylines
regsub -all -- "(%20)+" $onlyusers " " onlyusers
regsub -all -- "\[\\t \\r\\n\]+" $onlyusers " " onlyusers


# If we don´t receive any value, we do nothing
if {[empty_string_p $community_id] && [empty_string_p $onlyusers] && [empty_string_p $onlylines] && [empty_string_p $config]} {
    ns_log notice "No hay community Id, hace falta ser Adminisrtador"
    ad_require_permission [ad_conn package_id] "admin"
#    ad_returnredirect [user-tracking::get_package_url]
    ad_returnredirect "/user-tracking"
}

#Add the prefer language of the user, if it isn´t implemented we use english by default
set Language [lang::conn::locale]

switch $Language {
	en_Us {set parseString "&lang=en"}
	es_ES {set parseString "&lang=es"}
	de_DE {set parseString "&lang=de"}
	fr_FR {set parseString "&lang=fr"}
	ar_LB {set parseString "&lang=ar"}
	hu_HU {set parseString "&lang=hu"}
	pt_PT {set parseString "&lang=pt"}
	ro_RO {set parseString "&lang=ro"}
	ru_RU {set parseString "&lang=ru"}
	sv_SE {set parseString "&lang=se"}
	it_IT {set parseString "&lang=it"}
	gl_ES {set parseString "&lang=gl"}
	zh_CN {set parseString "&lang=cn"}
	zh_TW {set parseString "&lang=cn"}
	da_DK {set parseString "&lang=dk"}
	en_GB {set parseString "&lang=en"}
	el_GR {set parseString "&lang=gr"}
	ja_JP {set parseString "&lang=jp"}
	ko_KR {set parseString "&lang=kr"}
	nn_NO {set parseString "&lang=nn"}	
	no_NO {set parseString "&lang=nb"}
	pl_PL {set parseString "&lang=pl"}
	tr_TR {set parseString "&lang=tr"}
	default {set parseString "&lang=en"}
}

#parseString contains all the parameters we need to pass awstats
if {[empty_string_p $config]} {
	append parseString "&config=site"
} else {
	append parseString "&config=$config"
}

if {![empty_string_p $sitedomain]} {
	append parseString "&sitedomain=$sitedomain"
}


#Depend on kind of report, required permission will be different
if {[empty_string_p $community_id] } {
	if {![empty_string_p $user_id]} {
                set new_user_id [ad_conn user_id]
                if {[string equal $new_user_id $user_id]} {                        
			append parseString "&onlyusers=$user_id"
		} else {
			ad_require_permission [ad_conn package_id] "admin"
			append parseString "&onlyusers=$user_id"
		}
	} else {
		ns_log notice "Informe general, hace falta ser Adminisrtador"
		ad_require_permission [ad_conn package_id] "admin"
		if {![empty_string_p $onlyusers]} {
			append parseString "&onlyusers=$onlyusers"
		}
		if {![empty_string_p $onlylines]} {
			set auxParse ""
			foreach aux [split $onlylines] {
				if {![empty_string_p $aux]} {
					set auxParse "REGEX\[.*community_id=$aux.*\] $auxParse"
				}
			}
			if {![empty_string_p $auxParse]} {
				append parseString "&onlylines=$auxParse"
			}
		}
	
		ns_log notice "informe general: Vamos a llamar a awstats con los parametros: $parseString"
	}
	ad_returnredirect "/user-tracking/awstats/cgi-bin/awstatsDirecto.pl?$parseString&update=1"
} else {	
	if {![empty_string_p $user_id]} {		
		set new_user_id [ad_conn user_id]
		if {[string equal $new_user_id $user_id]} {
			ad_require_permission $community_id "read"
			ns_log notice "Estadisticas de un usuario, se permite solo con pertenecer: $parseString"
			append parseString "&onlyusers=$user_id"
		} else {			
			ad_require_permission [ad_conn package_id] "admin"
			ns_log notice "No es el mismo usuario,solo dejamos si es admin: $parseString"	
			append parseString "&onlyusers=$user_id"
		}
	} else {
		ns_log notice "Informe de clase, profesor"
		ad_require_permission $community_id "admin"	
		if {![empty_string_p $onlyusers]} {
			append parseString "&onlyusers=$onlyusers"
		}
	}

	append parseString "&onlylines=REGEX\[.*community_id=$community_id.*\]"
	ns_log notice "Informe de profe: Vamos a llamar a awstats con los parametros: $parseString"	
	ad_returnredirect "/user-tracking/awstats/cgi-bin/awstatsDirecto.pl?$parseString&update=1"
}

