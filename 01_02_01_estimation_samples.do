/*******************************************************************************

													ESTIMATION SAMPLE

*******************************************************************************/

*** Neighbors applying one year before the potential applicant:
*** Same logic applies to build all the other datasets used for neighbors.
forvalues x = 2007/2012{

	local y = `x' - 1

	use "${temp_path}${dash}v`x'_`y'.dta", clear

	*** Define as siblings individuals reporting the same id number for any of
	*** their parents. Allow for mistakes in reporting mother id number for the
	*** father and viceversa.
	generate siblings = 0
	replace  siblings = 1 if mrun_madre_o == mrun_madre & mrun_madre_o !=.
	replace  siblings = 1 if mrun_padre_o == mrun_padre & mrun_padre_o !=.
	replace  siblings = 1 if mrun_madre_o == mrun_padre & mrun_madre_o !=.
	replace  siblings = 1 if mrun_padre_o == mrun_madre & mrun_padre_o !=.

	*** Complement siblings definition using codes of lastnames:
	replace siblings  = paterno_code_o == paterno_code & materno_code_o == materno_code & paterno_code_o !=.
	generate cousins  = (paterno_code_o == paterno_code & paterno_code_o !=.) | (materno_code_o == materno_code & materno_code_o !=.) | (paterno_code_o == materno_code & paterno_code_o !=.) | (materno_code_o == paterno_code & materno_code_o !=.)

	drop if  mrun_o == mrun

	#delimit;
	gen Sample = applyFA == 1
	& siblings == 0
	& cousins  == 0
	& hs_graduation_year_o > hs_graduation_year
	& psu_age >= 17 & psu_age <= 22
	& ee != 1;
	#delimit cr

	*** Find closest neighbor satisfying the restrictions; in case of a tie use the
	*** one with the best performance:
	gen aux = km_to_code if siblings == 0 & cousins  == 0  & hs_graduation_year_o < hs_graduation_year & psu_age >= 17 & psu_age <= 22 & ee != 1 & applyFA == 1
	bys mrun_o: egen distance_rank = rank(aux), track
	bys mrun_o distance_rank: egen max_psu = max(score_rd)
	gen closest_neighbor = Sample == 1 & distance_rank == 1 & score_rd == max_psu
	drop max_psu aux
	keep if closest_neighbor == 1 & psu_age_o >= 17 & psu_age_o <= 22 & ee_o != 1
	save "${temp_path}${dash}closest_`x'_`y'.dta", replace
}

*** Append datasets ************************************************************
clear
forvalues x = 2007/2012 {

	local y = `x' - 1
	append using "${temp_path}${dash}closest_`x'_`y'.dta"

}

*** Apply final restrictions ***************************************************
** Years registered for the PSU
bys mrun_o: egen minPSU_o = min(psu_year_o)
bys mrun  : egen minPSU_n	= min(psu_year)

** Only work with first time potential applicant appears in the PSU:
keep if psu_year_o == minPSU_o
keep if minPSU_o   > minPSU_n
drop minPSU_o minPSU_n

*** Only work with the first time the neighbor takes the PSU
gen aux = psu_year if score_rd > -475
bys mrun: egen minPSU_n = min(aux)
keep if psu_year == minPSU_n
drop aux minPSU_n

*** Generate additional variables **********************************************
gen same_uni = uni_o == 1 & hei_name == hei_name_o
gen diff_uni = uni_o == 1 & hei_name != hei_name_o

gen uni_acc     = uni_o == 1 & acreditadaIES_o == "ACREDITADA"
gen uni_maj_acc = uni_o == 1 & acreditada_o    == "ACREDITADA"

