<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

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

    <fullquery name="select_total_posts">
        <querytext>
            select count(*)
            from acs_objects  
            where creation_user = :user_id 
        </querytext>
    </fullquery>

    <fullquery name="select_total_posts_by_type">
        <querytext>
            select count(*)
            from acs_objects  
            where creation_user = :user_id 
            	and object_type= :object_type
        </querytext>
    </fullquery>

    <fullquery name="select_faq_count">
        <querytext>
    		select count(ans.question)
    		       from faq_q_and_as ans, faqs f, acs_objects o
    		       where o.object_id=ans.entry_id
    		             and ans.faq_id=f.faq_id
    		             and o.creation_user= :user_id
        </querytext>
    </fullquery>
    <fullquery name="select_news_count">
        <querytext>
            select count(news_items_approved.publish_title)
            from news_items_approved
            where news_items_approved.creation_user= :user_id
         </querytext>
    </fullquery>

    <fullquery name="select_package_exists">
        <querytext>
		select distinct package_key from apm_packages where package_key= :package_key
	</querytext>
    </fullquery>

</queryset>
