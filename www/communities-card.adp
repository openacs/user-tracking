
<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

[<small>
  <a href="site-card"><small>#user-tracking.lt_Site_Stats#</small></a>
  |
  <a href="communities-stats"><small>#user-tracking.lt_Communities_Stats#</small></a>
  |
  <a href="users-stats"><small>#user-tracking.lt_Users_Stats#</small></a>
  |
  <a href="advanced-stats"><small>#user-tracking.lt_Advanced_Stats_1#</small></a>
</small>]

<p></p>
<p></p>

<h3>#user-tracking.ut_Community_Stats#</h3>

<ul>
  <li> #user-tracking.ut_Name#</li>

<if @type@ eq 2>
  <li> #user-tracking.ut_Type_Course#</li>
  <if @NofMembers@ gt 0>
  	<li> #user-tracking.ut_Number_Of_Members#</li>
  </if>
  <if @NofUsers@ gt 0>
  	<li> #user-tracking.ut_Number_Of_Students#</li>
  </if>
  <if @NofAdmin@ gt 0>
	<li> #user-tracking.ut_Number_Of_Proffesors#</li>
  </if>
</if>

<else> 
  <li> #user-tracking.ut_Type_Club#</li>
  <if @NofMembers@ gt 0>
  	<li> #user-tracking.ut_Number_Of_Members#</li>
  </if>
  <if @NofUsers@ gt 0>
  	<li> #user-tracking.ut_Number_Of_Users#</li>
  </if>
  <if @NofAdmin@ gt 0>
	<li> #user-tracking.ut_Number_Of_Admins#</li>
  </if>
</else>

  <if @NofSub@ gt 0>
	  <li> #user-tracking.ut_Number_Of_Sub# </li>
  </if>
  <li> #user-tracking.ut_Creation_Date# </li>  
  <if @NofForums@ gt 0>
	  <li> #user-tracking.ut_Number_Of_Forums# <a href="forums-card?community_id=@id@">#user-tracking.ut_See_Forums#</a></li>
  </if>
  <if @NofFaqs@ gt 0>
	  <li> #user-tracking.ut_Number_Of_FAQS# <a href="faq-card?community_id=@id@">#user-tracking.ut_See_FAQS#</a></li>
  </if>
  <if @NofNews@ gt 0>
	  <li> #user-tracking.ut_Number_Of_News# <a href="news-card?community_id=@id@">#user-tracking.ut_See_News#</a></li>
  </if>
  <if @NofSurveys@ gt 0>
	  <li> #user-tracking.ut_Number_Of_Surveys# <a href="survey-card?community_id=@id@">#user-tracking.ut_See_Surveys#</a></li>
  </if>

  <li> <a href="lanza?config=site&community_id=@id@&sitedomain=@name@">#user-tracking.ut_See_Community_Stats#</a> </li>
  <% set temp [user-tracking::select_children_communities @id@] %>
  <if @temp@ ne @id@>
  	<li> <a href="lanza?config=site&community_id=@temp@&sitedomain=@name@">#user-tracking.ut_See_Subgroups_Com_Stats#</a> </li>
  </if>
 </p>
</ul>


