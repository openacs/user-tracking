<?xml version="1.0"?>

<queryset>

<fullquery name="get_scheduled_processes">
	<querytext>
		select process_id
		from ut_sched
	</querytext>
</fullquery>

<fullquery name="insert_scheduled_process_id">
	<querytext>
		insert into ut_sched values (:id)
	</querytext>
</fullquery>

<fullquery name="delete_scheduled_process">
	<querytext>
		delete from ut_sched where process_id = :process_id
	</querytext>
</fullquery>

</queryset>