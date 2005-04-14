<?xml version="1.0"?>

<queryset>


<fullquery name="user-tracking::process_sessions.write_to_db">
	
	<querytext>
	insert into ut_sessions (
	session_id,
	user_id,
	init_date,
	finish_date,
	ip
	) values ( 
	:session_id, 
	:user_id, 
	:init_date,
	:finish_date,
	:ip
	)

	</querytext>
</fullquery>

<fullquery name="user-tracking::launch_process.insert_scheduled_process_id">
	<querytext>
		insert into ut_sched values (:id)
	</querytext>
</fullquery>

<fullquery name="user-tracking::launch_process.delete_scheduled_processes">
	<querytext>
		delete from ut_sched;
	</querytext>
</fullquery>
</queryset>