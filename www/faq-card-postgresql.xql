<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="select_faqs">
        <querytext>
		select ans.question as question,
			ans.entry_id as entry_id,
			f.faq_id as faq_id,
			f.faq_name as faq_name, 
			(select site_node__url(site_nodes.node_id)
	                    from site_nodes, acs_objects
	                    where site_nodes.object_id = acs_objects.context_id and acs_objects.object_id=f.faq_id) as url,
	                to_char(o.creation_date, 'YYYY-MM-DD HH24:MI:SS') as creation_date
		    from faq_q_and_as ans, faqs f, acs_objects o
		    where o.object_id=ans.entry_id
			and ans.faq_id=f.faq_id
			and o.creation_user= :user_id
	</querytext>
    </fullquery>

    <fullquery name="select_faqs_by_com">
        <querytext>
		select f.faq_name as faq_name, 
			f.faq_id as faq_id,
			(select site_node__url(site_nodes.node_id)
	                    from site_nodes, acs_objects
	                    where site_nodes.object_id = acs_objects.context_id and acs_objects.object_id=f.faq_id) as url,
	                to_char(o.creation_date, 'YYYY-MM-DD HH24:MI:SS') as creation_date
		    from faqs f, acs_objects o, dotlrn_communities com
		    where o.object_id=f.faq_id
			and com.community_id= :community_id
			and apm_package__parent_id(o.context_id) = com.package_id
	</querytext>
    </fullquery>

    <fullquery name="select_site_faqs">
        <querytext>
		select f.faq_name as faq_name, 
			f.faq_id as faq_id,
			(select site_node__url(site_nodes.node_id)
	                    from site_nodes, acs_objects
	                    where site_nodes.object_id = acs_objects.context_id and acs_objects.object_id=f.faq_id) as url,
	                to_char(o.creation_date, 'YYYY-MM-DD HH24:MI:SS') as creation_date
		    from faqs f, acs_objects o
		    where o.object_id=f.faq_id
	</querytext>
    </fullquery>

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

    <fullquery name="select_com_data">
        <querytext>
           select distinct h.pretty_name as first_names
		from dotlrn_communities h
		where h.community_id= :community_id
        </querytext>
    </fullquery>
    

</queryset>
