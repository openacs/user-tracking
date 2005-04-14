
	<p>@control_bar_communities;noquote@</p>


<if @n_vals@ gt 500>
  <include src="advanced-communities-chunk-large"  type=@type@ Users=@Users@ Communities=@Communities@ referer="@referer@">
</if>
<else>
  <if @n_vals@ gt 50>
    <include src="advanced-communities-chunk-medium" type=@type@ Users=@Users@ Communities=@Communities@ referer="@referer@">
  </if>
  <else>
    <include src="advanced-communities-chunk-small"  type=@type@ Users=@Users@ Communities=@Communities@ referer="@referer@">
  </else>
</else>
