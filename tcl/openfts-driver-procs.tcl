ad_library { 
    OpenFTS driver procs 

    @author Neophytos Demetriou
    @creation-date 2001-09-01
    @cvs-id $Id$
}

ad_proc openfts_driver__search {
    query
    offset
    limit
    user_id
    df
    dt
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

    foreach {out condition order} [Search::OpenFTS::get_sql self $query opt] break

    if { ![string length $condition] } {
        return [array get result]
    }
    if { [info exists order] && [string length $order] > 0 } {
        set order "order by $order"
    } else {
        set order ""
    }
    if { [info exists out] && [string length $out] > 0 } {
        set out ",\n $out"
    } else {
        set out ""
    }

    set date_range_condition ""
    if { $df != "" } {
	append date_range_condition "'$df' <= last_modified and"
    }
    if { $dt != "" } {
	append date_range_condition "'$dt' >= last_modified and"
    }

    set permission_check_enabled_p [ad_parameter -package_id [apm_package_id_from_key openfts-driver] permission_check_enabled_p]
    set permission_check_condition ""
    if { $permission_check_enabled_p } {
	append permission_check_condition "and acs_permission__permission_p( $self(TXTID), $user_id, 'read') = 't'"
    }

    set sql_count "
        select count(*)
        from $self(TABLE)
        where 
            $date_range_condition
            $condition
            $permission_check_condition"

    set sql_sort "
        select $self(TXTID) as object_id$out 
        from $self(TABLE)
        where 
            $date_range_condition
            $condition
            $permission_check_condition
        $order
        limit $limit
        offset $offset"

    set result(stopwords) $opt(rejected)
    set result(count) [db_exec_plsql sql_count $sql_count]
    if { $result(count) > 0} { 
	db_foreach sql_sort $sql_sort {lappend result(ids) $object_id}
    }
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
    openfts_driver__index $tid $txt $title $keywords

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








