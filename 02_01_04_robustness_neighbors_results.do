/*******************************************************************************
                          Neighbors' Robustness Checks
                                Tables: C1, C3, C4
                          Figures: C1, C3, C7, C8, D1
*******************************************************************************/

*** Figure C1  *****************************************************************
bys mrun: gen mrun_id = _n

#delimit;
rddensity score_rd if Sample0 == 1 & closest_neighbor3 == 1 & score_rd >-475 & mrun_id == 1, c(0) p(2) q(3)
fitselect(unrestricted) kernel(triangular)
bwselect(each) vce(jackknife) plot
plot_grid(es) level(95)
graph_options(
ytitle("Density") ytitle(, size(small) orientation(vertical))
yscale(range(0 0.005)) ylabel(0(0.001)0.005 , labels labsize(vsmall) labcolor(black) angle(horizontal) format(%9.0gc))
xtitle(PSU Average Score (Reading and Math)) xtitle(, size(small))
xlabel(-225(25)75, labsize(vsmall))
);
#delimit cr

/*
Running variable: score_rd.
-----------------------------------------------
            Method |          T        P>|T|
-------------------+---------------------------
            Robust |       0.2847      0.7759
-----------------------------------------------
*/

graph save "figureC1.gph", replace
graph export "figureC1.pdf", replace as(pdf)

*** Figure C3  *****************************************************************

*** Applicants
#delimit;
local my_vars1 psu_female_o psu_age_o single_o
lowIncome_o midIncome_o highIncome_o
paid_job_o family_group_work_o
pe_o1 pe_o2 pe_o7 pe_o6
family_group_he_o
public_hi_o private_hi_o
public_o charter_o private_o hc_o g9_gpa_o
family_group_o
hh_father_o hh_mother_o
both_alive_o mother_alive_o father_alive_o
live_parents_o live_relatives_o live_independently_o
m_to_code;
#delimit cr

*** Neighbors
#delimit;
local my_vars2 psu_female psu_age single
lowIncome midIncome highIncome
paid_job_n family_group_work
pe_n1 pe_n2 pe_n7 pe_n6
public_n charter_n private_n hc g12_gpa
family_group
hh_father_n hh_mother_n
both_alive_n mother_alive_n father_alive_n
live_parents_n live_relatives_n live_independently_n;
#delimit cr

local counter = 0
foreach var of varlist `my_vars1'{

    local counter = `counter' + 1
    local vtext1: variable label `var'
    coefficients_for_plots `x' score_rd cutoff uni 1 `bw11' `bw21' "" fid_2_o psu_year_o "rf" `counter' "`vtext1'"
}

coefficients_plots "rf" "horizontal" "figureC3a"
estimates drop _all

local counter = 0
foreach var of varlist `my_vars2'{

    local counter = `counter' + 1
    local vtext1: variable label `var'
    coefficients_for_plots `x' score_rd cutoff uni 1 `bw11' `bw21' "& mrun_id == 1" fid_2_o psu_year_o "rf" `counter' "`vtext1'"
}

coefficients_plots "rf" "horizontal" "figureC3b"
estimates drop _all

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

		gen score_rd_aux  = score_rd - `num'
		gen cutoff_aux 	  = score_rd_aux >= 0

    coefficients_for_plots uni_o score_rd_aux cutoff_aux uni 1 `bw1' `bw2' "" fid_2_o psu_year_o "rf" `counter' "`num'"

    drop score_rd_aux cutoff_aux
}

coefficients_plots "rf" "vertical" "figureC7"
estimates drop _all

*** Figure C8  *****************************************************************
local contador = 0
foreach num of numlist  5/15 {

		local contador = `contador' + 1
    local factor = `num'/10

		local bw1 = `factor'*`bw11'
		local bw2 = `factor'*`bw21'

    coefficients_for_plots uni_o score_rd cutoff uni 1 `bw1' `bw2' "" fid_2_o psu_year_o "iv" `counter' "`factor'"

}

coefficients_plots "iv" "vertical" "figureC8"
estimates drop _all

*** Figure D1  *****************************************************************
generate score_rd_sch = score_rd - 75
generate cutoff_sch = score_rd_sch >= 0

