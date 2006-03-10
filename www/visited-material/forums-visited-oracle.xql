<?xml version="1.0"?>

<queryset>

    <fullquery name="select_forum_data">
        <querytext>
    	    select (select site_node.url(site_nodes.node_id)
                       from site_nodes, acs_objects
                       where site_nodes.object_id = forums_forums.package_id and acs_objects.object_id = forums_forums.forum_id) as url,
            	forums_forums.name as forum_name,            	
            	forums_forums.forum_id as forum_id            	
            from forums_forums            	
            where forums_forums.forum_id= :forum_id            	
            order by forums_forums.name
         </querytext>
    </fullquery>

</queryset>
