/*******************************************************************************

								              PSU SIBLINGS

	  Generate datasets with parents identifiers. Add as well other family
	  identifiers.

*******************************************************************************/
forvalues x = 2004/2012 {

		use "${input_path}${dash}psu_siblings`x'.dta"
		keep mrun paterno_code materno_code mrun_padre mrun_madre
		destring mrun* paterno_code materno_code, replace

		compress
		save "${temp_path}${dash}psu_siblings`x'.dta", replace
}
