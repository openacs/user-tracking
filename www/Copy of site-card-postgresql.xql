<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>


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
    
    <fullquery name="select_users_count">
        <querytext>
            select count (*)                   
            from dotlrn_users             
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

    <fullquery name="select_portrait_info">      
        <querytext>
            select cr_items.live_revision as revision_id,
                   coalesce(cr_revisions.title, 'view this portrait') as portrait_title
            from acs_rels,
                 cr_items,
                 cr_revisions
            where acs_rels.object_id_two = cr_items.item_id
            and cr_items.live_revision = cr_revisions.revision_id
            and acs_rels.object_id_one = :user_id
            and acs_rels.rel_type = 'user_portrait_rel'
        </querytext>
    </fullquery>

    <fullquery name="select_member_classes">
        <querytext>
            select dotlrn_class_instances_full.*,
                   dotlrn_member_rels_approved.rel_type,
                   dotlrn_member_rels_approved.role,
                   '' as role_pretty_name
            from dotlrn_class_instances_full,
                 dotlrn_member_rels_approved
            where dotlrn_member_rels_approved.user_id = :user_id
            and dotlrn_member_rels_approved.community_id = dotlrn_class_instances_full.class_instance_id
            order by dotlrn_class_instances_full.department_name,
                     dotlrn_class_instances_full.department_key,
                     dotlrn_class_instances_full.pretty_name,
                     dotlrn_class_instances_full.community_key
        </querytext>
    </fullquery>

    <fullquery name="select_member_clubs">
        <querytext>
            select dotlrn_clubs_full.*,
                   dotlrn_member_rels_approved.rel_type,
                   dotlrn_member_rels_approved.role,
                   '' as role_pretty_name
            from dotlrn_clubs_full,
                 dotlrn_member_rels_approved
            where dotlrn_member_rels_approved.user_id = :user_id
            and dotlrn_member_rels_approved.community_id = dotlrn_clubs_full.club_id
            order by dotlrn_clubs_full.pretty_name,
                     dotlrn_clubs_full.community_key
        </querytext>
    </fullquery>

    <fullquery name="select_member_subgroups">
        <querytext>
            select dotlrn_communities.*,
                   dotlrn_community__url(dotlrn_communities.community_id) as url,
                   dotlrn_member_rels_approved.rel_type,
                   dotlrn_member_rels_approved.role,
                   '' as role_pretty_name
            from dotlrn_communities,
                 dotlrn_member_rels_approved
            where dotlrn_member_rels_approved.user_id = :user_id
            and dotlrn_member_rels_approved.community_id = dotlrn_communities.community_id
            and dotlrn_communities.community_type = 'dotlrn_community'
            order by dotlrn_communities.pretty_name,
                     dotlrn_communities.community_key
        </querytext>
    </fullquery>
    <fullquery name="select_subgroup_count">
        <querytext>
		select count(distinct community_id)
			from dotlrn_communities 
			where parent_community_id= :community_id
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
    
    <fullquery name="select_forums_count">
        <querytext>
    	    select count(distinct forums.forum_id)
            	from forums_forums_enabled forums   		
        </querytext>
    </fullquery>
    
    <fullquery name="select_faqs_count">
        <querytext>
    	    select count(distinct f.faq_id)
                from faqs f
        </querytext>
    </fullquery>

    <fullquery name="select_news_count">
        <querytext>
            select count(distinct n.item_id)
            	from news_items_approved n
        </querytext>
    </fullquery>

    <fullquery name="select_surveys_count">
        <querytext>
           select count(distinct s.survey_id)
            	from surveys s
        </querytext>
    </fullquery>

</queryset>
