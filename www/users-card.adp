
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
<h3>#user-tracking.User_Stats#</h3>


   

 
   <table border="0" width="100%">
   <tr>
      <td valign="top" width="50%">
      <table class="element" border=0 cellpadding="0" cellspacing="0" width="100%">
     <tr>
      	<td colspan="3" class="dark-line" height="0"><img src="/resources/dotlrn/spacer.gif" alt="" ></td>

     </tr> 
      <tr>
      	<td colspan="3" class="dark-line" height="0"><img src="/resources/dotlrn/spacer.gif" alt="" ></td>

      </tr>
      <tr>
   	<td class="light-line" width="1"><img src="/resources/dotlrn/spacer.gif" alt=""  width="1"></td>

   	<td class="element-text" width="100%">
   	<table cellspacing="0" cellpadding="0" class="element-content" width="100%">
   	<tr>
   	   <td>
   	   <h3>#user-tracking.user_info#</h3>
   	   <ul>

   		<li> #user-tracking.Person_name#: @first_names@ @last_name@ </li>
   		<li> #user-tracking.Email# <a href="mailto:@email@">@email@</a> </li>
   		<li> #user-tracking.Screen_name#: @screen_name;noquote@ </li>
   		<li> #user-tracking.User_ID#: @user_id@  </li>
   		<li> #user-tracking.Registration_date# @registration_date@ </li>
   		<if @last_visit@ not nil>
   		<li> #user-tracking.Last_Visit#: @last_visit@ </li>
   		</if>
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

     	   </ul>
   	   </td>
   	</tr>
   	</table>
    	</td>
   	<td align="right" class="light-line" width="1"><img src="/resources/dotlrn/spacer.gif" alt=""  width="1"></td>

      </tr>
  
    <tr>
      	<td colspan="3" class="dark-line" height="20"><img src="/resources/dotlrn/spacer.gif" alt="" ></td>

     </tr>   
      <tr>
   	<td class="light-line" width="1"><img src="/resources/dotlrn/spacer.gif" alt=""  width="1"></td>

   	<td class="element-text" width="100%">
   	<table cellspacing="0" cellpadding="0" class="element-content" width="100%">
   	<tr>
   	   <td>
   	   <h3>#user-tracking.info_about_contributions#</h3>
   		<include src="contributions-chunk2" user_id="@user_id@">
   	   </td>
   	</tr>
   	</table>
    	</td>
   	<td align="right" class="light-line" width="1"><img src="/resources/dotlrn/spacer.gif" alt=""  width="1"></td>

      </tr>      
      <tr>
      <td colspan="3" class="light-line" width="1"><img src="/resources/dotlrn/spacer.gif" alt="" ></td>

      </tr>
      </table>
      <td valign="top" width="50%">
