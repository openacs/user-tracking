
<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>


<% 

set referer "[user-tracking::get_package_url]/advanced-stats" %>

[<small>
  <a href="site-card"><small>#user-tracking.lt_Site_Stats#</small></a>
  |
  <a href="communities-stats"><small>#user-tracking.lt_Communities_Stats#</small></a>
  |
  <a href="users-stats"><small>#user-tracking.lt_Users_Stats#</small></a>
  |
  <small>#user-tracking.lt_Advanced_Stats_1#</small>
</small>]

<p></p>
<p>	#user-tracking.lt_Selected_Users#@Users@<BR>
	#user-tracking.lt_Selected_Communities#@Communities@
	
</p>
<p></p>
<p>
	<if @Users@ eq "" and @Communities@ eq "">
		#user-tracking.lt_No_stats#
	</if> <else>
		<if @Users@ eq "">			
			<a href="/user-tracking/advanced-card?onlylines=@Communities@">#user-tracking.lt_View_Comm_Stats#</a>
		</if> <else>
			<if @Communities@ eq "">				
				<a href="/user-tracking/advanced-card?onlyuser=@Users@">#user-tracking.lt_View_Users_Stats#</a>
			</if><else>				
				<a href="/user-tracking/advanced-card?onlylines=@Communities@&onlyuser=@Users@">#user-tracking.lt_View_Advanced_Stats#</a>
			</else>
		</else>
	</else>
	|
	<if @Users@ eq "" and @Communities@ eq "">
		#user-tracking.lt_Delete_Selection#
	</if><else>
		<a href="./advanced-stats">#user-tracking.lt_Delete_Selection#</a>
	</else>
</p>

	<p>@control_bar;noquote@</p>

<if @type_request@ eq user>
	<include src="advanced-users-stats" Users=@Users@ Communities=@Communities@ referer="./advanced-stats">	
</if> <else>
	<include src="advanced-communities-stats" Communities=@Communities@ Users=@Users@ referer="./advanced-stats">
</else>



