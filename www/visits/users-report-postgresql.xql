<?xml version="1.0"?>

<queryset>

    <fullquery name="select_user_data">
        <querytext>
            select first_names,
                   last_name,
                   last_visit
            from cc_users 
            where user_id= :user_id
        </querytext>
    </fullquery>
</queryset>
