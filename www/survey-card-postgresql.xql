?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="select_survey">
        <querytext>
		select s.survey_id, s.name, s.editable_p, s.single_response_p,
			sr.response_id, to_char(sr.creation_date, 'YYYY-MM-DD HH24:MI:SS') as creation_date,
			s.package_id
  		from surveys s, survey_responses_latest sr
 		where s.enabled_p='t'
 		      and s.survey_id = sr.survey_id
 		      and sr.initial_user_id= :user_id
 		order by upper(s.name)
 	</querytext>
    </fullquery>

    <fullquery name="select_survey_by_com">
        <querytext>
		select s.survey_id, s.name, s.editable_p, s.single_response_p,
			to_char(o.creation_date, 'YYYY-MM-DD HH24:MI:SS') as creation_date,
			s.package_id
  		from surveys s, dotlrn_communities com, acs_objects o
 		where s.enabled_p='t'
	              and o.object_id=s.survey_id 		
 		      and com.community_id= 3461
	              and apm_package__parent_id(s.package_id) = com.package_id
 		order by upper(s.name)
 	</querytext>
    </fullquery>

    <fullquery name="select_site_surveys">
        <querytext>
		select s.survey_id, s.name, s.editable_p, s.single_response_p,
			to_char(o.creation_date, 'YYYY-MM-DD HH24:MI:SS') as creation_date,
			s.package_id
  		from surveys s, acs_objects o
 		where s.enabled_p='t'
	              and o.object_id=s.survey_id
 		order by upper(s.name)
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