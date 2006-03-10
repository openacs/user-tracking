<?xml version="1.0"?>

<queryset>

    <fullquery name="select_faqs">
        <querytext>
		select  f.faq_name as faq_name, 
			(select site_node.url(site_nodes.node_id)
	                    from site_nodes, acs_objects
	                    where site_nodes.object_id = acs_objects.context_id and acs_objects.object_id= :faq_id) as url
		    from faqs f
		    where f.faq_id=:faq_id
	</querytext>
    </fullquery>
    
</queryset>