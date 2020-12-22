/*******************************************************************************

							         ENROLLMENT IN HIGHER EDUCATION

				        Enrollment in higher education between 2006-2016.

*******************************************************************************/

*** (1.1) Enrollment between 2006 and 2016 *************************************
forvalues x = 2006/2016{

	use "${input_path}${dash}matriculados`x'.dta", clear
	keep codigo_unico mrun sexo edad agno_ingreso agno_carrera

	merge m:1 codigo_unico using "${input_path}${dash}matricula`x'.dta"
	drop if _merge == 2
	drop _merge

	keep if nivel_global == "Pregrado"
	drop if nivel_2 == "Magister" | nivel_2 == "Doctorado" | nivel_2 == "Postitulo"

	#delimit;
	keep codigo_unico mrun sexo edad agno_ingreso agno_carrera
	ties1 ties2 ties3 cod_ies nom_ies cod_sede nom_sede
	cod_carrera nom_carrera jornada plan_carrera
	duracion_carr duracion_tit duracion_total
	region_sede comuna_sede ciudad_sede
	nivel_global nivel_1 nivel_2 area_conocimiento oecd_area oecd_subarea
	matricula arancel codigo_demre acreditada acreditada_agnos acreditadaIES;
	#delimit cr;

	drop if mrun == ""

	* Dealing with duplicates:
	duplicates tag mrun, gen(rep)

	* When having repeated observations, we will check if students are starting
	* a program this year. We will keep this observation if exist.
	gen year1 = agno_ingreso == `x'
	bys mrun: egen year2 = max(year1)
	drop if rep >= 1 & year1 == 0 & year2 == 1
	drop rep year1 year2

	* We will eliminate the rest of duplicates randomly:
	duplicates drop mrun, force
	destring mrun, replace

	compress
	save "${temp_path}${dash}enrollmentHE_`x'.dta", replace
}
