ad_page_contract {

    Initialize OpenFTS

    @author Neophytos Demetriou

} {
    table_name
    table_id
    dict
    numbergroup
    ignore_headline
    ignore_id_index
    map
    use_index_table
}

set DICT_UNKNOWN_LEXEM_TABLE "fts_unknown_lexem"

if [catch {
    db_dml create_table "create table $table_name ( ${table_id} int not null primary key, path varchar unique, fts_index txtidx, last_modified timestamp );"
} err] {
    error "$err"
    return
}

set dat "
  txttid          ${table_name}.${table_id} 
  use_index_table $use_index_table 
  txtidx_field    fts_index 
  numbergroup     $numbergroup 
  ignore_id_index [list $ignore_id_index] 
  ignore_headline [list $ignore_headline] 
  map             [list $map] 
  dict            [list $dict]"

ns_log Notice "dat = $dat"
array set opt $dat



array set idx [Search::OpenFTS::Index::init opt]

if {[array size idx] == 0} {
    error "QQQ: Init failed"
    return
}

db_dml create_function "create function ${table_name}_utrg () returns opaque as ' \
	                begin \
			new.last_modified := now(); \
			return new; \
			end;' language 'plpgsql';"

db_dml create_trigger "create trigger ${table_name}_utrg before update on ${table_name} \
	               for each row execute procedure ${table_name}_utrg ();"


Search::OpenFTS::Index::create_index idx
Search::OpenFTS::DESTROY

ad_returnredirect "./"
