<?xml version="1.0"?>

<queryset>

    <fullquery name="select_surveys">
        <querytext>
		select s.name, s.package_id,
		(select site_node__url(site_nodes.node_id)
	                    from site_nodes, acs_objects
	                    where site_nodes.object_id = acs_objects.context_id and acs_objects.object_id= :survey_id) as url
  		from surveys s
  		where s.survey_id = :survey_id
 	</querytext>
    </fullquery>
    
</queryset>