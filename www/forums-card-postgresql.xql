<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="select_forums_old">
        <querytext>
	    select forums_forums.package_id,
            	acs_object__name(apm_package__parent_id(forums_forums.package_id)) as parent_name,
            	(select site_node__url(site_nodes.node_id)
            		from site_nodes
            		where site_nodes.object_id = forums_forums.package_id) as url,
            	forums_forums.forum_id,
            	forums_forums.name,
            	case when last_modified > (cast(current_timestamp as date)- 1) then 't' else 'f' end as new_p,
            	forums_messages.content
            from forums_forums_enabled forums_forums,
            	acs_objects, forums_messages
            where acs_objects.object_id = forums_forums.forum_id
            	and forums_messages.forum_id=forums_forums.forum_id
            	and acs_objects.creation_user= :user_id
            order by parent_name,
            	forums_forums.name
             
        </querytext>
    </fullquery>

    <fullquery name="select_forums">
        <querytext>
    	    select (select site_node__url(site_nodes.node_id)
                       from site_nodes, acs_objects
                       where site_nodes.object_id = forums_forums.package_id and acs_objects.object_id = forums_forums.forum_id) as url,
            	forums_forums.name,
            	forums_messages.content,
            	forums_messages.message_id,
            	forums_messages.subject,
            	to_char(acs_objects.creation_date, 'YYYY-MM-DD HH24:MI:SS') as posting_date,
            	forums_forums.forum_id as forum_id            	
            from forums_forums,
            	acs_objects, forums_messages
            where acs_objects.object_id = forums_messages.message_id
            	and forums_messages.forum_id=forums_forums.forum_id
            	and acs_objects.creation_user= :user_id
            order by forums_forums.name
         </querytext>
    </fullquery>

    <fullquery name="select_forums_by_com">
        <querytext>
   select distinct (select site_node__url(site_nodes.node_id)
                       from site_nodes
                       where site_nodes.object_id = forums.package_id) as url,
            	forums.name as name,
            	to_char(o.creation_date, 'YYYY-MM-DD HH24:MI:SS') as posting_date,
            	forums.forum_id as forum_id            	
            from forums_forums forums,
            	acs_objects o, dotlrn_communities com
            where o.object_id = forums.forum_id            	
            	and com.community_id= :community_id
	    	and apm_package__parent_id(forums.package_id) = com.package_id
            order by forums.name
         </querytext>
    </fullquery>

    <fullquery name="select_site_forums">
        <querytext>
	   select distinct (select site_node__url(site_nodes.node_id)
                       from site_nodes
                       where site_nodes.object_id = forums.package_id) as url,
            	forums.name as name,
            	to_char(o.creation_date, 'YYYY-MM-DD HH24:MI:SS') as posting_date,
            	forums.forum_id as forum_id            	
            from forums_forums forums, acs_objects o
            where o.object_id = forums.forum_id
            order by forums.name
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

    <fullquery name="select_com_data">
        <querytext>
           select distinct h.pretty_name as first_names
		from dotlrn_communities h
		where h.community_id= :community_id
        </querytext>
    </fullquery>

</queryset>
