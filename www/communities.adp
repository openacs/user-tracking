
<master>
<property name="context"></property>
<property name="title">User Tracking</property>


<if @communities:rowcount@ gt 0>

<multiple name="communities">

<%
    set old_level 0
    set new_level 0
    set depth 0
%>

<group column="simple_community_type">

<% set new_level $communities(tree_level) %>

  <if @new_level@ lt @old_level@>
    <% incr depth -1 %>
    </ul>
	<if @new_level@ eq 1 and @depth@ gt 1>
	<% while {$depth > 1} {	
		append close_tags "</ul>" 
		incr depth -1 
	} 
	%>
	@close_tags@
        </if>
     </if>

  <if @new_level@ gt @old_level@>
<% incr depth 1 %>
    <ul>
	<nobr>
  </if>

      <li>
        <nobr>
          <a href="@communities.url@">@communities.pretty_name@</a>
	<if @communities.archived_p@><font color=red>Archived</font></if>
	<if @show_buttons_p@ eq 1>
		&nbsp; <small> 
                        <a href="@communities.url@deregister?referer=@referer@">#dotlrn.drop_membership_link#</a>
                      </small>
		<if @communities.admin_p@ eq 1>
                  &nbsp; <small>
                           <a href="@communities.url@one-community-admin">#dotlrn.administer_link#</a>
                         </small>
		</if>
	</if>
        </nobr>
      </li>

<% set old_level $new_level %>

</group>

<%
    for {set i $depth} {$i > 0} {incr i -1} {
        template::adp_puts "</ul>\n"
    }
%>

</multiple>

</if>
