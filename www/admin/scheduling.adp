<master>
  <property name="title">@page_title;noquote@</property>
  <property name="context">@context;noquote@</property>

<script language="JavaScript">
    function TimePChanged(elm) {
      var form_name = "ut_sched";

      if (elm == null) return;
      if (document.forms == null) return;
      if (document.forms[form_name] == null) return;

      if (elm.value == 1) {
          <multiple name="time_format_elms">
            document.forms[form_name].elements["horas.@time_format_elms.name@"].disabled = false;
          </multiple>
      } else {
          <multiple name="time_format_elms">
            document.forms[form_name].elements["horas.@time_format_elms.name@"].disabled = true;
          </multiple>
      }
  }
</script>


  <div id="events">   
    <formtemplate id="ut_sched"></formtemplate>
  </div>
