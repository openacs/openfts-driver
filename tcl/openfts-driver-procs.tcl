ad_proc openfts_driver__search {
    query
    offset
    limit
} {
    @author Neophytos Demetriou
} {

    set result(count) 0
    set result(ids) ""
    set result(stopwords) ""


    array set self [Search::OpenFTS::new ofts]
    if ![array size self] {
        error "Search failed."
    }

    set opt(rejected) [list]

    if { ![info exists opt(txttid)] || [string equal $opt(txttid) ""] } {
        set opt(txttid) $self(TXTTID)
    }

    foreach {out tables condition order} [Search::OpenFTS::get_sql self $query opt] break

    if { ![string length $condition] } {
        return [array get result]
    }
    if { [info exists order] && [string length $order] > 0 } {
        set order "order by $order"
    } else {
        set order ""
    }
    if { ![info exists tables] } {
        set tables ""
    }
    if { [info exists out] && [string length out] > 0 } {
        set out ",\n $out"
    } else {
        set out ""
    }
    set txttbl [split $opt(txttid) .]

    set sql_count "
        select count(*)
        from [lindex $txttbl 0]$tables
        where $condition"

    set sql_sort "
        select $opt(txttid) as id$out 
        from [lindex $txttbl 0]$tables 
        where $condition
        $order
        limit $limit
        offset $offset"

    set result(stopwords) $opt(rejected)
    set result(count) [db_exec_plsql sql_count $sql_count]
    db_foreach sql_sort $sql_sort {lappend result(ids) $id}
    return [array get result]

}


ad_proc openfts_driver__index {
    tid
    txt
    {title ""}
    {keywords ""}
} {
    @author Neophytos Demetriou
} {

    set exists_p [db_0or1row exists_p {select 1 from txt where tid=:tid}]

    if ![set exists_p] {

	db_dml insert_tid {insert into txt (tid) values (:tid)}

    }
    array set idx [Search::OpenFTS::Index::new]

    Search::OpenFTS::Index::index idx $tid $txt $title
    
    return

}


ad_proc openfts_driver__unindex {
    tid
} {
    @author Neophytos Demetriou
} {

    array set idx [Search::OpenFTS::Index::new]

    Search::OpenFTS::Index::delete idx $tid

    return
}



ad_proc openfts_driver__update_index {
    tid
    txt
    {title ""}
    {keywords ""}
} {
    @author Neophytos Demetriou
} {

    openfts_driver__unindex $tid
    openfts_driver__index $tid $txt $title

    return
}



ad_proc openfts_driver__summary {
    query
    src
} {
    @author Neophytos Demetriou
} {

    if {$src == ""} return

    array set opts "
           maxread 200
           maxlen 200
           otag <b>
           ctag </b>
           dict_opt {Search::OpenFTS::Dict::PorterEng Search::OpenFTS::Dict::UnknownDict}
	"

    set opts(query) [DoubleApos $query]
    set opts(src) [DoubleApos $src]

    array set fts [Search::OpenFTS::new ofts]

    return [Search::OpenFTS::get_headline fts opts]

}



ad_proc openfts_driver__info {} {
    @author Neophytos Demetriou
} {
    array set info {
        package_key openfts-driver
	version 1.0
        automatic_and_queries_p true
	stopwords_p true
    }

    return [array get info]

}








