<ul>
  	<li> <a href="visits/dayweek?DataFileName=@DataFileName@&user_id=@user_id@&community_id=@community_id@">#user-tracking.visits_by_weekday#</a></li>
  	<li> <a href="visits/daymonth?DataFileName=@DataFileName@&user_id=@user_id@&community_id=@community_id@">#user-tracking.visits_by_monthday#</a></li>
  	<li> <a href="visits/hourly?DataFileName=@DataFileName@&user_id=@user_id@&community_id=@community_id@">#user-tracking.visits_by_hour#</a></li>
  	<li> <a href="visits/duration?DataFileName=@DataFileName@&user_id=@user_id@&community_id=@community_id@">#user-tracking.visits_duration#</a></li>
  	<li> <a href="visits/users-report?DataFileName=@DataFileName@&user_id=@user_id@&community_id=@community_id@">#user-tracking.users_visits#</a></li>
  	<li> <a href="visits/ip-report?DataFileName=@DataFileName@&user_id=@user_id@&community_id=@community_id@">#user-tracking.ips_visits#</a></li>
  	<if @admin_p@ eq 1><li> <a href="visits/hits?DataFileName=@DataFileName@&user_id=@user_id@&community_id=@community_id@">#user-tracking.most_of_hits#</a></li></if>
</ul>
