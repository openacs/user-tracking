?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="select_modified_files">
        <querytext>
		select f.name, f.file_id, f.type, f.content_size,
		       to_char(f.last_modified, 'YYYY-MM-DD HH24:MI:SS') as last_modified,
		       to_char(o.creation_date, 'YYYY-MM-DD HH24:MI:SS') as creation_date,
		       file_storage__get_package_id(f.parent_id) as package_id,
		       (select site_node__url(node_id) from site_nodes
        			where object_id= file_storage__get_package_id(f.parent_id)) as package_url,
		       o.creation_user
		from acs_objects o, fs_files f
		where f.file_id=o.object_id and
		      o.modifying_user= :user_id
		      and o.creation_user <> :user_id
	</querytext>
    </fullquery>


    <fullquery name="get_root_folder">
        <querytext>
	select content_item__get_root_folder(:file_id);
	</querytext>
    </fullquery>

    <fullquery name="select_created_files">      
        <querytext>
		select f.name, f.file_id, f.type, f.content_size,
		       to_char(f.last_modified, 'YYYY-MM-DD HH24:MI:SS') as last_modified,
		       to_char(o.creation_date, 'YYYY-MM-DD HH24:MI:SS') as creation_date,
		       file_storage__get_package_id(f.parent_id) as package_id,
		       (select site_node__url(node_id) from site_nodes
        			where object_id= file_storage__get_package_id(f.parent_id)) as package_url,
		       o.creation_user
		from acs_objects o, fs_files f
		where f.file_id=o.object_id
		      and o.creation_user= :user_id
        </querytext>
    </fullquery>

    <fullquery name="select_user_info">      
        <querytext>
            select first_names,
                   last_name,
                   email,
                   screen_name,
                   creation_date as registration_date,
                   creation_ip,
                   last_visit,
                   member_state,
                   email_verified_p
            from cc_users
            where user_id = :user_id
        </querytext>
    </fullquery>
    
    
    
</queryset>