<%

%>

<center>
<table bgcolor="#cccccc" cellpadding="5" cellspacing="3" width="95%">
  <tr>
    <th align="left" width="50%">#dotlrn.Community#</th>        
    <th align="left">#user-tracking.add#</th>
  </tr>

<if @communities_list:rowcount@ gt 0>
   <multiple name="communities_list">

   	<if @communities_list.rownum@ odd>
	  <tr bgcolor="#eeeeee">
	</if>
	<else>
	  <tr bgcolor="#d9e4f9">
	</else>
	    <td align="left">    
	       @communities_list.pretty_name@ ( @communities_list.community_id@ )
	    </td>
	    <td>
	    <% 
	    	
		set selected 0
		set without_selected ""
		set patron "(.*)(@communities_list.community_id@)(.*)"
		if { [regexp $patron @Communities@ todo part1 part2 part3] ==1 } {
			set selected 1
			append without_selected @part1@ @part3@
		} else {
			set temp ""
	    		append temp @Communities@ " " @communities_list.community_id@
			set tempLong ""
			append tempLong @Communities@ " " [user-tracking::select_children_communities @communities_list.community_id@]
		}
	    %>
		<if @selected@ eq 1><a href="@referer@?Communities=@without_selected@&Users=@Users@">#user-tracking.eliminate#</a></if>
		<else>
	    		<a href="@referer@?Communities=@temp@&Users=@Users@">#user-tracking.add#</a>
			|
			<a href="@referer@?Communities=@tempLong@&Users=@Users@">#user-tracking.add_subgroups#</a>
		</else>
	    </td>
	  </tr>
    </multiple>
</if>
<else>
  <tr bgcolor="#eeeeee">
    <td align="left" colspan="2"><i>#dotlrn.No_Communities#</i></td>
  </tr>
</else>

</table>
</center>





