
<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

[<small>
  <small>#user-tracking.lt_Site_Stats#</small>
  |
  <a href="communities-stats"><small>#user-tracking.lt_Communities_Stats#</small></a>
  |
  <a href="users-stats"><small>#user-tracking.lt_Users_Stats#</small></a>
  |
  <a href="advanced-stats"><small>#user-tracking.lt_Advanced_Stats_1#</small></a>
</small>]

<p></p>
<p></p>

<h3>#user-tracking.lt_Site_Stats#</h3>

<ul>
  <li> #user-tracking.ut_Number_Of_Users_1# <a href="registration-history">#user-tracking.ut_See_Register_Historic#</a></li>
  <if @NofUsers@ gt 0>
  	<ul> <li>#user-tracking.ut_Are_Students#</li></ul>
  </if>
  <if @NofAdmin@ gt 0>
	<ul> <li>#user-tracking.ut_Are_Admin#</li></ul>
  </if>

  <if @LastRegistration@ gt 0>
	  <li> #user-tracking.ut_Last_Register#</li>
  </if>
  <if @LastVisit@ gt 0>
	  <li> #user-tracking.ut_Last_View#</li>
  </if>
  <if @TotalVisits@ gt 0>
	  <li> #user-tracking.ut_Total_of_Sessiones#</li>
  </if>
  
  <li> #user-tracking.ut_Number_Of_Communities# </li>
  <li> #user-tracking.ut_Number_Of_Classes#</li>

  <if @NofForums@ gt 0>
	  <li> #user-tracking.ut_Number_Of_Forums# <a href="forums-card">#user-tracking.Ver_Forosut_See_Forums#</a></li>
  </if>
  <if @NofFaqs@ gt 0>
	  <li> #user-tracking.ut_Number_Of_FAQS# <a href="faq-card">#user-tracking.ut_See_FAQS#</a></li>
  </if>
  <if @NofNews@ gt 0>
	  <li> #user-tracking.ut_Number_Of_News# <a href="news-card">#user-tracking.ut_See_News#</a></li>
  </if>
  <if @NofSurveys@ gt 0>
	  <li> #user-tracking.ut_Number_Of_Surveys# <a href="survey-card">#user-tracking.Ver_Surveys#</a></li>
  </if>
  
  <li> <a href="lanza?config=site">#user-tracking.ut_See_System_Stats#</a> </li>
 </p>
</ul>



