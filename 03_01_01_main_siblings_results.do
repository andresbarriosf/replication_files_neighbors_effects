/*******************************************************************************
                      Main Siblings' Tables and Figures

                            Tables: VII, VIII and IX
                            Figures: IV and C.XI
*******************************************************************************/

label variable uni_o      "Older sibling's probability of enrolling in university"
label variable score_rd_o "Older sibling's average PSU score (Reading and Math)"

label variable uni_y  "Probability of enrolling in university"
label variable voc_y  "Probability of enrolling in vocational higher ed."
label variable he_y   "Probability of enrolling in higher ed."

label variable same_uni 		    "Probability of enrolling in same university "
label variable diff_uni 		    "Probability of enrolling in different university"
label variable enrolls_cruch_y 	"Probability of enrolling in CRUCH university"
label variable uni_acc 			    "Probability of enrolling in an accredited university"
label variable uni_maj_acc 		  "Probability of enrolling in an accredited program"

label variable retention_system       "Probability of remaining in any university"
label variable retention_institution  "Probability of remaining in same university"

label variable any_degree_y	        "Probability of completing higher ed."
label variable university_degree_y  "Probability of completing university"

*** Table VII *******************************************************************
forvalues x = 1/2 {

  local y = `x' + 1

  *** Robust approach proposed by Cattaneo, Calonico and Titunik (2014, 2017):
  #delimit;
  rdrobust uni_y score_rd_o if  uni_y !=. & Sample == 1,
  c(0) fuzzy(uni_o) deriv(0) p(`x') q(`y') kernel(triangular)
  covs(yr_2 yr_3 yr_4 yr_5 yr_6 yr_7 yr_8 yr_9)
  bwselect(msetwo) vce(cluster family) level(95) all;
  #delimit cr;

  #delimit;
  esttab using "table7_cct_`x'.tex",
  f legend label replace booktabs collabels(none)
  cells(b(star fmt(3) vacant({--})) se(par([ ]) fmt(3)))
  stats(kernel bwselect N pv_cl pv_rb p q h_l h_r b_l b_r,
  fmt(0 0 0 3 3 0 0 2 2 2 2)layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"
  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")
  labels(`"Kernel Type"' `"BW Type"' `"Observations"' `"Conventional p-value"' `"Robust p-value"'
  `"Order Loc. Poly. (p)"' `"Order Bias (q)"' `"BW Loc. Poly. (Left)"' `"BW Loc. Poly. (Right)"' `"BW Bias (Left)"' `"BW Bias (Right)"'));
  #delimit cr;

  *** Bandwidths for estimation:
  local bw1`x' = e(h_l)
  local bw2`x' = e(h_r)

  *** Bandwidths for charts:
  local bwA = round(`bw1`x'',5)
  local bwB = round(`bw2`x'',5)

  estimate_effects uni_y score_rd_o cutoff_o uni_o `x' `bw1`x'' `bw2`x'' "& Sample == 1" family psu_year_y

  if `x' == 1 local f "4"
  if `x' == 2 local f "C11"
  *** First stage plot:
  reduced_form_plot uni_o `x' score_rd_o cutoff_o `bwA' `bwB' 5 5.5 "& Sample == 1" family psu_year_y 9 "figure`f'a"
  *** Reduced form plot:
  reduced_form_plot uni_y `x' score_rd_o cutoff_o `bwA' `bwB' 5 5.5 "& Sample == 1" family psu_year_y 9 "figure`f'b"
}

tables "m1_uni_y m2_uni_y" "iv1_uni_y iv2_uni_y" "fs1_uni_y fs2_uni_y" score_rd_o "table7"
estimates drop _all

*** Table VIII ******************************************************************
foreach var of varlist he_y voc_y uni_acc enrolls_cruch_y uni_maj_acc same_uni diff_uni{

    estimate_effects `var' score_rd_o cutoff_o uni_o 1 `bw11' `bw21' "& Sample == 1" family psu_year_y

}

tables "m1_*" "iv1_*" "fs1_*" score_rd_o "table8";
estimates drop _all

*** Table IX *******************************************************************
foreach var of varlist retention_system retention_institution any_degree_y university_degree_y {
	
	if "`var'" == "any_degree_y" | "`var'" == "university_degree_y" local add "& psu_year_y <= 2013"
	if "`var'" != "any_degree_y" & "`var'" != "university_degree_y" local add ""
	
    estimate_effects `var' score_rd_o cutoff_o uni_o 1 `bw11' `bw21' "& Sample == 1 `add'" family psu_year_y

}

tables "m1_*" "iv1_*" "fs1_*" score_rd_o "table9"
estimates drop _all
