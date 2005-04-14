ad_page_contract {
    @author doa (doa@tid.es)
    @author sergiog (sergiog@tid.es)
    @creation-date 2005-03-09
} -query {
} -properties {  
user_id:onevalue
community_id:onevalue
}
set admin_p 0
if {[exists_and_not_null p_hits]} {
	if {$p_hits == 1} { 
		set admin_p [permission::permission_p -party_id [ad_conn user_id] -object_id [ad_conn package_id] -privilege admin]
	}
}
