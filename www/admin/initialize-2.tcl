ad_page_contract {

    Initialize OpenFTS

    @author Neophytos Demetriou

} {
    table_name
    table_id
    dict
    parser
    numbergroup
    ignore_headline
    ignore_id_index
    map
    use_index_table
    use_index_array
}

array set opt "
txttid          ${table_name}.${table_id}
numbergroup     $numbergroup
parser          $parser
use_index_array $use_index_array
use_index_table $use_index_table
dict            [list $dict]
map             [list $map]
ignore_id_index [list $ignore_id_index]
ignore_headline [list $ignore_headline]
"

db_dml create_table "create table $table_name ( $table_id int not null primary key, $use_index_array int\[\] );"

array set idx [Search::OpenFTS::Index::init opt]

if {[array size idx] == 0} {
    error "QQQ: Init failed"
    exit
}

Search::OpenFTS::Index::create_index idx

ad_returnredirect ""
