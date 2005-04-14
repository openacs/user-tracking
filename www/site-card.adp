
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


   

 
   <table border="0" width="100%">
   <tr>
      <td valign="top" width="50%">
      <table class="element" border=0 cellpadding="0" cellspacing="0" width="100%">
     <tr>
      	<td colspan="3" class="dark-line" height="0"><img src="/resources/dotlrn/spacer.gif"></td>
     </tr> 
      <tr>
      	<td colspan="3" class="dark-line" height="0"><img src="/resources/dotlrn/spacer.gif"></td>
      </tr>
      <tr>
   	<td class="light-line" width="1"><img src="/resources/dotlrn/spacer.gif" width="1"></td>
   	<td class="element-text" width="100%">
   	<table cellspacing="0" cellpadding="0" class="element-content" width="100%">
   	<tr>
   	   <td>
   	   <h3>#user-tracking.site_info#</h3>
   	   <ul>
   		<li>#user-tracking.server_name#:@system_name@</li>
   		<li>#user-tracking.instance_name#:@server@</li>
   		<br>
   		<if @nodata_p@ eq 1>
   		<if @noloading@ eq 1>
   		<li>#user-tracking.Data_from#: @FirstTime@</li> 
   		<li>#user-tracking.Data_to#: @LastTime@ </li>  
   		<li>#user-tracking.Number_of_visitors#: @TotalUnique@</li>
   		<li>#user-tracking.Number_of_sessions#: @TotalVisits@ </li>
   		<li>#user-tracking.Visited_Pages#: @TotalPages@</li>
   		<li>#user-tracking.Hits#: @TotalAsked@</li>  
   		<br>
   		</if>
   		</if>
   		<li> #user-tracking.ut_Number_Of_Communities# </li>
   		<li> #user-tracking.ut_Number_Of_Classes#</li>
     	   </ul>
   	   </td>
   	</tr>
   	</table>
    	</td>
   	<td align="right" class="light-line" width="1"><img src="/resources/dotlrn/spacer.gif" width="1"></td>
      </tr>
     <tr>
      	<td colspan="3" class="dark-line" height="20"><img src="/resources/dotlrn/spacer.gif"></td>
     </tr>   
      <tr>
   	<td class="light-line" width="1"><img src="/resources/dotlrn/spacer.gif" width="1"></td>
   	<td class="element-text" width="100%">
   	<table cellspacing="0" cellpadding="0" class="element-content" width="100%">
   	<tr>
   	   <td>
   	   <h3>#user-tracking.info_about_registered_users#</h3>
   	   <ul>
     		<li> #user-tracking.ut_Number_Of_Users_1#</li>
     		<if @NofUsers@ gt 0>
     	   	<ul> <li>#user-tracking.ut_Are_Students#</li></ul>
     		</if>
     		<if @NofAdmin@ gt 0>
   		<ul> <li>#user-tracking.ut_Are_Admin#</li></ul>
   		</if>
     		<if @LastRegistration@ gt 0>
   			<li> #user-tracking.ut_Last_Register#</li>
   		</if>		
   	   	<li><a href="registration-history">#user-tracking.ut_See_Register_Historic#</a></li>
     	   </ul>
   	   </td>
   	</tr>
   	</table>
    	</td>
   	<td align="right" class="light-line" width="1"><img src="/resources/dotlrn/spacer.gif" width="1"></td>
      </tr>   
    <tr>
      	<td colspan="3" class="dark-line" height="20"><img src="/resources/dotlrn/spacer.gif"></td>
     </tr>   
      <tr>
   	<td class="light-line" width="1"><img src="/resources/dotlrn/spacer.gif" width="1"></td>
   	<td class="element-text" width="100%">
   	<table cellspacing="0" cellpadding="0" class="element-content" width="100%">
   	<tr>
   	   <td>
   	   <h3>#user-tracking.info_about_contributions#</h3>
   		<include src="contributions-chunk2">
   	   </td>
   	</tr>
   	</table>
    	</td>
   	<td align="right" class="light-line" width="1"><img src="/resources/dotlrn/spacer.gif" width="1"></td>
      </tr>      
      <tr>
      <td colspan="3" class="light-line" width="1"><img src="/resources/dotlrn/spacer.gif"></td>
      </tr>
      </table>
      <td valign="top" width="50%">
