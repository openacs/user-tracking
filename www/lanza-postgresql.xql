<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="select_instructor_from">
        <querytext>
		select * 
		from acs_rels 
		where object_id_one = :community_id and
			(rel_type = 'dotlrn_instructor_rel' or
			 rel_type = 'dotlrn_professor_profile_rel')
        </querytext>
    </fullquery>

    <fullquery name="select_admin_from">
        <querytext>
		select object_id_two
		from acs_rels 
		where object_id_one = :community_id and
			(rel_type = 'dotlrn_admin_rel' or
			 rel_type = 'dotlrn_admin_profile_rel' or
			 rel_type = 'dotlrn_cadmin_rel')			
        </querytext>
    </fullquery>
    <fullquery name="select_admin">
        <querytext>
		select *
		from dotlrn_users
		where user_id = :user_id and
			type = 'admin'
        </querytext>
    </fullquery>

</queryset>
