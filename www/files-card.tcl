ad_page_contract {
    @author sergiog (sergiog@tid.es)
    @author doa (doa@tid.es)
    @creation-date 2004-11-23
} -query { 
    {user_id ""}
} -properties {
    created_files:multirow
    modified_files:multirow
    first_names:onevalue
    last_name:onevalue
    email:onevalue
    user_id:onevalue
    
}

if {![exists_and_not_null referer]} {
    set referer "[user-tracking::get_package_url]/users-stats"
}

if {![exists_and_not_null user_id]} {    
    ad_returnredirect $referer
}

if {![db_0or1row select_user_info {}]} {
    ad_return_complaint 1 "<li>[_ dotlrn.couldnt_find_user_id [list user_id $user_id]]</li>"
    ad_script_abort
}

set page_title [_ user-tracking.Files_Stats]
set context [list $page_title]

set new_user_id [ad_conn user_id]
if {![string equal $new_user_id $user_id]} {
	ad_require_permission [ad_conn package_id] "admin"
}


set query select_created_files
#ad_return_template

template::list::create \
    -name created_files \
    -multirow created_files \
    -elements {
        name {
            label "#file-storage.Name#"
            link_url_col files_url
            display_col name
        }
        type {
            label "#file-storage.Type#"
            display_col type
        }  
        size {
            label "#file-storage.Size#"
            display_col content_size
        }              
        creation_date {
            label "#user-tracking.Post_Date#"
            display_col posting_date_pretty
        }
        last_modified {
            label "#file-storage.Last_Modified#"
            display_col modified_date_pretty
        }

    } -filters {
        package_id {}
    }

db_multirow -extend { 
    files_url
    posting_date_pretty
    modified_date_pretty
} created_files $query {} {

   set posting_date_ansi [lc_time_system_to_conn $creation_date]
   set posting_date_pretty [lc_time_fmt $posting_date_ansi "%x %X"]
   set modified_date_ansi [lc_time_system_to_conn $creation_date]
   set modified_date_pretty [lc_time_fmt $modified_date_ansi "%x %X"]
  
   set files_url "${package_url}file?file_id=$file_id"

}

set query select_modified_files
#ad_return_template

template::list::create \
    -name modified_files \
    -multirow modified_files \
    -elements {
        name {
            label "#file-storage.Name#"
            link_url_col files_url
            display_col name
        }
        type {
            label "#file-storage.Type#"
            display_col type
        }  
        size {
            label "#file-storage.Size#"
            display_col content_size
        }              
        creation_date {
            label "#user-tracking.Post_Date#"
            display_col posting_date_pretty
        }
        last_modified {
            label "#file-storage.Last_Modified#"
            display_col modified_date_pretty
        }

    } -filters {
        package_id {}
    }

db_multirow -extend { 
    files_url
    posting_date_pretty
    modified_date_pretty
} modified_files $query {} {

   set posting_date_ansi [lc_time_system_to_conn $creation_date]
   set posting_date_pretty [lc_time_fmt $posting_date_ansi "%x %X"]
   set modified_date_ansi [lc_time_system_to_conn $creation_date]
   set modified_date_pretty [lc_time_fmt $modified_date_ansi "%x %X"]
  
   set files_url "${package_url}file?file_id=$file_id"

}


ad_return_template
