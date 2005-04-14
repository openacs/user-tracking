<?xml version="1.0"?>

<queryset>

    <fullquery name="select_n_users">
        <querytext>
          select count(u.user_id) as n_users,
                 to_char(max(creation_date), 'YYYY-MM-DD HH24:MI:SS') as last_registration,
                 to_char(max(u.last_visit), 'YYYY-MM-DD HH24:MI:SS') as last_visit,
                 sum(u.n_sessions) as total_visits
          from   users u,
                 acs_objects o
          where  o.object_id = u.user_id
            	and  user_id <> 0
        </querytext>
    </fullquery>
    
    <fullquery name="select_clubs_count">
        <querytext>
            select count (*)                   
		from dotlrn_communities h, dotlrn_clubs c
		where h.parent_community_id is not null
			or c.club_id = h.community_id
        </querytext>
    </fullquery>

    <fullquery name="select_classes_count">
        <querytext>
            select count (*)                   
		from dotlrn_classes, dotlrn_communities_full
		where dotlrn_communities_full.community_type = dotlrn_classes.class_key
        </querytext>
    </fullquery>


    <fullquery name="select_members_count_by_type">
        <querytext>
		select count (distinct acs_rels.object_id_two) 
			from acs_rels, dotlrn_users
			where acs_rels.rel_type in ('[join $rels "\', \'"]')
				and dotlrn_users.user_id=acs_rels.object_id_two
	</querytext>
    </fullquery>
</queryset>
