<?xml version="1.0"?>

<queryset>
  <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="select_dotlrn_clubs">
        <querytext>
            select distinct h.community_key,
			h.community_id,
			h.pretty_name,
			h.parent_community_id
		from dotlrn_communities h, dotlrn_clubs c
		where h.parent_community_id is not null
			or c.club_id = h.community_id
            	order by h.pretty_name
        </querytext>
    </fullquery>

    <fullquery name="select_dotlrn_classes">
        <querytext>
		select dotlrn_communities_full.community_key,
			dotlrn_communities_full.community_id,
			dotlrn_communities_full.pretty_name
		from dotlrn_classes, dotlrn_communities_full
		where dotlrn_communities_full.community_type = dotlrn_classes.class_key
		order by dotlrn_communities_full.pretty_name
	</querytext>
    </fullquery>

    <fullquery name="select_dotlrn_communities">
        <querytext>
             select dotlrn_communities.community_key,
             	   dotlrn_communities.community_id,
                   dotlrn_communities.pretty_name                   
            from dotlrn_communities             
            order by dotlrn_communities.pretty_name
        </querytext>
    </fullquery>
</queryset>
