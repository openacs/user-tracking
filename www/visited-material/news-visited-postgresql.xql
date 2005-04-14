<?xml version="1.0"?>

<queryset>

    <fullquery name="select_news">
        <querytext>
            select news_items_approved.package_id,
                   acs_object__name(apm_package__parent_id(news_items_approved.package_id)) as parent_name,
                   (select site_node__url(site_nodes.node_id)
                    from site_nodes
                    where site_nodes.object_id = news_items_approved.package_id) as url,
                   news_items_approved.publish_title,
                   to_char(news_items_approved.publish_date, 'YYYY-MM-DD HH24:MI:SS') as publish_date_ansi
            from news_items_approved
            where news_items_approved.item_id= :item_id
       </querytext>
    </fullquery>
    
</queryset>