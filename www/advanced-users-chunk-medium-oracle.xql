<?xml version="1.0"?>

<queryset>
  <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="select_dotlrn_users">
        <querytext>
            select dotlrn_users.user_id,
                   dotlrn_users.first_names,
                   dotlrn_users.last_name,
                   dotlrn_users.email,
                   dotlrn_privacy.guest_p(dotlrn_users.user_id) as guest_p,
                   acs_permission.permission_p(:root_object_id, dotlrn_users.user_id, 'admin') as site_wide_admin_p
            from dotlrn_users
            where upper(substr(dotlrn_users.last_name, 1, 1)) = :section
            order by dotlrn_users.last_name
        </querytext>
    </fullquery>

    <fullquery name="select_dotlrn_users_other">
        <querytext>
            select dotlrn_users.user_id,
                   dotlrn_users.first_names,
                   dotlrn_users.last_name,
                   dotlrn_users.email,
                   dotlrn_privacy.guest_p(dotlrn_users.user_id) as guest_p,
                   acs_permission.permission_p(:root_object_id, dotlrn_users.user_id, 'admin') as site_wide_admin_p
            from dotlrn_users
            where upper(substr(dotlrn_users.last_name, 1, 1)) not in ('[join $dimension_list "\', \'"]')
            order by dotlrn_users.last_name
        </querytext>
    </fullquery>

</queryset>
