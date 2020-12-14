/*******************************************************************************
                    Mediating Factors of Siblings' Effects
                                Table: X

*******************************************************************************/

*** Table X ******************************************************************
foreach var of varlist takes_psu2 activeCRUCH applyFA_y cutoff_o receivedFA2_y asistencia hs_gpa12_y psuRD_y psuRD2_y  {

		di "******"
		di "`var'"
		di "****"
		local counter = `counter' + 1

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
    estimate_effects `var' score_rd_o cutoff_o uni_o 1 `bw11' `bw21' "& Sample = 1" family psu_year_y

}

tables "m1_*" "iv1_*" "fs1_*" score_rd_o "table10b"
estimates drop _all
