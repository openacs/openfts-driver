set context {}

set fts_conf_exists_p [catch {
    set ngroups [db_exec_plsql get_ngroups "select count(*) from fts_conf"]
}]

