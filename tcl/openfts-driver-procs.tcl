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
    packages
} {
    @author Neophytos Demetriou
} {
    # JCD: I have done something horrible.  I took out dt and 
    # made it packages.  when you search there is no way to specify a date range just
    # last six months, last year etc.  I hijack what was the old dt param and make it 
    # the package_id list and just empty string for dt.
    set dt {}

    set result(count) 0
    set result(ids) ""
    set result(stopwords) ""

    array set self [Search::OpenFTS::new ofts]
    if ![array size self] {
        Search::OpenFTS::DESTROY
        error "Search failed."
        return
    }

    set opt(rejected) [list]

    foreach {out condition order} [Search::OpenFTS::get_sql self $query opt] break

    set result(stopwords) $opt(rejected)
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

    # if we were passed package_ids restrict to those packages.
    set ids {}
    foreach id $packages {
        if {[string is integer -strict $id]} {
            lappend ids $id
        }
    }
    if {![empty_string_p $ids]} {
        set package_restrict " and object_id in (select o.object_id from acs_objects o where o.package_id in ([join $ids ,])"
    } else {
        set package_restrict {}
    }

    set permission_check_enabled_p [ad_parameter -package_id [apm_package_id_from_key openfts-driver] permission_check_enabled_p]
    if { $permission_check_enabled_p } {
	append permission_check_condition "and exists (select 1
                    from acs_object_party_privilege_map m
                    where m.object_id = $self(TXTID)
                      and m.party_id = :user_id
                      and m.privilege = 'read')"
    } else {
        set permission_check_condition {}
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

    set result(count) [db_exec_plsql sql_count $sql_count]
    if { $result(count) > 0} { 
	db_foreach sql_sort $sql_sort {lappend result(ids) $object_id}
    }
    Search::OpenFTS::DESTROY

    return [array get result]

}


ad_proc openfts_driver__index {
    tid
    txt
    {title ""}
    {keywords ""}
} {
    @author Neophytos Demetriou
    @param keywords <b>NB:</b> keyword support is not currently implemented. Supplying keywords will not generate an error, but will have no effect.
} {

    set exists_p [db_0or1row exists_p {select 1 from txt where tid=:tid}]

    if {! $exists_p} {
	db_dml insert_tid {insert into txt (tid) values (:tid)}
    } else {
        openfts_driver__unindex $tid
    }

    array set idx [Search::OpenFTS::Index::new]
    catch { Search::OpenFTS::Index::index idx $tid $txt $title } 
    Search::OpenFTS::DESTROY

    return
}


ad_proc openfts_driver__unindex {
    tid
} {
    @author Neophytos Demetriou
} {
    array set idx [Search::OpenFTS::Index::new]

    Search::OpenFTS::Index::delete idx $tid
    Search::OpenFTS::DESTROY

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
    Search::OpenFTS::DESTROY

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

    if {[catch {set summary [Search::OpenFTS::get_headline fts opts]} errMsg]} {
        return "WARNING: summary create failed."
    }
    Search::OpenFTS::DESTROY

    return $summary
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








