ad_page_contract {

    Initialize OpenFTS

    @author Neophytos Demetriou

}

set context_bar [ad_context_bar {Initialize OpenFTS Engine}]

template::form create openfts_init_form \
    -action initialize-2

template::element create openfts_init_form table_name \
    -html "size 40" \
    -label "Table Name" \
    -value "txt"

template::element create openfts_init_form table_id \
    -html "size 40" \
    -label "ID Column Name" \
    -value "tid"

template::element create openfts_init_form dict \
    -html "size 40" \
    -label "Dictionaries" \
    -value "Search::OpenFTS::Dict::PorterEng Search::OpenFTS::Dict::UnknownDict"

template::element create openfts_init_form parser \
    -html "size 40" \
    -label "Parser" \
    -value Search::OpenFTS::Parser

template::element create openfts_init_form numbergroup \
    -html "size 40" \
    -label "Number of index tables" \
    -value 13

template::element create openfts_init_form ignore_headline \
    -html "size 40" \
    -label "Types of lexemes to ignore <br>while constructing a headline" \
    -value {13 15 16 17 5}

template::element create openfts_init_form ignore_id_index \
    -html "size 40" \
    -label "Types of lexemes to ignore <br>while indexing" \
    -value {13 14 12}

template::element create openfts_init_form map \
    -html "size 40" \
    -label "Mapping of types of lexemes <br>to dictionaries" \
    -value {19 1 18 1 8 1 7 1 6 1 5 1 4 1}

template::element create openfts_init_form use_index_table \
    -html "size 40" \
    -label "use_index_table" \
    -value 1

template::element create openfts_init_form use_index_array \
    -html "size 40" \
    -label "use_index_array" \
    -value fts_index

template::element create openfts_init_form submit \
    -widget submit \
    -label "Initialize OpenFTS Engine"






