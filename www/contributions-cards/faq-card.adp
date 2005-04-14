<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<h3>#user-tracking.added_faqs#</h3>

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
	<listtemplate name="faqs_q_and_as"></listtemplate>
	</center>

</if>
<else>
	<center>
	<listtemplate name="faqs"></listtemplate>
	</center>
</else>
 
</ul>


