<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="select_active_news">
        <querytext>
            select news_items_approved.package_id,
                   acs_object__name(apm_package__parent_id(news_items_approved.package_id)) as parent_name,
                   (select site_node__url(site_nodes.node_id)
                    from site_nodes
                    where site_nodes.object_id = news_items_approved.package_id) as url,
                   news_items_approved.item_id,
                   news_items_approved.publish_title,
                   to_char(news_items_approved.publish_date, 'YYYY-MM-DD HH24:MI:SS') as publish_date_ansi
            from news_items_approved
            where news_items_approved.publish_date < current_timestamp
            	and (news_items_approved.archive_date >= current_timestamp or news_items_approved.archive_date is null)
             	and news_items_approved.creation_user= :user_id
            order by news_items_approved.publish_date desc,
                     news_items_approved.publish_title
       </querytext>
    </fullquery>


    <fullquery name="select_non_active_news">
        <querytext>
            select news_items_approved.package_id,
                   acs_object__name(apm_package__parent_id(news_items_approved.package_id)) as parent_name,
                   (select site_node__url(site_nodes.node_id)
                    from site_nodes
                    where site_nodes.object_id = news_items_approved.package_id) as url,
                   news_items_approved.item_id,
                   news_items_approved.publish_title,
                   to_char(news_items_approved.publish_date, 'YYYY-MM-DD HH24:MI:SS') as publish_date_ansi
            from news_items_approved
            where (news_items_approved.publish_date >= current_timestamp
            	or news_items_approved.archive_date < current_timestamp)
             	and news_items_approved.creation_user= :user_id
            order by news_items_approved.publish_date desc,
                     news_items_approved.publish_title
        </querytext>
    </fullquery>

    <fullquery name="select_active_news_by_com">
        <querytext>
            select distinct news.package_id,
                   acs_object__name(apm_package__parent_id(news.package_id)) as parent_name,
                   (select site_node__url(site_nodes.node_id)
                    from site_nodes
                    where site_nodes.object_id = news.package_id) as url,
                   news.item_id,
                   news.publish_title,
                   to_char(news.publish_date, 'YYYY-MM-DD HH24:MI:SS') as publish_date_ansi
            from news_items_approved news, dotlrn_communities com
            where news.publish_date < current_timestamp
            	and (news.archive_date >= current_timestamp or news.archive_date is null)
             	and com.community_id= :community_id
            	and apm_package__parent_id(news.package_id) = com.package_id
            order by publish_date_ansi desc,
                     news.publish_title
       </querytext>
    </fullquery>


    <fullquery name="select_non_active_news_by_com">
        <querytext>
            select distinct news.package_id,
                   acs_object__name(apm_package__parent_id(news.package_id)) as parent_name,
                   (select site_node__url(site_nodes.node_id)
                    from site_nodes
                    where site_nodes.object_id = news.package_id) as url,
                   news.item_id,
                   news.publish_title,
                   to_char(news.publish_date, 'YYYY-MM-DD HH24:MI:SS') as publish_date_ansi
            from news_items_approved news, dotlrn_communities com
            where (news.publish_date >= current_timestamp
            	or news.archive_date < current_timestamp)
             	and com.community_id= :community_id
            	and apm_package__parent_id(news.package_id) = com.package_id
            order by publish_date_ansi desc,
                     news.publish_title
        </querytext>
    </fullquery>

    <fullquery name="select_site_active_news">
        <querytext>
            select distinct news.package_id,
                   acs_object__name(apm_package__parent_id(news.package_id)) as parent_name,
                   (select site_node__url(site_nodes.node_id)
                    from site_nodes
                    where site_nodes.object_id = news.package_id) as url,
                   news.item_id,
                   news.publish_title,
                   to_char(news.publish_date, 'YYYY-MM-DD HH24:MI:SS') as publish_date_ansi
            from news_items_approved news
            where news.publish_date < current_timestamp
            	and (news.archive_date >= current_timestamp or news.archive_date is null)
            order by publish_date_ansi desc,
                     news.publish_title
       </querytext>
    </fullquery>


    <fullquery name="select_site_non_active_news">
        <querytext>
            select distinct news.package_id,
                   acs_object__name(apm_package__parent_id(news.package_id)) as parent_name,
                   (select site_node__url(site_nodes.node_id)
                    from site_nodes
                    where site_nodes.object_id = news.package_id) as url,
                   news.item_id,
                   news.publish_title,
                   to_char(news.publish_date, 'YYYY-MM-DD HH24:MI:SS') as publish_date_ansi
            from news_items_approved news
            where (news.publish_date >= current_timestamp
            	or news.archive_date < current_timestamp)
            order by publish_date_ansi desc,
                     news.publish_title
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

    <fullquery name="select_total_posts">
        <querytext>
            select count(*)
            from acs_objects  
            where creation_user = :user_id 
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