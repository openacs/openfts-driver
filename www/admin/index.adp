<master>
<property name="title">OpenFTS Driver Administration</property>
<property name="context">@context;noquote@</property>

<if @fts_conf_exists_p@ ne 0>
  <a href="initialize">Initialize OpenFTS Engine</a>
</if>
<else>
  <a href="destroy">Drop OpenFTS Engine</a>
</else>
