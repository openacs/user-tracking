#---------------------------------------------------------------------
#
# ANALOG Support 
#
#---------------------------------------------------------------------

ns_register_filter  preauth GET  "*" log_user_id 
ns_register_filter  preauth POST  "*" log_user_id 


ad_proc -public log_user_id {auth conn} {
    Log user_id
} {
    set user_id [ad_conn user_id]
    set community_id [dotlrn_community::get_community_id]
    if {[empty_string_p $community_id]} {
		set community_id 0
    }
    ns_set put [ns_conn headers] X-User-Id "$user_id\" \"community_id=$community_id"
    #ns_set put [ns_conn headers] X-User-Id $user_id
    return "filter_ok"

}
