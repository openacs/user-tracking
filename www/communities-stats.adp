
<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<% set referer "[user-tracking::get_package_url]/communities-stats" %>

[<small>
  <a href="site-card"><small>#user-tracking.lt_Site_Stats#</small></a>
  |
  <small>#user-tracking.lt_Communities_Stats#</small>
  |
  <a href="users-stats"><small>#user-tracking.lt_Users_Stats#</small></a>
  |
  <a href="advanced-stats"><small>#user-tracking.lt_Advanced_Stats#</small></a>
</small>]

<p></p>

<p></p>

	<p>@control_bar;noquote@</p>


<if @n_communities@ gt 500>
  <include src="communities-chunk-large" type=@type@ referer="@referer@?type=@type@">
</if>
<else>
  <if @n_communities@ gt 50>
    <include src="communities-chunk-medium" type=@type@ referer="@referer@?type=@type@">
  </if>
  <else>
    <include src="communities-chunk-small" type=@type@ referer="@referer@?type=@type@">
  </else>
</else>

