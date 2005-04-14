<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>


<if @admin_p@ ne 0>
  <p>
    <table width="100%">
     <tr>
      <th align=right>
       [<a href="admin/">#user-tracking.Administer#</a>]
      </th>
     </tr>
    </table>	
</if>

<ul>
<li><a href="site-card">#user-tracking.lt_Site_Stats#</a></li>
<li><a href="communities-stats">#user-tracking.lt_Communities_Stats_2#</a></li>
<li><a href="users-stats">#user-tracking.lt_Users_Stats#</a></li>
<li><a href="advanced-stats">#user-tracking.lt_Advanced_Stats_1#</a></li>
</ul>
