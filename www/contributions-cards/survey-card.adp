<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<h3>#user-tracking.added_survey#</h3>

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

<if @Users:rowcount@ gt 0>
	<center>
	<listtemplate name="surveys_responses"></listtemplate>
	</center>
</if>
<else>
  </ul>
	<center>
	<listtemplate name="surveys"></listtemplate>
	</center>
</else>
  
