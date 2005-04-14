
<%
	set admin_url [dotlrn::get_admin_url]
%>
<center>
<table bgcolor="#cccccc" cellpadding="5" cellspacing="3" width="95%">
  <tr>
    <th align="left" width="50%">#dotlrn.User#</th>        
    <th align="left">#dotlrn.Access#</th>
    <th align="left">#dotlrn.Guest#</th>    
    <th align="left">#user-tracking.lt_View_Stats#</th>    
  </tr>

<if @users:rowcount@ gt 0>
<multiple name="users">

<if @users.rownum@ odd>
  <tr bgcolor="#eeeeee">
</if>
<else>
  <tr bgcolor="#d9e4f9">
</else>
    <td align="left">
      <a href="@admin_url@/user?user_id=@users.user_id@">@users.last_name@, @users.first_names@</a> (<a href="mailto:@users.email@">@users.email@</a>)
    </td>
    <td align="center">@users.access_level@</td>
    <td align="center">
     <if @users.guest_p@ eq t>#dotlrn.Yes#</if><else>#dotlrn.No#</else>
    </td>
    <td>
    	<a href="/user-tracking/users-card?user_id=@users.user_id@">#user-tracking.Stats#</a>
    </td>
  </tr>

</multiple>
</if>
<else>
  <tr bgcolor="#eeeeee">
    <td align="left" colspan="4"><i>#dotlrn.No_Users#</i></td>
  </tr>
</else>

</table>
</center>





