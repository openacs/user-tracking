<?xml version="1.0"?>

<queryset>

    <fullquery name="select_modified_files">
        <querytext>
		select f.name, f.file_id, f.type, f.content_size,
		       to_char(f.last_modified, 'YYYY-MM-DD HH24:MI:SS') as last_modified,
		       to_char(o.creation_date, 'YYYY-MM-DD HH24:MI:SS') as creation_date,
		       file_storage.get_package_id(f.parent_id) as package_id,
		       (select site_node.url(node_id) from site_nodes
        			where object_id= file_storage.get_package_id(f.parent_id)) as package_url,
		       o.creation_user
		from acs_objects o, fs_files f, acs_objects o2, dotlrn_communities_full com
		where f.file_id=o.object_id and
		      o.modifying_user= :oneUser
		      and o.creation_user <> :oneUser
		      and com.community_id= :oneCom
		      and o2.object_id= file_storage.get_package_id(f.parent_id)
		      and o2.context_id=com.package_id
		      
	</querytext>
    </fullquery>
    
    <fullquery name="select_site_modified_files">
        <querytext>
		select f.name, f.file_id, f.type, f.content_size,
		       to_char(f.last_modified, 'YYYY-MM-DD HH24:MI:SS') as last_modified,
		       to_char(o.creation_date, 'YYYY-MM-DD HH24:MI:SS') as creation_date,
		       file_storage.get_package_id(f.parent_id) as package_id,
		       (select site_node.url(node_id) from site_nodes
        			where object_id= file_storage.get_package_id(f.parent_id)) as package_url,
		       o.creation_user
		from acs_objects o, fs_files f
		where f.file_id=o.object_id 
		and to_char(f.last_modified, 'YYYY-MM-DD HH24:MI:SS') <> to_char(o.creation_date, 'YYYY-MM-DD HH24:MI:SS')
		      
	</querytext>
    </fullquery>    

    <fullquery name="select_site_created_files">
        <querytext>
		select f.name, f.file_id, f.type, f.content_size,
		       to_char(f.last_modified, 'YYYY-MM-DD HH24:MI:SS') as last_modified,
		       to_char(o.creation_date, 'YYYY-MM-DD HH24:MI:SS') as creation_date,
		       file_storage.get_package_id(f.parent_id) as package_id,
		       (select site_node.url(node_id) from site_nodes
        			where object_id= file_storage.get_package_id(f.parent_id)) as package_url,
		       o.creation_user
		from acs_objects o, fs_files f
		where f.file_id=o.object_id
		and to_char(f.last_modified, 'YYYY-MM-DD HH24:MI:SS') = to_char(o.creation_date, 'YYYY-MM-DD HH24:MI:SS')
        </querytext>
    </fullquery>
   
    <fullquery name="select_modified_files_by_user">
        <querytext>
		select f.name, f.file_id, f.type, f.content_size,
		       to_char(f.last_modified, 'YYYY-MM-DD HH24:MI:SS') as last_modified,
		       to_char(o.creation_date, 'YYYY-MM-DD HH24:MI:SS') as creation_date,
		       file_storage.get_package_id(f.parent_id) as package_id,
		       (select site_node.url(node_id) from site_nodes
        			where object_id= file_storage.get_package_id(f.parent_id)) as package_url,
		       o.creation_user
		from acs_objects o, fs_files f
		where f.file_id=o.object_id and
		      o.modifying_user= :oneUser
		      and o.creation_user <> :oneUser
	</querytext>
    </fullquery>

    <fullquery name="select_modified_files_by_com">
        <querytext>
		select f.name, f.file_id, f.type, f.content_size,
		       to_char(f.last_modified, 'YYYY-MM-DD HH24:MI:SS') as last_modified,
		       to_char(o.creation_date, 'YYYY-MM-DD HH24:MI:SS') as creation_date,
		       file_storage.get_package_id(f.parent_id) as package_id,
		       (select site_node.url(node_id) from site_nodes
        			where object_id= file_storage.get_package_id(f.parent_id)) as package_url,
		       o.creation_user
		from acs_objects o, fs_files f, acs_objects o2, dotlrn_communities_full com
		where f.file_id=o.object_id
		      and com.community_id= :oneCom
		      and o2.object_id= file_storage.get_package_id(f.parent_id)
		      and o2.context_id=com.package_id
		      
	</querytext>
    </fullquery>

    <fullquery name="get_root_folder">
        <querytext>
	select content_item.get_root_folder(:file_id);
	</querytext>
    </fullquery>

    <fullquery name="select_created_files">
        <querytext>
		select f.name, f.file_id, f.type, f.content_size,
		       to_char(f.last_modified, 'YYYY-MM-DD HH24:MI:SS') as last_modified,
		       to_char(o.creation_date, 'YYYY-MM-DD HH24:MI:SS') as creation_date,
		       file_storage.get_package_id(f.parent_id) as package_id,
		       (select site_node.url(node_id) from site_nodes
        			where object_id= file_storage.get_package_id(f.parent_id)) as package_url,
		       o.creation_user
		from acs_objects o, fs_files f, acs_objects o2, dotlrn_communities_full com
		where f.file_id=o.object_id
		      and o.creation_user= :oneUser
		      and com.community_id= :oneCom
		      and o2.object_id= file_storage.get_package_id(f.parent_id)
		      and o2.context_id=com.package_id
        </querytext>
    </fullquery>


    <fullquery name="select_created_files_by_user">      
        <querytext>
		select f.name, f.file_id, f.type, f.content_size,
		       to_char(f.last_modified, 'YYYY-MM-DD HH24:MI:SS') as last_modified,
		       to_char(o.creation_date, 'YYYY-MM-DD HH24:MI:SS') as creation_date,
		       file_storage.get_package_id(f.parent_id) as package_id,
		       (select site_node.url(node_id) from site_nodes
        			where object_id= file_storage.get_package_id(f.parent_id)) as package_url,
		       o.creation_user
		from acs_objects o, fs_files f
		where f.file_id=o.object_id
		      and o.creation_user= :oneUser
        </querytext>
    </fullquery>

    <fullquery name="select_created_files_by_com">
        <querytext>
		select f.name, f.file_id, f.type, f.content_size,
		       to_char(f.last_modified, 'YYYY-MM-DD HH24:MI:SS') as last_modified,
		       to_char(o.creation_date, 'YYYY-MM-DD HH24:MI:SS') as creation_date,
		       file_storage.get_package_id(f.parent_id) as package_id,
		       (select site_node.url(node_id) from site_nodes
        			where object_id= file_storage.get_package_id(f.parent_id)) as package_url,
		       o.creation_user
		from acs_objects o, fs_files f, acs_objects o2, dotlrn_communities_full com
		where f.file_id=o.object_id
		      and com.community_id= :oneCom
		      and o2.object_id= file_storage.get_package_id(f.parent_id)
		      and o2.context_id=com.package_id
        </querytext>
    </fullquery>

    <fullquery name="select_user_info">      
        <querytext>
            select first_names,
                   last_name,
                   email,
                   to_char(creation_date, 'YYYY-MM-DD HH24:MI:SS') as registration_date,
                   to_char(last_visit, 'YYYY-MM-DD HH24:MI:SS') as last_visit
            from cc_users
            where user_id = :oneUser
        </querytext>
    </fullquery>

    <fullquery name="select_com_data">
        <querytext>
	   select f.community_key as key,
			f.community_id as id,
			f.pretty_name as pretty_name,
			to_char(o.creation_date, 'YYYY-MM-DD HH24:MI:SS') as creation_date
		from dotlrn_communities_full f, acs_objects o
		where f.community_id= :oneCom
		      and o.object_id= f.community_id
        </querytext>
    </fullquery>
    
    
    
</queryset>