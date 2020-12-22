/*******************************************************************************

									PREPARATION OF DATASETS BY YEAR

	I. Put together all the academic and ses data for a given year:

	1.1 PSU files: scores, ses, applications.
	1.2 Enrollment files (enrollment and retention).
	1.3 Graduation files.
	1.4 Funding files.
	1.5 High school files.

*******************************************************************************/
cd "${temp_path}"

forvalues x = 2006/2012 {

	*** (1) Scores *************************************************************
	use psu_scores`x'.dta, clear

	*** (1.1) Fixing Scores
	gen score_rd = promlm_actual/10 - 475

	local counter = 0
	foreach var of varlist ptje_nem ptje_ranking lyc_actual mate_actual hycs_actual ciencias_actual promedio_notas {

		local counter = `counter' + 1

		if `counter' == 1 local text "psu_nem"
		if `counter' == 2 local text "psu_rank"
		if `counter' == 3 local text "psu_reading"
		if `counter' == 4 local text "psu_math"
		if `counter' == 5 local text "psu_history"
		if `counter' == 6 local text "psu_science"
		if `counter' == 7 local text "psu_gpa"

		gen aux  = `var' if `var' > 0
		egen avg = mean(aux)
		egen sd  = sd(aux)

		gen `text' = (`var' - avg)/sd
		drop aux avg sd
	}

	rename psu_anterior psu_previous
	rename año_proceso  psu_year

	*** (1.2) SES:
	generate psu_female = cod_sexo == 2
	replace  psu_female = . if cod_sexo ==. | cod_sexo < 1 | cod_sexo > 2

	generate psu_age = substr(fecha_nacimiento, -4,4)
	destring psu_age, replace
	replace  psu_age = `x' - psu_age
	replace  psu_age =. if psu_age >= 15 & psu_age <= 85

	rename año_egreso hs_graduation_year

	generate psu_dependence = 1 if grupo_dependencia == 1 | grupo_dependencia == 2 | grupo_dependencia == 5
	replace  psu_dependence = 2 if grupo_dependencia == 3
	replace  psu_dependence = 3 if grupo_dependencia == 4

	rename rama_educacional psu_ed_track
	rename (codigo_region codigo_comuna nombre_comuna)(psu_region psu_municipality psu_municipality_name)

	order mrun psu_female psu_age psu_year score_rd psu_gpa psu_nem psu_rank psu_reading psu_math psu_history psu_science psu_previous ///
	rbd hs_graduation_year psu_dependence psu_ed_track psu_region psu_municipality psu_municipality_name bea

	keep mrun psu_female psu_age psu_year score_rd psu_gpa psu_nem psu_rank psu_reading psu_math psu_history psu_science psu_previous ///
	rbd hs_graduation_year psu_dependence psu_ed_track psu_region psu_municipality psu_municipality_name bea

	rename rbd psu_rbd

	*** (2) SES  ***************************************************************
	merge 1:1 mrun using "psu_ses`x'.dta", keepusing(estado_civil tiene_trabajo_rem de_proseguir_estudios grupo_familiar cuantos_trabajan_del_grupo_famil quien_es_el_jefe_familia fg_higherEd cobertura_salud viven_sus_padres parental_ed lowIncome midIncome highIncome codigo_region codigo_comuna nombre_comuna situacion_ocupacional_madre)
	drop if _merge == 2
	drop _merge

	#delimit;
	rename(estado_civil tiene_trabajo_rem de_proseguir_estudios grupo_familiar
	cuantos_trabajan_del_grupo_famil quien_es_el_jefe_familia fg_higherEd
	cobertura_salud viven_sus_padres)
	(civil_status work live_with family_group family_group_work hh family_group_he
	health_insurance parents_alive);
	#delimit cr

	replace psu_region 				= codigo_region if codigo_region != 0 & codigo_region !=.
	replace psu_municipality 		= codigo_comuna if codigo_comuna != 0 & codigo_comuna !=.
	replace psu_municipality_name	= nombre_comuna if nombre_comuna != ""
	drop codigo_comuna codigo_region nombre_comuna

	*** (3) PARENTS
	merge 1:1 mrun using "${input_path}${dash}mrunParents`x'.dta"
	drop if _merge == 2
	drop _merge

	merge m:1 mrun using "psu_siblings`x'.dta"
	drop if _merge == 2
	drop _merge

	*** (4) APPLICATIONS TO COLLEGE  *******************************************
	merge 1:1 mrun using "psu_application`x'.dta", keepusing(situacion_postulante)
	drop if _merge == 2
	drop _merge

	gen applies_cruch = situacion_postulante == "P" | situacion_postulante == "C"
	gen active_cruch  = situacion_postulante == "P"

	*** (5) ENROLLMENT *********************************************************
	merge 1:1 mrun using "enrollmentHE_`x'.dta", keepusing(sexo agno_ingreso agno_carrera ties1 nom_ies duracion_carr duracion_tit duracion_total nivel_1 matricula arancel area_conocimiento oecd_area oecd_subarea acreditada acreditada_agnos acreditadaIES)
	drop if _merge == 2
	drop _merge

	replace psu_female = 1 if sexo == "M" & psu_female ==.
	replace psu_female = 0 if sexo == "H" & psu_female ==.
	drop sexo

	rename (agno_ingreso agno_carrera nom_ies)(enrollment_year major_enrollment_year hei_name)

	gen uni = ties1 == "Universidades" & nivel_1 != "Técnico de Nivel Superior" & (enrollment_year == `x' | major_enrollment_year == `x')
	gen voc = ties1 == "Institutos Profesionales" | ties1 == "Centros de Formación Técnica" | nivel_1 == "Técnico de Nivel Superior" & (enrollment_year == `x' | major_enrollment_year == `x')
	gen he  = uni == 1 | voc == 1
	drop ties1 enrollment_year major_enrollment_year

	*** (6) RETENTION **********************************************************
	local y = `x' + 1
	merge 1:1 mrun using "enrollmentHE_`y'.dta", keepusing(ties1 nom_ies)
	drop if _merge == 2
	drop _merge

	gen retention_sys  = he  == 1 & ties1 != ""
	gen retention_uni  = uni == 1 & ties1 == "Universidades"

	clean_name hei_name
	clean_name nom_ies
	gen retention_inst = hei_name == nom_ies & hei_name != ""

	*** (7) GRADUATION *********************************************************
	gen graduates_uni = 0
	gen graduates_voc = 0
	gen graduates_he  = 0

	local min = `x' + 1
	local max = `x' + 7

	forvalues y = `min'/`max' {

		merge 1:1 mrun using "he_graduates`y'.dta", keepusing(university_degree vocational_degree any_degree)
		drop if _merge == 2
		drop _merge

		replace graduates_uni = 1 if university_degree == 1
		replace graduates_voc = 1 if vocational_degree == 1
		replace graduates_he  = 1 if any_degree == 1
		drop university_degree vocational_degree any_degree
	}

	*** (8) FUNDING ************************************************************
	merge 1:1 mrun using "beneficios`x'.dta", keepusing(quintil_fuas fscu cae1 cae2 beca1 beca2)
	drop if _merge == 2
	gen applyFA = 1 if _merge == 3
	drop _merge

	foreach var of varlist fscu cae1 cae2 beca1 beca2 {

		replace `var' = 0 if `var' ==.
	}

	gen loans = fscu == 1 | cae2 == 1

	*** (9) HIGH SCHOOL TRAJECTORY *********************************************

	*** (9.1) Grade 12:
	local min = `x' - 3
	local max = `x' - 1

	local c = 0
	forvalues y = `min'/`max' {

		local c = `c' + 1

		if `y' != 2004 & `y' != 2006 {

			merge 1:1 mrun using egresadosHS_`y'.dta, keepusing(gen_alu fec_nac_alu cod_com_alu nom_com_alu rbd cod_depe cod_ense prom_gral asistencia año_egreso) update replace
			gen yob`c' = substr(fec_nac_alu, 1, 4)
			drop fec_nac_alu
		}

		if `y' == 2004 | `y' == 2006 {

			merge 1:1 mrun using egresadosHS_`y'.dta, keepusing(gen_alu fec_nac_alu rbd cod_depe cod_ense prom_gral asistencia año_egreso) update replace
			split fec_nac_alu, gen(y)
			drop fec_nac_alu
			gen yob`c' = y3
			drop y1 y2 y3 y4
		}

		destring yob`c', replace
		drop if _merge == 2
		drop _merge

	}

	replace psu_female = 1 if gen_alu == 2 & psu_female ==.
	replace psu_female = 0 if gen_alu == 1 & psu_female ==.
	drop gen_alu

	replace  yob1 = yob2 if yob1 ==. & yob2 !=.
	replace  yob1 = yob3 if yob1 ==. & yob3 !=.
	replace psu_age = `x' - yob1 if yob1 !=.
	drop yob1 yob2 yob3

	rename (cod_com_alu nom_com_alu)(g12_municipality g12_municipality_name)
	rename rbd g12_rbd

	replace psu_dependence = 1 if cod_depe == 1 | cod_depe == 2 | cod_depe == 5
	replace psu_dependence = 2 if cod_depe == 2
	replace psu_dependence = 3 if cod_depe == 4

	gen hc = cod_ense == 310
	gen tp = cod_ense == 410 | cod_ense == 510 | cod_ense == 610 | cod_ense == 710 | cod_ense == 810 | cod_ense == 910
	gen ee = cod_ense !=. & hc == 0 & tp == 0

	rename asistencia g12_attendance
	rename prom_gral  g12_gpa

	replace hs_graduation_year = año_egreso if año_egreso !=.
	drop año_egreso

	*** (9.2) Grade 9:
	local min = `x' - 6
	local max = `x' - 3

	forvalues y = `min'/`max' {

		if `y' != 2004 & `y' != 2006 merge 1:1 mrun using grade9_`y'.dta, keepusing(rbd cod_com_alu nom_com_alu prom_gral asistencia rank_g9 percentile decile veintile) update
		if `y' == 2004 | `y' == 2006 merge 1:1 mrun using grade9_`y'.dta, keepusing(rbd prom_gral asistencia rank_g9 percentile decile veintile) update

		drop if _merge == 2
		drop _merge
	}

	rename (cod_com_alu nom_com_alu)(g9_municipality g9_municipality_name)
	rename rbd g9_rbd
	rename asistencia g9_attendance
	rename prom_gral  g9_gpa
	renvarlab percentile decile veintile, prefix(g9_)

	save "dataset`x'.dta", replace
}
