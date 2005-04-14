<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<h3>#user-tracking.added_files_by#</h3>

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


<p>#user-tracking.added_files#</p>
<center>
<listtemplate name="created_files"></listtemplate>
</center>

<p>#user-tracking.modified_files#</p>
<center>
<listtemplate name="modified_files"></listtemplate>
</center>

