/*******************************************************************************
                    Mediating Factors of Neighbors' Effects
                                Tables: X

*******************************************************************************/

*** Table X ******************************************************************
foreach var of varlist takes_psu2 active_cruch_o applyFA_o cutoff_o receives_funding_o g12_attendance_o g12_gpa_o score_rd_o cond_score_rd_o {

		di "******"
		di "`var'"
		di "****"
		local counter = `counter' + 1

		local if "Sample0 == 1 & `restriction' == 1 & km_to_code <= 0.15"

		local covs1  c.score_rd c.score_rd#1.cutoff
		local covs2  c.score_rd c.score_rd#c.score_rd c.score_rd#1.cutoff c.score_rd#c.score_rd#1.cutoff

		if `counter' == 1 local my_label "Takes the PSU"
    if `counter' == 2 local my_label "Active application to CRUCH universities"
    if `counter' == 3 local my_label "Applies for funding"
		if `counter' == 4 local my_label "Eligible for loan"
		if `counter' == 5 local my_label "Receives funding"

    if `counter' == 6  local my_label "Attendance in grade 12"
    if `counter' == 7  local my_label "GPA in grade 12"
    if `counter' == 8  local my_label "PSU score"
    if `counter' == 9  local my_label "PSU score  | Taking the PSU"

    label `var' "`my_label'"
    estimate_effects `var' score_rd cutoff uni 1 `bw11' `bw21' "" fid_2_o psu_year_o

}

#delimit;
tables "m1_takes_psu2 m1_active_cruch_o m1_applyFA_o m1_cutoff_o m1_receives_funding_o m1_g12_attendance_o m1_g12_gpa_o m1_score_rd_o m1_cond_score_rd_o"
"iv1_takes_psu2 iv1_active_cruch_o iv1_applyFA_o iv1_cutoff_o iv1_receives_funding_o iv1_g12_attendance_o iv1_g12_gpa_o iv1_score_rd_o iv1_cond_score_rd_o"
"fs1_takes_psu2 fs1_active_cruch_o fs1_applyFA_o fs1_cutoff_o fs1_receives_funding_o fs1_g12_attendance_o fs1_g12_gpa_o fs1_score_rd_o fs1_cond_score_rd_o"
score_rd "table10a";
#delimit cr
estimates drop _all