generate enrolls_cruch_o = 0
replace enrolls_cruch_o = 1 if hei_name_o == "PONTIFICIA UNIVERSIDAD CATOLICA DE CHILE"
replace enrolls_cruch_o = 1 if hei_name_o == "PONTIFICIA UNIVERSIDAD CATOLICA DE VALPARAISO"
replace enrolls_cruch_o = 1 if hei_name_o == "UNIVERSIAD DE SANTIAGO"
replace enrolls_cruch_o = 1 if hei_name_o == "UNIVERSIDA DE CHILE"
replace enrolls_cruch_o = 1 if hei_name_o == "UNIVERSIDAD AUSTRAL DE CHILE"
replace enrolls_cruch_o = 1 if hei_name_o == "UNIVERSIDAD CATOLICA DE LA SANTISIMA CONCEPCION"
replace enrolls_cruch_o = 1 if hei_name_o == "UNIVERSIDAD CATOLICA DE TEMUCO"
replace enrolls_cruch_o = 1 if hei_name_o == "UNIVERSIDAD CATOLICA DEL MAULE"
replace enrolls_cruch_o = 1 if hei_name_o == "UNIVERSIDAD CATOLICA DEL NORTE"
replace enrolls_cruch_o = 1 if hei_name_o == "UNIVERSIDAD DE ANTOFAGASTA"
replace enrolls_cruch_o = 1 if hei_name_o == "UNIVERSIDAD DE ATACAMA"
replace enrolls_cruch_o = 1 if hei_name_o == "UNIVERSIDAD DE CHILE"
replace enrolls_cruch_o = 1 if hei_name_o == "UNIVERSIDAD DE CONCEPCION"
replace enrolls_cruch_o = 1 if hei_name_o == "UNIVERSIDAD DE LA FRONTERA"
replace enrolls_cruch_o = 1 if hei_name_o == "UNIVERSIDAD DE LA SERENA"
replace enrolls_cruch_o = 1 if hei_name_o == "UNIVERSIDAD DE LOS LAGOS"
replace enrolls_cruch_o = 1 if hei_name_o == "UNIVERSIDAD DE MAGALLANES"
replace enrolls_cruch_o = 1 if hei_name_o == "UNIVERSIDAD DE PLAYA ANCHA DE CIENCIAS DE LA EDUCACION"
replace enrolls_cruch_o = 1 if hei_name_o == "UNIVERSIDAD DE SANTIAGO DE CHILE"
replace enrolls_cruch_o = 1 if hei_name_o == "UNIVERSIDAD DE TALCA"
replace enrolls_cruch_o = 1 if hei_name_o == "UNIVERSIDAD DE TARAPACA"
replace enrolls_cruch_o = 1 if hei_name_o == "UNIVERSIDAD DE VALPARAISO"
replace enrolls_cruch_o = 1 if hei_name_o == "UNIVERSIDAD DEL BIO-BIO"
replace enrolls_cruch_o = 1 if hei_name_o == "UNIVERSIDAD METROPOLITANA DE CIENCIAS DE LA EDUCACION"
replace enrolls_cruch_o = 1 if hei_name_o == "UNIVERSIDAD TECNICA FEDERICO SANTA MARIA"
replace enrolls_cruch_o = 1 if hei_name_o == "UNIVERSIDAD TECNOLOGICA METROPOLITANA"

tab psu_year_o, gen(yr_)
gen cutoff = score_rd >= 0
gen cutoff_o = score_rd_o >= 0

label variable uni_o 						"Probability of enrolling in university"
label variable voc_o  					"Probability of enrolling in vocational higher ed."
label variable he_o   					"Probability of enrolling in higher ed."

label variable same_uni 				"Probability of enrolling in same university "
label variable diff_uni 				"Probability of enrolling in different university"
label variable enrolls_cruch_o 	"Probability of enrolling in CRUCH university"
label variable uni_acc 					"Probability of enrolling in accredited university"
label variable uni_maj_acc 			"Probability of enrolling in accredited program"

label variable retention_sys_o  "Probability of remaining in higher ed."
label variable retention_uni_o  "Probability of remaining in same university"
label variable retention_inst_o "Probability of remaining in any university"

label variable university_degree_o "Probability of completing university"
label variable any_degree_o	  		 "Probability of completing higher ed."

