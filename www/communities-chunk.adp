

<center>
<table bgcolor="#cccccc" cellpadding="5" cellspacing="3" width="95%">
  <tr>
    <th align="left" width="50%">#dotlrn.Community#</th>        
    <th align="left">#user-tracking.lt_View_Stats#</th>
  </tr>

<if @communities:rowcount@ gt 0>
   <multiple name="communities">

   	<if @communities.rownum@ odd>
	  <tr bgcolor="#eeeeee">
	</if>
	<else>
	  <tr bgcolor="#d9e4f9">
	</else>
	    <td align="left">    
	       @communities.pretty_name@ ( @communities.community_id@ )
	    </td>
	    <td>
	    	<a href="communities-card?community_id=@communities.community_id@">#user-tracking.Stats#</a>
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