<if @today@ gt @asked_date@>
   <if @nodata_p@ eq "1">
     <table class="element" border="0" cellpadding="0" cellspacing="0" width="100%">

     <tr>
      	<td colspan="3" class="dark-line" height="0"><img src="/resources/dotlrn/spacer.gif"></td>
     </tr> 
      <tr>
      	<td colspan="3" class="dark-line" height="0"><img src="/resources/dotlrn/spacer.gif"></td>
      </tr>
      <tr>
   	<td class="light-line" width="1"><img src="/resources/dotlrn/spacer.gif" width="1"></td>
   	<td class="element-text" width="100%">
   	<table cellspacing="0" cellpadding="0" class="element-content" width="100%">
   	<tr>
   	   <td>
               <h3>#user-tracking.lt_month_over_which_statistics_are_seen#</h3>
               <center>
               <br>
               <form name="mia" action="site-card" method="post">
               @datebox;noquote@
               <input type="submit" value="#user-tracking.see#"/>
               </form>
               </center>
               <ul><li><a href="loading2?config=@config@">#user-tracking.update_data#</a></li></ul>
   	   </td>
   	</tr>
   	</table>
    	</td>
   	<td align="right" class="light-line" width="1"><img src="/resources/dotlrn/spacer.gif" width="1"></td>
      </tr>

   	<tr><td colspan="3" class="dark-line" height="20"><img src="/resources/dotlrn/spacer.gif"></td></tr>
   	<tr>

     		<td class="light-line" width="1"><img src="/resources/dotlrn/spacer.gif" width="1"></td>
   		<td class="element-text" width="100%">
   		   <table cellspacing="0" cellpadding="0" class="element-content" width="100%">
   		   <tr>
   		   <td>
   		   <h3>#user-tracking.temporary_reports#</h3>
      		   <if @noloading@ eq 1>
   	   	   		<include src="visits-chunk" DataFileName="@DataFileName@" p_hits="1" user_id="" community_id="">
   	   	   </if><else>
   	   	   	<center>
   	   	   	<br>
   	   	   	<font color=red>#user-tracking.no_data#</font>
   	   	   	</center>
   	   	   </else>
   	   	   </td>
   		   </tr>
   		   </table>
      		</td>
      		<td align="right" class="light-line" width="1"><img src="/resources/dotlrn/spacer.gif" width="1"></td>
   	</tr>

   	<tr>
   	   <td colspan="3" class="dark-line" height="20"><img src="/resources/dotlrn/spacer.gif"></td>
      	</tr> 
   	<tr><td colspan="3" class="dark-line" height="0"><img src="/resources/dotlrn/spacer.gif"></td></tr>
   	<tr>
     		<td class="light-line" width="1"><img src="/resources/dotlrn/spacer.gif" width="1"></td>
   		<td class="element-text" width="100%">
   		   <table cellspacing="0" cellpadding="0" class="element-content" width="100%">
   		   <tr>
   		   <td>
   		   <h3>#user-tracking.info_about_petitions#</h3>
      		   <if @noloading@ eq 1>
   	   	   	<include src="petitions-chunk" DataFileName="@DataFileName@" user_id="" community_id="">
   	   	   </if><else>
   	   	   	<center>
   	   	   	<br>
   	   	   	<font color=red>#user-tracking.no_data#</font>
   	   	   	</center>
   	   	   </else>
   	   	   </td>
   		   </tr>
   		   </table>
      		</td>
      		<td align="right" class="light-line" width="1"><img src="/resources/dotlrn/spacer.gif" width="1"></td>
   	</tr>	
   	<tr>
   	   <td colspan="3" class="dark-line" height="20"><img src="/resources/dotlrn/spacer.gif"></td>
      	</tr> 
   	<tr><td colspan="3" class="dark-line" height="0"><img src="/resources/dotlrn/spacer.gif"></td></tr>
   	<tr>
     		<td class="light-line" width="1"><img src="/resources/dotlrn/spacer.gif" width="1"></td>
   		<td class="element-text" width="100%">
   		   <table cellspacing="0" cellpadding="0" class="element-content" width="100%">
   		   <tr>
   		   <td>
   		   <h3>#user-tracking.info_about_consulted_material#</h3>
      		   <if @noloading@ eq 1>   		   
   	   	   	<include src="visited-material-chunk" DataFileName="@DataFileName@" user_id="" community_id="">
   	   	   </if><else>
   	   	   	<center>
   	   	   	<br>
   	   	   	<font color=red>#user-tracking.no_data#</font>
   	   	   	</center>
   	   	   </else>
   	   	   </td>
   		   </tr>
   		   </table>
      		</td>
      		<td align="right" class="light-line" width="1"><img src="/resources/dotlrn/spacer.gif" width="1"></td>
   	</tr>	
   	<tr>
   	<td colspan="3" class="light-line" width="1"><img src="/resources/dotlrn/spacer.gif"></td>
   	</tr>
   	   </if>
   <else>
      <include src="loading" url="site-card?" onlylines="@onlylines@" onlyuser="@onlyuser@" config="@config@" type="@type@" year="@year@" month="@month@">
   </else>
</if>
<else>
    <table class="element" border="0" cellpadding="0" cellspacing="0" width="100%">
    <tr>
      	<td colspan="3" class="dark-line" height="0"><img src="/resources/dotlrn/spacer.gif"></td>
    </tr> 
    <tr>
      	<td colspan="3" class="dark-line" height="0"><img src="/resources/dotlrn/spacer.gif"></td>
    </tr>
    <tr>
   	<td class="light-line" width="1"><img src="/resources/dotlrn/spacer.gif" width="1"></td>
   	<td class="element-text" width="100%">
   	<table cellspacing="0" cellpadding="0" class="element-content" width="100%">
   	<tr>
   	   <td>
               <h3>#user-tracking.lt_month_over_which_statistics_are_seen#</h3>
               <center>
               <br>
               <form name="mia" action="site-card" method="post">
               @datebox;noquote@
               <input type="submit" value="#user-tracking.see#"/>	
               </form>
               </center>
	       <font color=red>#user-tracking.future_date#</font>
   	   </td>
   	</tr>
   	</table>
    	</td>
   	<td align="right" class="light-line" width="1"><img src="/resources/dotlrn/spacer.gif" width="1"></td>
    </tr>
    </table>
</else>
</table>
</table>	



