
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
<h3>#user-tracking.lt_Communities_Stats#</h3>

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
   	   <h3>#user-tracking.community_info#</h3>
   	   <ul>
	   	<li> #user-tracking.ut_Name#</li>
	   	<li> #user-tracking.ut_Creation_Date# </li>  	   	
	   	<if @type@ eq 2>
	   	<li> #user-tracking.ut_Type_Course#</li>
	   		<li> #user-tracking.ut_Number_Of_Members#</li>
		   	<ul>
		   	<li> #user-tracking.ut_Number_Of_Students#</li>
	   		<li> #user-tracking.ut_Number_Of_Proffesors#</li>
	   		</ul>
	   	</if>
	   	<else> 
	   		<li> #user-tracking.ut_Type_Club#</li>
		   	<li> #user-tracking.ut_Number_Of_Members#</li>
		   	<ul>
	   		<li> #user-tracking.ut_Number_Of_Users#</li>
		   	<li> #user-tracking.ut_Number_Of_Admins#</li>
		   	</ul>
	   	</else>
	   	<if @NofSub@ gt 0><li> #user-tracking.ut_Number_Of_Sub# </li></if>
	   	<br>
   		<if @last_visit@ not nil>
   		<li> #dotlrn.Last_Visit#: @last_visit@ </li>
   		</if>
   		<br>
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
   		<include src="contributions-chunk2" community_id="@community_id@">
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
               <form name="mia" action="communities-card" method="post">
               @datebox;noquote@
               @hidden;noquote@
               <input type="submit" value="#user-tracking.see#"/>
               </form>
                <if @nodata_p@ eq 1>
   		<if @noloading@ eq 1>
		<table cellspacing="0" cellpadding="0" class="element-content" width="90%">   		
   		<tr><td><listtemplate name="summary"></listtemplate></td></tr>
   		</table>
   		<br>
   		</if>  
   		</if>   
               <form name="otro" action="loading2" method="post">
               @hidden2;noquote@
               <input type="submit" value="#user-tracking.update_data#"/>
               </form>  
               </center>
                	   
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
   	   	   	<include src="visits-chunk" DataFileName="@DataFileName@" community_id="@community_id@" user_id="">
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
   	   	   	<include src="petitions-chunk" DataFileName="@DataFileName@" community_id="@community_id@" user_id="">
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
   	   	   	<include src="visited-material-chunk" DataFileName="@DataFileName@" community_id="@community_id@" user_id="">
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
      <include src="loading" url="communities-card?community_id=@community_id@&" onlylines="@community_id@" onlyuser="" config="@config@" type="@type@" year="@year@" month="@month@">
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
               <form name="mia" action="communities-card" method="post">
               @datebox;noquote@
               @hidden;noquote@
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

                                                                                                                                                                                                                                                                                     