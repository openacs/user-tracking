<?xml version="1.0"?>

<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="select_dotlrn_clubs">
        <querytext>
            select distinct h.community_key,
			h.community_id,
			h.pretty_name,
			h.parent_community_id
		from dotlrn_communities h, dotlrn_clubs c
		where (h.parent_community_id is not null
			or c.club_id = h.community_id)
		        and (
		                lower(h.pretty_name) like lower('%' || :search_text || '%')
				or lower(h.community_key) like lower('%' || :search_text || '%')             			
            		)
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
		            and (
		                lower(dotlrn_communities_full.pretty_name) like lower('%' || :search_text || '%')
				or lower(dotlrn_communities_full.community_key) like lower('%' || :search_text || '%')             			
            		    )
		order by dotlrn_communities_full.pretty_name
	</querytext>
    </fullquery>

</queryset>
