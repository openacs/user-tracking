<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<h3>#user-tracking.messages_added#</h3>

<ul>

<if @user_id@ ne "">
  <li> #dotlrn.Person_name#: @first_names@ @last_name@ </li>
  <li> #dotlrn.Email# <a href="mailto:@email@">@email@</a> </li>
  
  </ul>

	<center>
	<listtemplate name="forums_messages"></listtemplate>
	</center>

</if>
<else><if @community_id@ ne "">
  <li> #user-tracking.ut_Community_Name# </li>

  </ul>
	<center>
	<listtemplate name="forums"></listtemplate>
	</center>
</if><else>
	<center>
	<listtemplate name="forums"></listtemplate>
	</center>

</else>
</else>






