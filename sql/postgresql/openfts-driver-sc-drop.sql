select acs_sc_binding__delete(
           'FtsEngineDriver',			-- contract_name
	   'openfts-driver'			-- impl_name
);


select acs_sc_impl__delete(
           'FtsEngineDriver',			-- impl_contract_name
	   'openfts-driver'			-- impl_name
);
