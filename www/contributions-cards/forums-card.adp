<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<h3>#user-tracking.forums_added#</h3>

<ul>

<if @Users:rowcount@ gt 0>
	<H3>Usuarios Seleccionados </H3>
	<listtemplate name="Users"></listtemplate>
	<BR>
</if>
<if @Communities:rowcount@ gt 0>
	<H3>Comunidades Seleccionados </H3>
	<listtemplate name="Communities"></listtemplate>
	<BR>
</if>

	<center>
	<listtemplate name="forums"></listtemplate>
	</center>


