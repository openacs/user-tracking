
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

<h3>#dotlrn.General_Information#</h3>

<ul>
  <li> #dotlrn.Person_name#: @first_names@ @last_name@ </li>
  <li> #dotlrn.Email#: <a href="mailto:@email@">@email@</a> </li>
  <li> #dotlrn.Screen_name#: @screen_name@ </li>
  <li> #dotlrn.User_ID#: @user_id@  </li>
  <li> #dotlrn.Registration_date# @registration_date@ </li>
  <if @last_visit@ not nil>
    <li> #dotlrn.Last_Visit#: @last_visit@ </li>
  </if>
  <li> <a href="lanza?config=user&user_id=@user_id@&sitedomain=@last_name@, @first_names@">#user-tracking.lt_View_Stats#</a> </li>
 </p>

</ul>


<if @member_classes:rowcount@ gt 0>
  <blockquote>
    <h3>#dotlrn.class_memberships#</h3>
    <ul>
    <multiple name="member_classes">
      <li>
        <a href="@member_classes.url@">@member_classes.pretty_name@</a>
        @member_classes.term_name@ @member_classes.term_year@
        (@member_classes.role_pretty_name@)
      </li>
     </multiple>
     </ul>
  </blockquote>
</if>

<if @member_clubs:rowcount@ gt 0>
  <blockquote>
    <h3>#dotlrn.community_memberships#</h3>
    <ul>
    <multiple name="member_clubs">
      <li>
        <a href="@member_clubs.url@">@member_clubs.pretty_name@</a>
        (@member_clubs.role_pretty_name@)
      </li>
    </multiple>
    </ul>
  </blockquote>
</if>

<if @member_subgroups:rowcount@ gt 0>
  <blockquote>
    <h3>#dotlrn.subcommunity_memberships#</h3>
    <ul>
    <multiple name="member_subgroups">
      <li>
        <a href="@member_subgroups.url@">@member_subgroups.pretty_name@</a>
        (@member_subgroups.role_pretty_name@)
      </li>
    </multiple>
    </ul>
  </blockquote>
</if>

<if @total_posted@ gt 0>
  <blockquote>
    <h3>#user-tracking.ut_User_has_Added# @total_posted@ #user-tracking.ut_Site_objects#</h3>
    <ul>
	<if @faq_posted@ gt 0>
	  <li> #user-tracking.ut_User_has_posted# @faq_posted@  #user-tracking.ut_FAQS# <a href="faq-card?user_id=@user_id@">#user-tracking.ut_See_FAQS#</a></li>
	</if>
	<if @news_posted@ gt 0>
	  <li>  #user-tracking.ut_User_has_posted# @news_posted@ #user-tracking.ut_News# <a href="news-card?user_id=@user_id@">#user-tracking.ut_See_News#</a></li>	  
	</if>
	<if @surveys_posted@ gt 0>
	  <li>  #user-tracking.ut_User_has_posted# @surveys_posted@ #user-tracking.ut_Surveys# <a href="survey-card?user_id=@user_id@">#user-tracking.ut_See_Surveys#</a></li></li>	  
	</if>
	<if @forum_posted@ gt 0>
	  <li>  #user-tracking.ut_User_has_posted# @forum_posted@ #user-tracking.ut_Forum_messages# <a href="forums-card?user_id=@user_id@">#user-tracking.ut_See_Messages#</a></li>	  
	</if>
	<if @files_posted@ gt 0>
	  <li>  #user-tracking.ut_User_has_posted# @files_posted@ #user-tracking.ut_Files# <a href="files-card?user_id=@user_id@">#user-tracking.ut_See_Files#</a></li>	  
	</if>
    </ul>
  </blockquote>
</if>

