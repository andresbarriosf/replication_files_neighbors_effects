/*******************************************************************************
                          Siblings' Robustness Checks
                                Tables: D3 (or J1)
                        Figures: C2, C4, C6, C7b, C9, D2.
*******************************************************************************/

*** Figure C1  *****************************************************************
#delimit;
rddensity score_rd_o if Sample1 == 1 & score_rd_o >-475, c(0) p(2) q(3)
fitselect(unrestricted) kernel(triangular)
bwselect(comb) vce(jackknife) plot
plot_range(-125 100)
plot_grid(es) level(95)
graph_options(
ytitle("Density") ytitle(, size(small) orientation(vertical))
yscale(range(0 0.005)) ylabel(0(0.001)0.005 , labels labsize(vsmall) labcolor(black) angle(horizontal) format(%04.3f))
xtitle(Sibling's PSU Average Score (Reading and Math)) xtitle(, size(small))
xlabel(-125(25)100, labsize(vsmall))
);
#delimit cr

/*
-----------------------------------------------
            Method |          T        P>|T|
-------------------+---------------------------
            Robust |      0.2399      0.8104
-----------------------------------------------
*/

graph save "figureC2.gph", replace
graph export "figureC2.pdf", replace as(pdf)

*** Figure C3  *****************************************************************

*** Applicants
#delimit;
local my_vars1 female_y age_y Single_y
LowIncome_y MidIncome_y HighIncome_y
paid_job_y workers_y
pe_y1 pe_y2 pe_y4 pe_y5 pe_y6
public_y charter_y private_y HC_y hs_gpa9_y
family_size_y
hh_father_y hh_mother_y
live_parents_y live_relatives_y live_independently_y;
#delimit cr

*** Sibling
#delimit;
local my_vars2 female_o age_o Single_o
LowIncome_o MidIncome_o HighIncome_o
paid_job_o workers_o
pe_o1 pe_o2 pe_o4 pe_o5 pe_o6
public_o charter_o private_o HC_o hs_gpa12_o
family_size_o
hh_father_o hh_mother_o
live_parents_o live_relatives_o live_independently_o;
#delimit cr

local counter = 0
foreach var of varlist `my_vars1'{

    local counter = `counter' + 1
    local vtext1: variable label `var'
    coefficients_for_plots `x' score_rd_o cutoff_o uni_o 1 `bw11' `bw21' "& Sample == 1" family psu_year_y "rf" `counter' "`vtext1'"
}

coefficients_plots "rf" "horizontal" "figureC4a"
estimates drop _all

local counter = 0
foreach var of varlist `my_vars2'{

    local counter = `counter' + 1
    local vtext1: variable label `var'
    coefficients_for_plots `x' score_rd_o cutoff_o uni_o 1 `bw11' `bw21' "& Sample == 1" family psu_year_y "rf" `counter' "`vtext1'"
}

coefficients_plots "rf" "horizontal" "figureC4b"
estimates drop _all

*** Figure C6  *****************************************************************
tab psu_year_o, gen(yro_)

#delimit;
rdrobust uni_o score_rd_y if  uni_o !=. & Sample1 == 1,
c(0) fuzzy(uni_y) deriv(0) p(1) q(2) kernel(uniform)
covs(yro_2 yro_3 yro_4 yro_5 yro_6 yro_7 yro_8 yro_9)
bwselect(msetwo) vce(cluster mrun_madre) level(95) all;
#delimit cr;

local bw1 = round(e(h_l), 5)
local bw2 = round(e(h_r), 5)

reduced_form_plot uni_o 1 score_rd_y cutoff_y `bw1' `bw2' 5 5.5 "& Sample = 1" family psu_year_o 9 "figureC6"

*** Figure C7  *****************************************************************
local contador = 0
foreach num of numlist  0 25 50 75 100 125 150 175 200 {

		local contador = `contador' + 1

    if `num' == 0 {
			local bw1 = `bw11'
			local bw2 = `bw21'
		}

		if `num' > 0 {
			local bw1 = min(`bw11', `num')
			local bw2 = `bw21'
		}

		gen score_rd_aux  = score_rd_o - `num'
		gen cutoff_aux 	  = score_rd_aux >= 0

    coefficients_for_plots uni_y score_rd_aux cutoff_aux uni_o 1 `bw1' `bw2' "& Sample == 1" family psu_year_y "rf" `counter' "`num'"

    drop score_rd_aux cutoff_aux
}

coefficients_plots "rf" "vertical" "figureC7b"
estimates drop _all

*** Figure C9  *****************************************************************
local contador = 0
foreach num of numlist  5/15 {

		local contador = `contador' + 1
    local factor = `num'/10

		local bw1 = `factor'*`bw11'
		local bw2 = `factor'*`bw21'

    coefficients_for_plots uni_y score_rd_o cutoff_o uni_o 1 `bw1' `bw2' "& Sample == 1" family psu_year_y "iv" `counter' "`factor'"

}

coefficients_plots "iv" "vertical" "figureC9"
estimates drop _all

*** Figure D2  *****************************************************************
generate score_rd_sch = score_rd_o - 75
generate cutoff_sch = score_rd_sch >= 0

local bwA = round(`bw11',5)
local bwB = round(`bw21',5)

reduced_form_plot uni_y      1 score_rd_sch cutoff_sch  `bwA' `bwB' 5 5.5 "" fid_2_o psu_year 6 "figureD1a"
reduced_form_plot applyFA_y  1 score_rd_sch cutoff_sch  `bwA' `bwB' 5 5.5 "" fid_2_o psu_year 6 "figureD1b"
reduced_form_plot uni_o      1 score_rd_sch cutoff_sch  `bwA' `bwB' 5 5.5 "" fid_2_o psu_year 6 "figureD1c"
reduced_form_plot Loan2      1 score_rd_sch cutoff_sch  `bwA' `bwB' 5 5.5 "" fid_2_o psu_year 6 "figureD1d"

drop score_rd_sch cutoff_sch

*** Table D3  ******************************************************************
use "${temp_path}${dash}siblings_rtf.dta", clear

#delimit;
rdrobust uni_o score_rd if  uni_o !=. & Sample == 1,
c(0) deriv(0) p(1) q(2) kernel(uniform)
covs(yr_2 yr_3 yr_4 yr_5 yr_6 yr_7)
bwselect(msetwo) level(95) all;
#delimit cr;

local bw1 = e(h_l)
local bw2 = e(h_r)

foreach var of varlist he_o vhe_o uni_o sch_o expenditure expenditure2 {
	  estimate_effects `var' score_rd_o cutoff_o uni_o 1 `bw1' `bw2' "& Sample = 1" family psu_year_y
}

tables "m1_*" "iv1_*" "fs1_*" score_rd "tableD3"
estimates drop _all
