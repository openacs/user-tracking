<?xml version="1.0"?>

<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="select_active_news">
        <querytext>
            select news.package_id,
                   acs_object.name(apm_package.parent_id(news.package_id)) as parent_name,
                   (select site_node.url(site_nodes.node_id)
                    from site_nodes
                    where site_nodes.object_id = news.package_id) as url,
                   news.item_id,
                   news.publish_title,
                   to_char(news.publish_date, 'YYYY-MM-DD HH24:MI:SS') as publish_date_ansi
            from news_items_approved news, dotlrn_communities com
            where news.publish_date < sysdate--current_timestamp
            	and (news.archive_date >= sysdate/*current_timestamp*/ or news.archive_date is null)
             	and news.creation_user= :oneUser
             	and com.community_id= :oneCom
            	and apm_package.parent_id(news.package_id) = com.package_id
            order by news.publish_date desc,
                     news.publish_title
       </querytext>
    </fullquery>

    <fullquery name="select_non_active_news">
        <querytext>
            select news.package_id,
                   acs_object.name(apm_package.parent_id(news.package_id)) as parent_name,
                   (select site_node.url(site_nodes.node_id)
                    from site_nodes
                    where site_nodes.object_id = news.package_id) as url,
                   news.item_id,
                   news.publish_title,
                   to_char(news.publish_date, 'YYYY-MM-DD HH24:MI:SS') as publish_date_ansi
            from news_items_approved news, dotlrn_communities com
            where (news.publish_date >= sysdate --current_timestamp
            	or news.archive_date < sysdate /*current_timestamp*/)
             	and news.creation_user= :oneUser
             	and com.community_id= :oneCom
            	and apm_package.parent_id(news.package_id) = com.package_id
            order by news.publish_date desc,
                     news.publish_title
        </querytext>
    </fullquery>

    <fullquery name="select_active_news_by_user">
        <querytext>
            select news_items_approved.package_id,
                   acs_object.name(apm_package.parent_id(news_items_approved.package_id)) as parent_name,
                   (select site_node.url(site_nodes.node_id)
                    from site_nodes
                    where site_nodes.object_id = news_items_approved.package_id) as url,
                   news_items_approved.item_id,
                   news_items_approved.publish_title,
                   to_char(news_items_approved.publish_date, 'YYYY-MM-DD HH24:MI:SS') as publish_date_ansi
            from news_items_approved
            where news_items_approved.publish_date < sysdate --current_timestamp
            	and (news_items_approved.archive_date >= sysdate/*current_timestamp*/ or news_items_approved.archive_date is null)
             	and news_items_approved.creation_user= :oneUser
            order by news_items_approved.publish_date desc,
                     news_items_approved.publish_title
       </querytext>
    </fullquery>


    <fullquery name="select_non_active_news_by_user">
        <querytext>
            select news_items_approved.package_id,
                   acs_object.name(apm_package.parent_id(news_items_approved.package_id)) as parent_name,
                   (select site_node.url(site_nodes.node_id)
                    from site_nodes
                    where site_nodes.object_id = news_items_approved.package_id) as url,
                   news_items_approved.item_id,
                   news_items_approved.publish_title,
                   to_char(news_items_approved.publish_date, 'YYYY-MM-DD HH24:MI:SS') as publish_date_ansi
            from news_items_approved
            where (news_items_approved.publish_date >= sysdate --current_timestamp
            	or news_items_approved.archive_date < sysdate /*current_timestamp*/)
             	and news_items_approved.creation_user= :oneUser
            order by news_items_approved.publish_date desc,
                     news_items_approved.publish_title
        </querytext>
    </fullquery>

    <fullquery name="select_active_news_by_com">
        <querytext>
            select distinct news.package_id,
                   acs_object.name(apm_package.parent_id(news.package_id)) as parent_name,
                   (select site_node.url(site_nodes.node_id)
                    from site_nodes
                    where site_nodes.object_id = news.package_id) as url,
                   news.item_id,
                   news.publish_title,
                   to_char(news.publish_date, 'YYYY-MM-DD HH24:MI:SS') as publish_date_ansi
            from news_items_approved news, dotlrn_communities com
            where news.publish_date < sysdate--current_timestamp
            	and (news.archive_date >= sysdate /*current_timestamp*/ or news.archive_date is null)
             	and com.community_id= :oneCom
            	and apm_package.parent_id(news.package_id) = com.package_id
            order by publish_date_ansi desc,
                     news.publish_title
       </querytext>
    </fullquery>


    <fullquery name="select_non_active_news_by_com">
        <querytext>
            select distinct news.package_id,
                   acs_object.name(apm_package.parent_id(news.package_id)) as parent_name,
                   (select site_node.url(site_nodes.node_id)
                    from site_nodes
                    where site_nodes.object_id = news.package_id) as url,
                   news.item_id,
                   news.publish_title,
                   to_char(news.publish_date, 'YYYY-MM-DD HH24:MI:SS') as publish_date_ansi
            from news_items_approved news, dotlrn_communities com
            where (news.publish_date >= sysdate --current_timestamp
            	or news.archive_date < sysdate /*current_timestamp*/)
             	and com.community_id= :oneCom
            	and apm_package.parent_id(news.package_id) = com.package_id
            order by publish_date_ansi desc,
                     news.publish_title
        </querytext>
    </fullquery>

    <fullquery name="select_site_active_news">
        <querytext>
            select distinct news.package_id,
                   acs_object.name(apm_package.parent_id(news.package_id)) as parent_name,
                   (select site_node.url(site_nodes.node_id)
                    from site_nodes
                    where site_nodes.object_id = news.package_id) as url,
                   news.item_id,
                   news.publish_title,
                   to_char(news.publish_date, 'YYYY-MM-DD HH24:MI:SS') as publish_date_ansi
            from news_items_approved news
            where news.publish_date < sysdate --current_timestamp
            	and (news.archive_date >= sysdate /*current_timestamp*/ or news.archive_date is null)
            order by publish_date_ansi desc,
                     news.publish_title
       </querytext>
    </fullquery>


    <fullquery name="select_site_non_active_news">
        <querytext>
            select distinct news.package_id,
                   acs_object.name(apm_package.parent_id(news.package_id)) as parent_name,
                   (select site_node.url(site_nodes.node_id)
                    from site_nodes
                    where site_nodes.object_id = news.package_id) as url,
                   news.item_id,
                   news.publish_title,
                   to_char(news.publish_date, 'YYYY-MM-DD HH24:MI:SS') as publish_date_ansi
            from news_items_approved news
            where (news.publish_date >= sysdate --current_timestamp
            	or news.archive_date < sysdate /*current_timestamp*/)
            order by publish_date_ansi desc,
                     news.publish_title
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