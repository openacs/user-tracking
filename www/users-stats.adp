

<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<% set referer "[user-tracking::get_package_url]/users-stats" %>

[<small>
  <a href="/user-tracking/awstats/cgi-bin/lanza?config=site"><small>#user-tracking.lt_Site_Stats#</small></a>
  |
  <a href="communities-stats"><small>#user-tracking.lt_Communities_Stats_2#</small></a>
  |
  <small>#user-tracking.lt_Users_Stats#</small>
  |
  <a href="advanced-stats"><small>#user-tracking.lt_Advanced_Stats_1#</small></a>
</small>]
<p></p>
<p></p>

<if @n_users@ gt 500>
  <include src="users-chunk-large" referer="@referer@">
</if>
<else>
  <if @n_users@ gt 50>
    <include src="users-chunk-medium" referer="@referer@">
  </if>
  <else>
    <include src="users-chunk-small" referer="@referer@">
  </else>
</else>

