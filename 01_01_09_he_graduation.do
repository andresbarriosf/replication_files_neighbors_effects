/*******************************************************************************

							               HE GRADUATES

		Individuals completing higher education between 2006-2018

*******************************************************************************/
forvalues x = 2007/2019 {

	import delimited "${input_path}${dash}Titulados_Educacion_Superior_`x'.csv", delimiter(";") varnames(1) encoding(utf-8) clear

	keep mrun tipo_inst_1 nivel_carrera_2
	gen graduation_year = `x'

	gen university_degree = tipo_inst_1 == "UNIVERSIDADES" & nivel_carrera_2 == "CARRERAS PROFESIONALES"
	gen vocational_degree = university_degree == 0 & tipo_inst_1 != ""
	gen any_degree        = university_degree == 1 | vocational_degree == 1

	bys mrun: egen uni = max(university_degree)
	duplicates tag mrun, gen(rep)
	drop if rep >= 1 & uni == 1 & university_degree == 0

	drop rep uni
	duplicates drop mrun, force
	drop tipo_inst_1

	destring mrun, replace force
	save "${temp_path}${dash}he_graduates`x'.dta", replace

}
