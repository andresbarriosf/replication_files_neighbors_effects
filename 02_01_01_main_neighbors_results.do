/*******************************************************************************
                      Main Neighbors' Tables and Figures

                            Tables: II, III and IV
                            Figures: II and C.X
*******************************************************************************/

label variable uni      "Neighbor's Probability of enrolling in university"
label variable score_rd "Neighbor's Average PSU Score (Reading and Math)"

label variable uni_o  "Probability of enrolling in university"
label variable voc_o  "Probability of enrolling in vocational higher ed."
label variable he_o   "Probability of enrolling in higher ed."

label variable same_uni 		    "Probability of enrolling in same university "
label variable diff_uni 		    "Probability of enrolling in different university"
label variable enrolls_cruch_o 	"Probability of enrolling in CRUCH university"
label variable uni_acc 			    "Probability of enrolling in an accredited university"
label variable uni_maj_acc 		  "Probability of enrolling in an accredited program"

label variable retention_inst_o "Probability of remaining in any university"
label variable retention_uni_o  "Probability of remaining in same university"

label variable graduates_he_o	  "Probability of completing higher ed."
label variable graduates_uni_o  "Probability of completing university"

*** Table II *******************************************************************
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
  esttab using "table2_cct_`x'.tex",
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

  estimate_effects uni_o score_rd cutoff uni `x' `bw1`x'' `bw2`x'' "" fid_2_o psu_year_o

  if `x' == 1 local f "2"
  if `x' == 2 local f "C10"
  *** First stage plot:
  reduced_form_plot uni   `x' score_rd cutoff `bwA' `bwB' 5 5.5 "" fid_2_o psu_year_o 6 "figure`f'a"
  *** Reduced form plot:
  reduced_form_plot uni_o `x' score_rd cutoff `bwA' `bwB' 5 5.5 "" fid_2_o psu_year_o 6 "figure`f'b"
}

tables "m1_uni_o m2_uni_o" "iv1_uni_o iv2_uni_o" "fs1_uni_o fs2_uni_o" score_rd "table2"
estimates drop _all

*** Table III ******************************************************************
foreach var of varlist he_o voc_o uni_acc enrolls_cruch_o uni_maj_acc same_uni diff_uni{

    estimate_effects `var' score_rd cutoff uni 1 `bw11' `bw21' "" fid_2_o psu_year_o

}

#delimit;
tables "m1_he_o m1_voc_o m1_uni_acc m1_enrolls_cruch_o m1_uni_maj_acc m1_same_uni m1_diff_uni"
"iv1_he_o iv1_voc_o iv1_uni_acc iv1_enrolls_cruch_o iv1_uni_maj_acc iv1_same_uni iv1_diff_uni"
"fs1_he_o fs1_voc_o fs1_uni_acc fs1_enrolls_cruch_o fs1_uni_maj_acc fs1_same_uni fs1_diff_uni"
score_rd "table3";
#delimit cr
estimates drop _all

*** Table IV *******************************************************************
foreach var of varlist retention_inst_o retention_uni_o graduates_he_o	graduates_uni_o {

    estimate_effects `var' score_rd cutoff uni 1 `bw11' `bw21' "" fid_2_o psu_year_o

}

#delimit;
tables "m1_retention_inst_o m1_retention_uni_o m1_graduates_he_o	m1_graduates_uni_o"
"iv1_retention_inst_o iv1_retention_uni_o iv1_graduates_he_o	iv1_graduates_uni_o"
"fs1_retention_inst_o fs1_retention_uni_o fs1_graduates_he_o	fs1_graduates_uni_o"
score_rd "table4";
#delimit cr
estimates drop _all
