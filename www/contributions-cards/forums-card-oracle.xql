<?xml version="1.0"?>

<queryset>

    <fullquery name="select_forums">
        <querytext>
    	    select (select site_node.url(site_nodes.node_id)
                       from site_nodes, acs_objects
                       where site_nodes.object_id = forums.package_id and acs_objects.object_id = forums.forum_id) as url,
            	forums.name,
            	to_char(o.creation_date, 'YYYY-MM-DD HH24:MI:SS') as posting_date,
            	forums.forum_id as forum_id            	
            from forums_forums forums, acs_objects o, 
            	dotlrn_communities com
            where o.object_id = forums.forum_id
            	and o.creation_user= :oneUser
            	and com.community_id= :oneCom
	    	and apm_package.parent_id(forums.package_id) = com.package_id            	
            order by forums.name
         </querytext>
    </fullquery>

    <fullquery name="select_forums_by_user">
        <querytext>
    	    select (select site_node.url(site_nodes.node_id)
                       from site_nodes, acs_objects
                       where site_nodes.object_id = forums_forums.package_id and acs_objects.object_id = forums_forums.forum_id) as url,
            	forums_forums.name,
            	to_char(acs_objects.creation_date, 'YYYY-MM-DD HH24:MI:SS') as posting_date,
            	forums_forums.forum_id as forum_id            	
            from forums_forums,
            	acs_objects
            where acs_objects.object_id = forum_id
            	and acs_objects.creation_user= :oneUser
            order by forums_forums.name
         </querytext>
    </fullquery>

    <fullquery name="select_forums_by_com">
        <querytext>
   select distinct (select site_node.url(site_nodes.node_id)
                       from site_nodes
                       where site_nodes.object_id = forums.package_id) as url,
            	forums.name as name,
            	to_char(o.creation_date, 'YYYY-MM-DD HH24:MI:SS') as posting_date,
            	forums.forum_id as forum_id            	
            from forums_forums forums,
            	acs_objects o, dotlrn_communities com
            where o.object_id = forums.forum_id            	
            	and com.community_id= :oneCom
	    	and apm_package.parent_id(forums.package_id) = com.package_id
            order by forums.name
         </querytext>
    </fullquery>

    <fullquery name="select_site_forums">
        <querytext>
	   select distinct (select site_node.url(site_nodes.node_id)
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
