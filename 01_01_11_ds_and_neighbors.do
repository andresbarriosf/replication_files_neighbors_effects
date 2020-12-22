/*******************************************************************************

							COMBINE EDUCATION RECORDS WITH NEIGHBORS INFORMATION

*******************************************************************************/
cd "${temp_path}"

forvalues t = -6/6 {

	if `t' == -6 local min = 2012
	if `t' == -5 local min = 2011
	if `t' == -4 local min = 2010
	if `t' == -3 local min = 2009
	if `t' == -2 local min = 2008
	if `t' == -1 local min = 2007
	if `t' >= 0  local min = 2006

	if `t' <= 0  local max = 2012
	if `t' == 1  local max = 2011
	if `t' == 2  local max = 2010
	if `t' == 3  local max = 2009
	if `t' == 4  local max = 2008
	if `t' == 5  local max = 2007
	if `t' == 6  local max = 2006

	*** x is the year of the potential applicant
	forvalues x = `min'/`max' {

		*** y is the year of the neighbor
		local y = `x' + `t'

		use "v`x'_`y'.dta", clear

		*** A. Add variables of applicants:
		rename(mrun_o mrun)(mrun mrun_n)
		merge m:1 mrun using "dataset`x'.dta", update
		drop if _merge == 2
		drop _merge
		rename(mrun mrun_n)(mrun_o mrun)

		#delimit;
		renvarlab psu_female psu_age psu_year score_rd psu_gpa psu_nem psu_rank
		psu_reading psu_math psu_history psu_science psu_previous
		psu_rbd hs_graduation_year psu_dependence psu_ed_track psu_region psu_municipality psu_municipality_name
		bea civil_status work live_with family_group family_group_work hh family_group_he health_insurance parents_alive parental_ed
		lowIncome midIncome highIncome situacion_ocupacional_madre mrun_padre mrun_madre paterno_code materno_code
		situacion_postulante applies_cruch active_cruch hei_name duracion_carr duracion_tit duracion_total
		nivel_1 matricula arancel area_conocimiento oecd_area oecd_subarea acreditada acreditada_agnos acreditadaIES
		uni voc he ties1 nom_ies retention_sys retention_uni retention_inst university_degree any_degree
		quintil_fuas fscu cae1 cae2 beca1 beca2 applyFA loans
		g12_municipality g12_municipality_name g12_rbd cod_depe cod_ense g12_gpa g12_attendance
		hc tp ee
		g9_rbd g9_gpa g9_attendance rank_g9 g9_percentile g9_decile g9_veintile g9_municipality g9_municipality_name, postfix(_o);
		#delimit cr

		*** B. Add variables of neighbors:
		#delimit;
		merge m:1 mrun using "dataset`y'.dta", update
		keepusing(mrun psu_female psu_age psu_year score_rd psu_gpa psu_nem psu_rank psu_reading psu_math psu_history psu_science psu_previous
		psu_rbd hs_graduation_year psu_dependence psu_ed_track psu_region psu_municipality psu_municipality_name bea civil_status work
		live_with family_group family_group_work hh family_group_he health_insurance parents_alive parental_ed
		lowIncome midIncome highIncome mrun_padre mrun_madre paterno_code materno_code
		hei_name area_conocimiento oecd_area oecd_subarea
		uni voc he  ties1 nom_ies fscu cae1 cae2 beca1 beca2
		applyFA loans g12_municipality g12_municipality_name g12_rbd g12_gpa g12_attendance
		hc tp ee g9_rbd g9_gpa g9_attendance rank_g9 g9_percentile g9_decile g9_veintile g9_municipality g9_municipality_name);
		#delimit cr

		drop if _merge == 2
		drop _merge
		compress
		save "v`x'_`y'.dta", replace

	}
}
