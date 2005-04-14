
<formtemplate id="user_search">
  <formwidget id="type_request">
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

<include src="advanced-users-chunk" &Userslist="Userslist" Users=@Users@ Communities=@Communities@ referer=@referer@>