local bwA = round(`bw11',5)
local bwB = round(`bw21',5)

reduced_form_plot uni_o      1 score_rd_sch cutoff_sch  `bwA' `bwB' 5 5.5 "" fid_2_o psu_year 6 "figureD1a"
reduced_form_plot applyFA_o  1 score_rd_sch cutoff_sch  `bwA' `bwB' 5 5.5 "" fid_2_o psu_year 6 "figureD1b"
reduced_form_plot uni2       1 score_rd_sch cutoff_sch  `bwA' `bwB' 5 5.5 "" fid_2_o psu_year 6 "figureD1c"
reduced_form_plot loans      1 score_rd_sch cutoff_sch  `bwA' `bwB' 5 5.5 "" fid_2_o psu_year 6 "figureD1d"

drop score_rd_sch cutoff_sch

*** Table C3  ******************************************************************
forvalues x = 1/2 {

  local y = `x' + 1

  *** Robust approach proposed by Cattaneo, Calonico and Titunik (2014, 2017):
  #delimit;
  rdrobust uni_o score_rd if  uni_o !=.,
  c(0) fuzzy(uni) deriv(0) p(`x') q(`y') kernel(uniform)
  covs(yr_2 yr_3 yr_4 yr_5 yr_6)
  bwselect(msetwo) vce(cluster fid_2_o) level(95) all;
  #delimit cr;

  #delimit;
  esttab using "tableC3_cct_`x'.tex",
  f legend label replace booktabs collabels(none)
  cells(b(star fmt(3) vacant({--})) se(par([ ]) fmt(3)))
  stats(kernel bwselect N pv_cl pv_rb p q h_l h_r b_l b_r,
  fmt(0 0 0 3 3 0 0 2 2 2 2)layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"
  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")
  labels(`"Kernel Type"' `"BW Type"' `"Observations"' `"Conventional p-value"' `"Robust p-value"'
  `"Order Loc. Poly. (p)"' `"Order Bias (q)"' `"BW Loc. Poly. (Left)"' `"BW Loc. Poly. (Right)"' `"BW Bias (Left)"' `"BW Bias (Right)"'));
  #delimit cr;

  *** Bandwidths for estimation:
  local bwa`x' = e(h_l)
  local bwb`x' = e(h_r)

  estimate_effects uni_o score_rd cutoff uni `x' `bwa`x'' `bwb`x'' "& psu_region == 13" fid_2_o psu_year_o

}

tables "m1_uni_o m2_uni_o" "iv1_uni_o iv2_uni_o" "fs1_uni_o fs2_uni_o" score_rd "tableC3"
estimates drop _all


*** Table C4  ******************************************************************
gen uniA = uni_o
gen uniB = uni_o
gen uniC = uni_o
gen uniD = uni_o

estimate_effects uniA score_rd cutoff uni `x' `bw11' `bw21' "" fid_2_o psu_year_o
estimate_effects uniB score_rd cutoff uni `x' `bw11' `bw21' "" mrun    psu_year_o
estimate_effects uniC score_rd cutoff uni `x' `bw11' `bw21' "" rbd     psu_year_o
estimate_effects uniD score_rd cutoff uni `x' `bw11' `bw21' "" psu_municipality_o psu_year_o

tables "m1_uniA m1_uniB m1_uniC m1_uniD" "iv1_uniA iv1_uniB iv1_uniC iv1_uniD" "fs1_uniA fs1_uniB fs1_uniC fs1_uniD" score_rd "tableC4"
estimates drop _all
drop uniA uniB uniC uniD


*** Figure C5  *****************************************************************
use "${temp_path}${dash}  ", clear
estimates drop _all

*** Table C1  ******************************************************************
use "${temp_path}${dash}closest_neighbor_gap1b.dta", clear
estimates drop _all

#delimit;
rdrobust uni_o score_rd if  uni_o !=.,
c(0) fuzzy(uni) deriv(0) p(1) q(2) kernel(uniform)
covs(yr_2 yr_3 yr_4 yr_5 yr_6)
bwselect(msetwo) vce(cluster fid_2_o) level(95) all;
#delimit cr;

local bw1 = e(h_l)
local bw1 = e(h_r)