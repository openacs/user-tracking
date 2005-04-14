<?xml version="1.0"?>

<queryset>

    <fullquery name="select_forum_data">
        <querytext>
    	    select name as forum_name
            from forums_forums
            where forum_id= :forum_id
        </querytext>
    </fullquery>
</queryset>
