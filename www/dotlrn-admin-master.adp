

<master>
<property name="title">@title@</property>
<property name="link_all">1</property>
<if @focus@ not nil><property name="focus">@focus;noquote@</property></if>

<h2>@title@</h2>

<if @context_bar@ not nil>
  <%= [eval dotlrn::admin_navbar $context_bar] %>
</if>
<hr>
<slave>













