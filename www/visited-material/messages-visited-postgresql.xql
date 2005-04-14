<?xml version="1.0"?>

<queryset>

    <fullquery name="select_message_data">
        <querytext>
    	    select (select site_node__url(site_nodes.node_id)
                       from site_nodes, acs_objects
                       where site_nodes.object_id = forums_forums.package_id and acs_objects.object_id = forums_forums.forum_id) as url,
            	forums_forums.name as name,
            	forums_messages.content,
            	forums_messages.subject as subject,
            	to_char(acs_objects.creation_date, 'YYYY-MM-DD HH24:MI:SS') as posting_date,
            	forums_forums.forum_id as forum_id            	
            from forums_forums,
            	acs_objects, forums_messages
            where forums_messages.message_id= :message_id 
            	and acs_objects.object_id = forums_messages.message_id
            	and forums_messages.forum_id=forums_forums.forum_id
            order by forums_forums.name
         </querytext>
    </fullquery>
    
</queryset>