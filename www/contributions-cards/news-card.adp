<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>


<h3>#user-tracking.Added_news#</h3>

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
