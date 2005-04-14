
<formtemplate id="community_search" >
  <formwidget id="type">
  <formwidget id="referer">

<table cellspacing="3" cellpadding="3">

  <tr>
    <th align="left">#dotlrn.Search_Text#</th>
    <td><formwidget id="search_text"></td>
    <td><input type="submit" value="#dotlrn.Search#"></td>
  </tr>

</table>

</formtemplate>

<include src="advanced-communities-chunk" type=@type@ &communities_list="communities_list" Users=@Users@ Communities=@Communities@ referer=@referer@>



