# index.tcl

ad_page_contract {

} {

} -properties {

   
    title:onevalue
    context:onevalue
    admin_p:onevalue

}

set title [_ user-tracking.User_Tracking_Home]
set context "" 

set package_id [ad_conn package_id]

set admin_p [ad_permission_p $package_id admin]