gen takes_psu2 = psu_reading_o > -4 & psu_reading_o !=. &	psu_math_o > -4 & psu_math_o !=. &	((psu_history_o > - 4 & psu_history_o !=.) | (psu_science_o > -4 & psu_science_o !=.))
gen cond_score_rd_o = score_rd_o if psu_reading_o > -4 & psu_reading_o !=. &	psu_math_o > -4 & psu_math_o !=.
gen receives_funding_o = cae1_o == 1 | beca1_o == 1 | fscu_o == 1
gen psu_male_o = 1 - psu_female_o
gen same_gender = psu_female == psu_female_o
gen ad = (psu_year_o - psu_age_o) - (psu_year - psu_age)
gen age_difference1 = ad == 1
replace age_difference =. if ad > 5

tab parental_ed, gen(pe_n)
label var  pe_n1 "Parental ed. = primary ed."
label var  pe_n2 "Parental ed. = secondary ed."
label var  pe_n3 "Parental ed. = other"
label var  pe_n4 "Parental ed. = vocational he"
label var  pe_n5 "Parental ed. = profesisonal he"
label var  pe_n6 "Parental ed. = university"
generate pe_n7 = pe_n4 == 1 | pe_n5 == 1
replace  pe_n7 = . if pe_n4 ==. | pe_n5 ==.
label var pe_n7 "Parental ed. = vocational he"

tab parental_ed_o, gen(pe_o)
label var  pe_o1 "Parental ed. = primary ed."
label var  pe_o2 "Parental ed. = secondary ed."
label var  pe_o3 "Parental ed. = other"
label var  pe_o4 "Parental ed. = vocational he"
label var  pe_o5 "Parental ed. = profesisonal he"
label var  pe_o6 "Parental ed. = university"
generate pe_o7 = pe_o4 == 1 | pe_o5 == 1
replace  pe_o7 = . if pe_o4 ==. | pe_o5 ==.
label var pe_o7 "Parental ed. = vocational he"

gen public_n = psu_dependence <= 2 | psu_dependence == 5
gen charter_n = psu_dependence == 3
gen private_n = psu_dependence == 4

label var  public_n "Public high school"
label var  charter_n "Charter high school"
label var  private_n "Private high school"

gen public_o  = psu_dependence_o == 1 | cod_depe_o == 1 | cod_depe_o == 2 | cod_depe_o == 5
gen charter_o = (psu_dependence_o == 2 | cod_depe_o == 3) & public_o != 1
gen private_o = (psu_dependence_o == 3 | cod_depe_o == 4) & public_o != 1 & charter_o != 1
replace public_o =. if psu_dependence_o ==. & cod_depe_o ==.
replace charter_o =. if psu_dependence_o ==. & cod_depe_o ==.
replace private_o =. if psu_dependence_o ==. & cod_depe_o ==.
label var  public_o "Public high school"
label var  charter_o "Charter high school"
label var  private_o "Private high school"

generate similar_ses = public_n == public_o & charter_n == charter_o & private_n == private_o & hc_o == hc & tp_o == tp
replace  similar_ses =. if public_n == . | public_o ==. | tp ==. | tp_o ==.
label variable similar_ses "Similar SES = 1"

gen hh_father_n = hh == 1
gen hh_mother_n = hh == 2
gen hh_applicant_n = hh == 3
gen hh_other_n = hh >= 4 & hh <=8

foreach var of varlist hh_father_n hh_mother_n hh_applicant_n hh_other_n {

	replace `var' =. if hh == 0
}

label var hh_father_n "Household head = father"
label var hh_mother_n "Household head = mother"
label var hh_applicant_n "Household head = applicant"
label var hh_other_n "Household head = other"

en hh_father_o = hh_o == 1
gen hh_mother_o = hh_o == 2
gen hh_applicant_o = hh_o == 3
gen hh_other_o = hh_o >= 4 & hh_o <=8

foreach var of varlist hh_father_o hh_mother_o hh_applicant_o hh_other_o {

	replace `var' =. if hh_o == 0
}

label var hh_father_o "Household head = father"
label var hh_mother_o "Household head = mother"
label var hh_applicant_o "Household head = applicant"
label var hh_other_o "Household head = other"

gen single  	= civil_status == 1
gen married 	= civil_status == 2
gen divorced 	= civil_status == 3
gen widow    	= civil_status == 4

foreach var of varlist single married divorced widow {

	replace `var' = . if `var' == 0
}

