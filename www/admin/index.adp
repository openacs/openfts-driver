<master>

<h2>OpenFTS Driver Administration</h2>
@context_bar@
<hr>

<ul>
  <li>
  <if @fts_conf_exists_p@ ne 0>
    <a href=initialize>Initialize OpenFTS Engine</a></li>
  </if>
  <else>
    <a href=destroy>Drop OpenFTS Engine</a></li>
  </else>
</ul>