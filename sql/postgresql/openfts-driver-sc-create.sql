--
-- ACS-SC Implementation
--

select acs_sc_impl__new(
	   'FtsEngineDriver',               	-- impl_contract_name
           'openfts-driver',                    -- impl_name
	   'openfts-driver'                     -- impl_owner_name
);


select acs_sc_impl_alias__new(
           'FtsEngineDriver',			-- impl_contract_name
           'openfts-driver',			-- impl_name
	   'search', 				-- impl_operation_name
	   'openfts_driver__search',   		-- impl_alias
	   'TCL'    				-- impl_pl
);


select acs_sc_impl_alias__new(
           'FtsEngineDriver',			-- impl_contract_name
           'openfts-driver',			-- impl_name
	   'index', 				-- impl_operation_name
	   'openfts_driver__index',    		-- impl_alias
	   'TCL'    				-- impl_pl
);



select acs_sc_impl_alias__new(
           'FtsEngineDriver',			-- impl_contract_name
           'openfts-driver',			-- impl_name
	   'unindex', 				-- impl_operation_name
	   'openfts_driver__unindex',  		-- impl_alias
	   'TCL'    				-- impl_pl
);


select acs_sc_impl_alias__new(
           'FtsEngineDriver',			-- impl_contract_name
           'openfts-driver',			-- impl_name
	   'update_index',			-- impl_operation_name
	   'openfts_driver__update_index',	-- impl_alias
	   'TCL'    				-- impl_pl
);


select acs_sc_impl_alias__new(
           'FtsEngineDriver',			-- impl_contract_name
           'openfts-driver',			-- impl_name
	   'summary',				-- impl_operation_name
	   'openfts_driver__summary',  		-- impl_alias
	   'TCL'    				-- impl_pl
);


select acs_sc_impl_alias__new(
           'FtsEngineDriver',				-- impl_contract_name
           'openfts-driver',				-- impl_name
	   'info',					-- impl_operation_name
	   'openfts_driver__info',			-- impl_alias
	   'TCL'					-- impl_pl
);