label var  single 	"Single"
label var  married  "Married"
label var  divorced "Divorced"
label var  widow 	"Widow"

gen single_o  	= civil_status_o == 1
gen married_o 	= civil_status_o == 2
gen divorced_o 	= civil_status_o == 3
gen widow_o    	= civil_status_o == 4

foreach var of varlist single_o married_o divorced_o widow_o {

	replace `var' = . if `var' == 0
}

label var  single_o 	"Single"
label var  married_o  "Married"
label var  divorced_o "Divorced"
label var  widow_o 	  "Widow"

en private_hi_n = health_insurance == 1
gen public_hi_n  = health_insurance == 2
gen other_hi_n   = health_insurance >= 3 & health_insurance <= 5

foreach var of varlist private_hi_n public_hi_n other_hi_n {
		replace `var' =. if health_insurance ==.
}

label var  private_hi_n "Health insurance = private"
label var  public_hi_n  "Health insurance = public"
label var  other_hi_n   "Health insurance = other"

generate  paid_job_n = work == 2 | work == 3
replace   paid_job_n = . if work == 0
label var paid_job_n "Has a paid job"
drop work
rename paid_job_n work

gen private_hi_o = health_insurance_o == 1
gen public_hi_o  = health_insurance_o == 2
gen other_hi_o   = health_insurance_o >= 3 & health_insurance_o <= 5

foreach var of varlist private_hi_o public_hi_o other_hi_o {
	replace `var' =. if health_insurance_o ==.
}

label var  private_hi_o  "Health insurance = private"
label var  public_hi_o   "Health insurance = public"
label var  other_hi_o    "Health insurance = other"

generate paid_job_o = work_o == 2 | work_o == 3
replace  paid_job_o = . if work_o == 0 | work_o ==.
label var  paid_job_o "Has a paid job"
drop work_o
rename paid_job_o work_o

gen both_alive_n = parents_alive == 1
gen father_alive_n = parents_alive == 3
gen mother_alive_n = parents_alive == 2
gen none_alive_n   =  parents_alive == 4

foreach var of varlist both_alive_n father_alive_n mother_alive_n none_alive_n{

		replace `var' = . if parents_alive == . | parents_alive == 0
}

label var both_alive_n "Both parents alive"
label var father_alive_n  "Just father alive"
label var mother_alive_n  "Just mother alive"
label var none_alive_n    "Both parents are deadth"

gen both_alive_o = parents_alive_o == 1
gen father_alive_o = parents_alive_o == 3
gen mother_alive_o = parents_alive_o == 2
gen none_alive_o   =  parents_alive_o == 4

foreach var of varlist both_alive_n father_alive_o mother_alive_o none_alive_o {

		replace `var' = . if parents_alive_o == . | parents_alive_o == 0
}

label var both_alive_o "Both parents alive"
label var father_alive_o  "Just father alive"
label var mother_alive_o  "Just mother alive"
label var none_alive_o    "Both parents are deadth"

gen live_parents_n = live_with == 1
gen live_relatives_n = live_with == 2
gen live_independently_n =live_with == 3
gen live_others_n = live_with >= 4 & live_with <= 5

foreach var of varlist live_parents_n live_relatives_n live_independently_n live_others_n {
		replace `var' =. if live_with == 0
}

label var live_parents_n "Will live with parents"
label var live_relatives_n "Will live with relatives"
label var live_independently_n "Will live independently"
label var live_others_n "Other arrangement"

gen live_parents_o = live_with_o == 1
gen live_relatives_o = live_with_o == 2
gen live_independently_o =live_with_o == 3
gen live_others_o = live_with_o >= 4 & live_with_o <= 5

foreach var of varlist live_parents_o live_relatives_o live_independently_o live_others_o {
	replace `var' =. if live_with_o == 0 | live_with_o ==.
}

label var live_parents_o 				"Will live with parents"
label var live_relatives_o 			"Will live with relatives"
label var live_independently_o 	"Will live independently"
label var live_others_o 				"Other arrangement"

