/*******************************************************************************
                    Mediating Factors of Siblings' Effects
                                Table: X

*******************************************************************************/
local bw11 = 37.07
local bw21 = 74.51

*** Table X ******************************************************************
foreach var of varlist takes_psu2 active_cruch_y applyFA_y cutoff_y received_funding_y g12_attendance_y hs_gpa12_y score_rd_y cond_score_rd_y  {


	local counter = `counter' + 1


	if `counter' == 1 local my_label "Takes the PSU"
	if `counter' == 2 local my_label "Active application to CRUCH universities"
	if `counter' == 3 local my_label "Applies for funding"
	if `counter' == 4 local my_label "Eligible for loan"
	if `counter' == 5 local my_label "Receives funding"

    if `counter' == 6  local my_label "Attendance in grade 12"
    if `counter' == 7  local my_label "GPA in grade 12"
    if `counter' == 8  local my_label "PSU score"
    if `counter' == 9  local my_label "PSU score  | Taking the PSU"

    label variable `var' "`my_label'"
    estimate_effects `var' score_rd_o cutoff_o uni_o 1 `bw11' `bw21' "& Sample == 1" family psu_year_y

}

tables "m1_*" "iv1_*" "fs1_*" score_rd_o "table10b"
estimates drop _all