<if @today@ gt @asked_date@>
   <if @nodata_p@ eq "1">
     <table class="element" border="0" cellpadding="0" cellspacing="0" width="100%">

     <tr>
      	<td colspan="3" class="dark-line" height="0"><img src="/resources/dotlrn/spacer.gif" alt="" ></td>

     </tr> 
      <tr>
      	<td colspan="3" class="dark-line" height="0"><img src="/resources/dotlrn/spacer.gif" alt="" ></td>

      </tr>
      <tr>
   	<td class="light-line" width="1"><img src="/resources/dotlrn/spacer.gif" alt=""  width="1"></td>

   	<td class="element-text" width="100%">
   	<table cellspacing="0" cellpadding="0" class="element-content" width="100%">
   	<tr>
   	   <td>
               <h3>#user-tracking.lt_month_over_which_statistics_are_seen#</h3>
               <center>
               <br>
               <form name="mia" action="users-card" method="post">
               @datebox;noquote@
               @hidden;noquote@
               <input type="submit" value="#user-tracking.see#"/>
               </form>
               </center>
               <ul><li><a href="loading2?config=@config@&url=users-card&onlyuser=@user_id@&LastTime=@LastLine@&month=@month@&year=@year@">#user-tracking.update_data#</a></li></ul>
   	   </td>
   	</tr>
   	</table>
    	</td>
   	<td align="right" class="light-line" width="1"><img src="/resources/dotlrn/spacer.gif" alt=""  width="1"></td>

      </tr>

   	<tr><td colspan="3" class="dark-line" height="20"><img src="/resources/dotlrn/spacer.gif" alt="" ></td></tr>

   	<tr>

     		<td class="light-line" width="1"><img src="/resources/dotlrn/spacer.gif" alt=""  width="1"></td>

   		<td class="element-text" width="100%">
   		   <table cellspacing="0" cellpadding="0" class="element-content" width="100%">
   		   <tr>
   		   <td>
   		   <h3>Informes Temporales</h3>
      		   <if @noloading@ eq 1>
   	   	   		<include src="visits-chunk" DataFileName="@DataFileName@" user_id="@user_id@" community_id="">
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
      		<td align="right" class="light-line" width="1"><img src="/resources/dotlrn/spacer.gif" alt=""  width="1"></td>

   	</tr>

   	<tr>
   	   <td colspan="3" class="dark-line" height="20"><img src="/resources/dotlrn/spacer.gif" alt="" ></td>

      	</tr> 
   	<tr><td colspan="3" class="dark-line" height="0"><img src="/resources/dotlrn/spacer.gif" alt="" ></td></tr>

   	<tr>
     		<td class="light-line" width="1"><img src="/resources/dotlrn/spacer.gif" alt=""  width="1"></td>

   		<td class="element-text" width="100%">
   		   <table cellspacing="0" cellpadding="0" class="element-content" width="100%">
   		   <tr>
   		   <td>
   		   <h3>#user-tracking.info_about_petitions#</h3>
      		   <if @noloading@ eq 1>
   	   	   	<include src="petitions-chunk" DataFileName="@DataFileName@" user_id="@user_id@" community_id=""> 
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
      		<td align="right" class="light-line" width="1"><img src="/resources/dotlrn/spacer.gif" alt=""  width="1"></td>

   	</tr>	
   	<tr>
   	   <td colspan="3" class="dark-line" height="20"><img src="/resources/dotlrn/spacer.gif" alt="" ></td>

      	</tr> 
   	<tr><td colspan="3" class="dark-line" height="0"><img src="/resources/dotlrn/spacer.gif" alt="" ></td></tr>

   	<tr>
     		<td class="light-line" width="1"><img src="/resources/dotlrn/spacer.gif" alt=""  width="1"></td>

   		<td class="element-text" width="100%">
   		   <table cellspacing="0" cellpadding="0" class="element-content" width="100%">
   		   <tr>
   		   <td>
   		   <h3>#user-tracking.info_about_consulted_material#</h3>
      		   <if @noloading@ eq 1>   		   
   	   	   	<include src="visited-material-chunk" DataFileName="@DataFileName@" user_id="@user_id@" community_id="">
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
      		<td align="right" class="light-line" width="1"><img src="/resources/dotlrn/spacer.gif" alt=""  width="1"></td>

   	</tr>	
   	<tr>
   	<td colspan="3" class="light-line" width="1"><img src="/resources/dotlrn/spacer.gif" alt="" ></td>

   	</tr>
   	   </if>
   <else>
      <include src="loading" url="users-card?user_id=@user_id@&" onlylines="@onlylines@" onlyuser="@user_id@" config="@config@" type="@type@" year="@year@" month="@month@" LastTime="@LastLine@">
   </else>
</if>
<else>
    <table class="element" border="0" cellpadding="0" cellspacing="0" width="100%">
    <tr>
      	<td colspan="3" class="dark-line" height="0"><img src="/resources/dotlrn/spacer.gif" alt="" ></td>

    </tr> 
    <tr>
      	<td colspan="3" class="dark-line" height="0"><img src="/resources/dotlrn/spacer.gif" alt="" ></td>

    </tr>
    <tr>
   	<td class="light-line" width="1"><img src="/resources/dotlrn/spacer.gif" alt=""  width="1"></td>

   	<td class="element-text" width="100%">
   	<table cellspacing="0" cellpadding="0" class="element-content" width="100%">
   	<tr>
   	   <td>
               <h3>#user-tracking.lt_month_over_which_statistics_are_seen#</h3>
               <center>
               <br>
               <form name="mia" action="users-card" method="post">
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
   	<td align="right" class="light-line" width="1"><img src="/resources/dotlrn/spacer.gif" alt=""  width="1"></td>

    </tr>
    </table>
</else>
</table>
</table>	

                                                                                                                                 