generate mother_housewife = situacion_ocupacional_madre == 6
replace  mother_housewife = . if situacion_ocupacional_madre ==0 | situacion_ocupacional_madre ==.
label variable mother_housewife "Mother does not work outside hh. = 1"

generate old_neighbor_o = g9_municipality_o == psu_municipality_o | g9_municipality_name_o == psu_municipality_name_o
replace  old_neighbor_o = . if (g9_municipality_o ==. & g9_municipality_name_o == "") | (psu_municipality_o ==. & psu_municipality_name_o =="")
label variable old_neighbor_o "Time at the neighborhood ≥ 4 years"

generate neighbor_remains = 1 if live_with == 1
replace  neighbor_remains = 0 if live_with > 1
replace  neighbor_remains =. if live_with ==. | none_alive_n == 0
label variable neighbor_remains "Neighbor remains in the neighborhood = 1"

gen 	  positive_difference = 1 if g12_gpa_o - g12_gpa >= 0 & g12_gpa !=. & g12_gpa_o !=.
replace positive_difference = 0 if g12_gpa_o - g12_gpa < 0  & g12_gpa !=. & g12_gpa_o !=.
label   variable positive_difference "∆GPA ≥ 0"

gen 	  negative_difference = 1 - positive_difference
label   variable negative_difference "∆GPA < 0"


#delimit;
keep mrun	psu_year	mrun_o	psu_year_o code_o	yr_1	yr_2	yr_3	yr_4	yr_5	yr_6	score_rd
cutoff	uni	fid_2_o	psu_municipality_o	psu_region_o uni_o	he_o	voc_o	uni_acc	enrolls_cruch_o
uni_maj_acc	same_uni	diff_uni	retention_inst_o	retention_uni_o	university_degree_o	any_degree_o
takes_psu2	active_cruch_o	applyFA_o	cutoff_o	receives_funding_o	g12_attendance_o	g12_gpa_o	score_rd_o
cond_score_rd_o	loans	psu_female	psu_female_o	psu_male_o	psu_age	psu_age_o	ad	pe_n1	pe_n2	pe_n3	pe_n4	pe_n5	pe_n6	pe_n7
pe_o1	pe_o2	pe_o3	pe_o4	pe_o5	pe_o6	pe_o7	lowIncome_o	midIncome_o	highIncome_o
lowIncome	midIncome	highIncome	psu_rbd_o	public_n	charter_n	private_n	public_o	charter_o	private_o
hc_o	tp_o	hc	tp	g12_gpa	g9_gpa_o	family_group	family_group_o	family_group_work	family_group_work_o
family_group_he	family_group_he_o	hh_father_n	hh_mother_n	hh_applicant_n	hh_father_o	hh_mother_o	hh_applicant_o
work	work_o	single	single_o	private_hi_n	public_hi_n	private_hi_o	public_hi_o	both_alive_n	father_alive_n
mother_alive_n	none_alive_n	both_alive_o	father_alive_o	mother_alive_o	none_alive_o	live_parents_n	live_relatives_n
live_independently_n	live_parents_o	live_relatives_o	live_independently_o	km_to_code	similar_ses2	same_gender	age_difference1
old_neighbor_o	neighbor_remains	mother_housewife	positive_difference	negative_difference;
#delimit cr

rename code_o code
forvalues x = 2007/2012 {
		di "`x'"
		merge 1:1 code using "${input_path}${dash}mc_`x'.dta", keepusing(latitud longitud) update
		drop if _merge == 2
		drop _merge
}

cluster kmeans latitud longitud, k(1150) measure(L2) start(krandom(0.27))
rename _clus_1 neighborhood_id
rename neighborhood_id neighborhood_ido

*** Add information of neighborhoods:
merge m:1 neighborhood_ido using "${input_path}${dash}shares_neighborhoods.dta"
drop if _merge == 2
drop _merge

*** Levels of attendance:
generate att1 = 1 if sh_uni < 0.435	//bottom third
replace  att1 = 2 if sh_uni < 0.61	& att1 ==.  //mid third
replace  att1 = 3 if sh_uni < 1.01  & att1 ==. //top third
drop code

compress
save "${temp_path}${dash}aej_closest_neighbor1.dta", replace
