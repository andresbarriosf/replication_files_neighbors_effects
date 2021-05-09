/*******************************************************************************

				Matching Neighborhood Units and Individuals

*******************************************************************************/

clear
set more off
set seed 1000

shp2dta using "${input_path}${dash}unidades_vecinales_2017.shp", database(db_nunits) coordinates (coords_nunits)

*** Import coordinates:
forvalues x = 2006/2012{

	import delimited "${input_path}${dash}students_addresses_out`x'.csv", clear
	rename (latitude longitude)(latitud longitud)
	keep if latitud !=. & longitud !=.
	keep mrun code latitud longitud proceso_dir egreso_dir

	*** Match coordinates to neighborhood unit:
	geoinpoly latitud longitud using "${input_path}${dash}coords_nunits.dta", unique
	rename _ID fid_2

	save "${input_path}${dash}mc_`x'.dta", replace 
}
