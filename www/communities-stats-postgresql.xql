<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="select_dotlrn_clubs_count">
        <querytext>
		select count(distinct h.community_key)
		from dotlrn_communities h, dotlrn_clubs c
		where h.parent_community_id is not null
			or c.club_id = h.community_id       
        </querytext>
    </fullquery>

    <fullquery name="select_dotlrn_classes_count">
        <querytext>
            select count(distinct dotlrn_communities_full.community_id)		
		from dotlrn_classes, dotlrn_communities_full
		where dotlrn_communities_full.community_type = dotlrn_classes.class_key
        </querytext>
    </fullquery>

</queryset>
