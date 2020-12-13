/*******************************************************************************
                      Heterogeneity of Neighbors' Effects 

                        Tables: V, VI, F.I, and F.II
                              Figure: E.IV
*******************************************************************************/

*** Table V ********************************************************************
foreach var of varlist similar_ses2 same_gender age_difference1 {

    forvalues x = 0/1{
      gen u_`var'`x' = uni_o
      estimate_effects u_`var'`x' score_rd cutoff uni 1 `bw11' `bw21' "& `var' == `x'" fid_2_o psu_year_o
      drop u_`var'`x'
    }
}

#delimit;
tables "m1_u_similar_ses21 m1_u_similar_ses20 m1_u_same_gender1 m1_u_same_gender0 m1_u_age_difference11 m1_u_age_difference10"
"iv1_u_similar_ses21 iv1_u_similar_ses20 iv1_u_same_gender1 iv1_u_same_gender0 iv1_u_age_difference11 iv1_u_age_difference10"
"fs1_u_similar_ses21 fs1_u_similar_ses20 fs1_u_same_gender1 fs1_u_same_gender0 fs1_u_age_difference11 fs1_u_age_difference10"
score_rd "table5";
#delimit cr
estimates drop _all

*** Table VI ******************************************************************
foreach var of varlist old_neighbor_o neighbor_remains mother_housewife {

    forvalues x = 0/1{
      gen u_`var'`x' = uni_o
      estimate_effects u_`var'`x' score_rd cutoff uni 1 `bw11' `bw21' "& `var' == `x'" fid_2_o psu_year_o
      drop u_`var'`x'
    }
}

#delimit;
tables "m1_u_old_neighbor_o1 m1_u_old_neighbor_o0 m1_u_neighbor_remains1 m1_u_neighbor_remains0 m1_u_mother_housewife1 m1_u_mother_housewife0"
"iv1_u_old_neighbor_o1 iv1_u_old_neighbor_o0 iv1_u_neighbor_remains1 iv1_u_neighbor_remains0 iv1_u_mother_housewife1 iv1_u_mother_housewife0"
"fs1_u_old_neighbor_o1 fs1_u_old_neighbor_o0 fs1_u_neighbor_remains1 fs1_u_neighbor_remains0 fs1_u_mother_housewife1 fs1_u_mother_housewife0"
score_rd "table6";
#delimit cr
estimates drop _all

*** Table F.I ******************************************************************
foreach var of varlist lowIncome_o midIncome_o highIncome_o hc_o tp_o psu_female_o psu_male_o positive_difference negative_difference {


      gen u_`var'`x' = uni_o
      estimate_effects u_`var' score_rd cutoff uni 1 `bw11' `bw21' "& `var' == 1" fid_2_o psu_year_o
      drop u_`var'`x'

}

#delimit;
tables "m1_u_lowIncome_o m1_u_midIncome_o m1_u_highIncome_o m1_u_hc_o m1_u_tp_o m1_u_psu_female_o m1_u_psu_male_o m1_u_positive_difference m1_u_negative_difference"
"iv1_u_lowIncome_o iv1_u_midIncome_o iv1_u_highIncome_o iv1_u_hc_o iv1_u_tp_o iv1_u_psu_female_o iv1_u_psu_male_o iv1_u_positive_difference iv1_u_negative_difference"
"fs1_u_lowIncome_o fs1_u_midIncome_o fs1_u_highIncome_o fs1_u_hc_o fs1_u_tp_o fs1_u_psu_female_o fs1_u_psu_male_o fs1_u_positive_difference fs1_u_negative_difference"
score_rd "tableF1";
#delimit cr
estimates drop _all

*** Table F.II *****************************************************************
foreach var of varlist psu_female {

    forvalues x = 0/1{
      gen u_`var'`x'0 = uni_o
      estimate_effects u_`var'`x' score_rd cutoff uni 1 `bw11' `bw21' "& `var' == `x' & psu_female_o == 0" fid_2_o psu_year_o
      drop u_`var'`x'0

      gen u_`var'`x'1 = uni_o
      estimate_effects u_`var'`x' score_rd cutoff uni 1 `bw11' `bw21' "& `var' == `x' & psu_female_o == 1" fid_2_o psu_year_o
      drop u_`var'`x'1
    }
}

#delimit;
tables "m1_u_psu_female11 m1_u_psu_female10 m1_u_psu_female01 m1_u_psu_female00"
"iv1_u_psu_female11 iv1_u_psu_female10 iv1_u_psu_female01 iv1_u_psu_female00"
"fs1_u_psu_female11 fs1_u_psu_female10 fs1_u_psu_female01 fs1_u_psu_female00"
score_rd "tableF2";
#delimit cr
estimates drop _all

*** Figure E.IV ****************************************************************
coefficients_for_plots uni_o score_rd cutoff uni 1 `bw1' `bw2' "& att1 == 1" "all" 1 "Low (33.0%)"
coefficients_for_plots uni_o score_rd cutoff uni 1 `bw1' `bw2' "& att1 == 2" "all" 2 "Low (52.2%)"
coefficients_for_plots uni_o score_rd cutoff uni 1 `bw1' `bw2' "& att1 == 3" "all" 3 "Low (72.2%)"

coefficients_plots "all" "vertical" "figureE4"
