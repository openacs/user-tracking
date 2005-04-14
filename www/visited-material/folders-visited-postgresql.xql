<?xml version="1.0"?>

<queryset>

    <fullquery name="select_folders">
        <querytext>
		select f.name, 
		       (select site_node__url(node_id) from site_nodes
        			where object_id= file_storage__get_package_id(:folder_id)) as url
		from fs_folders f
		where f.folder_id=:folder_id
	</querytext>
    </fullquery>
</queryset>