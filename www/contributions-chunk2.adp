<if @total_posted@ gt 0>
<ul>
	
	  	<li> #user-tracking.ut_Number_Of_Forums#
	  	<if @NofForums@ gt 0><a href="contributions-cards/forums-card@link@">#user-tracking.Ver_Forosut_See_Forums#</a></if></li>
	  	<li> #user-tracking.ut_Number_Of_FAQS#
	  	<if @NofFaqs@ gt 0><a href="contributions-cards/faq-card@link@">#user-tracking.ut_See_FAQS#</a></if></li>
		<li> #user-tracking.ut_Number_Of_News#
		<if @NofNews@ gt 0><a href="contributions-cards/news-card@link@">#user-tracking.ut_See_News#</a></if></li>
		<li> #user-tracking.ut_Number_Of_Surveys#
		<if @NofSurveys@ gt 0><a href="contributions-cards/survey-card@link@">#user-tracking.Ver_Surveys#</a></if></li>
		<li>  #user-tracking.ut_Number_Of_Mesagges# @NofMessages@
		<if @NofMessages@ gt 0><a href="contributions-cards/messages-card@link@">#user-tracking.ut_See_Messages#</a></if></li>
		<li>  #user-tracking.ut_ut_Forum_files# @NofFiles@
		<if @NofFiles@ gt 0><a href="contributions-cards/files-card@link@">#user-tracking.ut_See_Files#</a></if></li>	  
</ul>
</if><else><br>#user-tracking.No_contributions#</else>