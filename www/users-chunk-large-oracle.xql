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
            where (
                lower(dotlrn_users.last_name) like lower('%' || :search_text || '%')
             or lower(dotlrn_users.first_names) like lower('%' || :search_text || '%')
             or lower(dotlrn_users.email) like lower('%' || :search_text || '%')
            )
            order by dotlrn_users.last_name
        </querytext>
    </fullquery>
</queryset>
