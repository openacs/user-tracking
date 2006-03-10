<?xml version="1.0"?>

<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="select_survey">
        <querytext>
		select s.survey_id, s.name, s.editable_p, s.single_response_p,
			sr.response_id, to_char(sr.creation_date, 'YYYY-MM-DD HH24:MI:SS') as creation_date,
			s.package_id
  		from surveys s, survey_responses_latest sr,
  			dotlrn_communities com
 		where s.enabled_p='t'
 		      and s.survey_id = sr.survey_id
 		      and sr.initial_user_id= :oneUser
 		      and com.community_id= :oneCom
	              and apm_package.parent_id(s.package_id) = com.package_id
 		order by upper(s.name)
 	</querytext>
    </fullquery>

    <fullquery name="select_survey_by_user">
        <querytext>
		select s.survey_id, s.name, s.editable_p, s.single_response_p,
			sr.response_id, to_char(sr.creation_date, 'YYYY-MM-DD HH24:MI:SS') as creation_date,
			s.package_id
  		from surveys s, survey_responses_latest sr
 		where s.enabled_p='t'
 		      and s.survey_id = sr.survey_id
 		      and sr.initial_user_id= :oneUser
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
 		      and com.community_id= :oneCom
	              and apm_package.parent_id(s.package_id) = com.package_id
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
                   to_char(creation_date, 'YYYY-MM-DD HH24:MI:SS') as registration_date,
                   to_char(last_visit, 'YYYY-MM-DD HH24:MI:SS') as last_visit
            from cc_users
            where user_id = :oneUser
        </querytext>
    </fullquery>

    <fullquery name="select_com_data">
        <querytext>
	   select f.community_key as key,
			f.community_id as id,
			f.pretty_name as pretty_name,
			to_char(o.creation_date, 'YYYY-MM-DD HH24:MI:SS') as creation_date
		from dotlrn_communities_full f, acs_objects o
		where f.community_id= :oneCom
		      and o.object_id= f.community_id
        </querytext>
    </fullquery>
  
</queryset>