<?xml version="1.0"?>

<queryset>
 
    <fullquery name="select_class_data">
        <querytext>
	   select f.community_key as key,
			f.community_id as id,
			f.pretty_name as name,
			to_char(o.creation_date, 'YYYY-MM-DD HH24:MI:SS') as creation_date
		from dotlrn_classes c, dotlrn_communities_full f, acs_objects o
		where f.community_type = c.class_key
		      and f.community_id= :community_id
		      and o.object_id= :community_id
        </querytext>
    </fullquery>

    <fullquery name="select_club_data">
        <querytext>
           select distinct h.community_key as key,
			h.community_id as id,
			h.pretty_name as name,
			h.parent_community_id as parent_id,
			to_char(o.creation_date, 'YYYY-MM-DD HH24:MI:SS') as creation_date
		from dotlrn_communities h, dotlrn_clubs c, acs_objects o
		where h.community_id= c.club_id
			and h.community_id= :community_id
			and o.object_id= :community_id
        </querytext>
    </fullquery>

    <fullquery name="select_com_data">
        <querytext>
           select distinct h.community_key as key,
			h.community_id as id,
			h.pretty_name as name,
			h.parent_community_id as parent_id,
			to_char(o.creation_date, 'YYYY-MM-DD HH24:MI:SS') as creation_date
		from dotlrn_communities h, acs_objects o
		where h.community_id= :community_id
			and o.object_id= :community_id
        </querytext>
    </fullquery>

    <fullquery name="select_subgroup_count">
        <querytext>
		select count(distinct community_id)
			from dotlrn_communities 
			where parent_community_id= :community_id
        </querytext>
    </fullquery>

    <fullquery name="select_members_count">
        <querytext>
		select count (*) 
			from acs_rels 
			where acs_rels.object_id_one= :community_id
	</querytext>
    </fullquery>

    <fullquery name="select_members_count_by_type">
        <querytext>
		select count (*) 
			from acs_rels 
			where acs_rels.object_id_one= :community_id
				and acs_rels.rel_type in ('[join $rels "\', \'"]')
	</querytext>
    </fullquery>

</queryset>
