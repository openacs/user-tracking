<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>


<h3>#user-tracking.Added_news#</h3>

<ul>

<if @user_id@ ne "">
  <li> #dotlrn.Person_name#: @first_names@ @last_name@ </li>
  <li> #dotlrn.Email# <a href="mailto:@email@">@email@</a> </li>
  
  </ul>
</if>
<else><if @community_id@ ne "">
  <li> #user-tracking.ut_Community_Name# </li>
  </ul>
</if>
</else>

<center>
<h4>#user-tracking.Active_news#</h4>
<listtemplate name="active_news"></listtemplate>
</center>
<br>
<br>
<center>
<h4>#user-tracking.Non_active_news#</h4>
<listtemplate name="non_active_news"></listtemplate>
</center>
<br>
<br>





