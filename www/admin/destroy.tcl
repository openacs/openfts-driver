catch {
    set ngroups [db_exec_plsql get_ngroups "select mod from fts_conf where did = -2"]
}

catch {
    db_dml drop_table "drop table txt;"
}

catch {
    db_dml drop_fts_conf "drop table fts_conf;"
}

catch {
    for { set __i 1 } { $__i <= $ngroups } { incr __i  } {
	db_dml drop_index "drop table index${__i};"
    }
}

catch {
    db_dml drop_fts_unknown_lexem "drop table fts_unknown_lexem;"
}

catch {
    db_dml drop_s_fts_unknown_lexem "drop sequence s_fts_unknown_lexem;"
}

ad_returnredirect ""