ad_after_server_initialization search_engine_driver {

   set package_id [apm_package_id_from_key openfts-driver]

   set openfts_tcl_src_path [ad_parameter -package_id $package_id openfts_tcl_src_path search-engine-openfts /usr/local/src/Search-OpenFTS-tcl-0.1]

   set files [glob -nocomplain "${openfts_tcl_src_path}/fts_*.tcl"]

   if { [llength $files] == 0 } {
       error "Unable to locate $openfts_tcl_src_path."
   }
   ns_log Debug "search_engine_driver: sourcing files from ${openfts_tcl_src_path}"
   foreach file [lsort $files] {
      source $file
   }
}
