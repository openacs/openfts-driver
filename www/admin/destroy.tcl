catch {
    set ngroups [db_exec_plsql get_ngroups "select mod from fts_conf where did = -2"]
    set table_name [lindex [split [db_exec_plsql get_txttid "select mod from fts_conf where did = -1"] .] 0]
}

catch {
    db_dml drop_fts_conf "drop table fts_conf;"
}


catch {
    db_dml drop_trigger "drop trigger ${table_name}_utrg;"
}

catch {
    db_dml drop_function "drop function ${table_name}_utrg ();"
}

catch {
    db_dml drop_table "drop table ${table_name};"
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

ad_returnredirect "./"