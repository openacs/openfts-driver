 

set PREFIX ""
array set idx [Search::OpenFTS::Index::new $PREFIX]
Search::OpenFTS::Index::drop idx
catch {
  db_dml drop_table "drop table $idx(TABLE)"
}
catch {
    db_dml drop_function "drop function $idx(TABLE)_utrg ()"
}
catch {
    db_dml drop_fts_unknown_lexem "drop table fts_unknown_lexem;"
}


ad_returnredirect "./"
