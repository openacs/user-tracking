<?xml version="1.0"?>

<queryset>
  <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="select_dotlrn_users">
        <querytext>
            select dotlrn_users.user_id,
                   dotlrn_users.first_names,
                   dotlrn_users.last_name,
                   dotlrn_users.email,
                   dotlrn_privacy__guest_p(dotlrn_users.user_id) as guest_p,
                   acs_permission__permission_p(:root_object_id,dotlrn_users.user_id, 'admin') as site_wide_admin_p
            from dotlrn_users 
            order by dotlrn_users.last_name
        </querytext>
    </fullquery>
</queryset>
