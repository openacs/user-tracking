<%
	set admin_url [dotlrn::get_admin_url]
%>

<center>
<table bgcolor="#cccccc" cellpadding="5" cellspacing="3" width="95%">
  <tr>
    <th align="left" width="50%">#dotlrn.User#</th>        
    <th align="left">#user-tracking.lt_User_id#</th>
    <th align="left">#dotlrn.Guest#</th>    
    <th align="left">#user-tracking.lt_Add_a_user#</th>    
  </tr>

<if @Userslist:rowcount@ gt 0>
<multiple name="Userslist">

<if @Userslist.rownum@ odd>
  <tr bgcolor="#eeeeee">
</if>
<else>
  <tr bgcolor="#d9e4f9">
</else>
    <td align="left">
      <a href="@admin_url@/user?user_id=@Userslist.user_id@">@Userslist.last_name@, @Userslist.first_names@</a> (<a href="mailto:@Userslist.email@">@Userslist.email@</a>)
    </td>
    <td align="center">@Userslist.user_id@</td>
    <td align="center">
     <if @Userslist.guest_p@ eq t>#dotlrn.Yes#</if><else>#dotlrn.No#</else>
    </td>
<td>
    	<%
    		set selected 0
		set temp ""
		set without_selected ""
		set patron "(.*)(@Userslist.user_id@)(.*)"
		if { [regexp $patron @Users@ all part1 part2 part3] == 1} {
			set selected 1
			append without_selected @part1@ @part3@
		} else {
			append temp @Users@ " " @Userslist.user_id@
		}
    	%>
	<if @selected@ eq 1><a href="@referer@?Users=@without_selected@&Communities=@Communities@">#user-tracking.eliminate#</a></if>
	<else>
    		<a href="@referer@?Users=@temp@&Communities=@Communities@">#user-tracking.add#</a>
	</else>
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

