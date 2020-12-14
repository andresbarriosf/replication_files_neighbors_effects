/*******************************************************************************
                      Heterogeneity of Siblings' Effects

                        Tables: F.III and F.IV

*******************************************************************************/

*** Table F.III *****************************************************************
foreach var of varlist same_gender age_difference5 {

    forvalues x = 0/1{
      gen u_`var'`x' = uni_y
      estimate_effects u_`var'`x' score_rd_o cutoff_o uni_o 1 `bw11' `bw21' "& `var' == `x' & Sample == 1" family psu_year_y
      drop u_`var'`x'
    }
}

tables "m1_*" "iv1_*" "fs1_*" score_rd_o "tableF3"
estimates drop _all


*** Table F.IV *****************************************************************
foreach var of varlist female_o {

    forvalues x = 0/1{
      gen u_`var'`x'0 = uni_y
      estimate_effects u_`var'`x'0 score_rd_o cutoff_o uni_o 1 `bw11' `bw21' "& `var' == `x' & female_y == 0 & Sample == 1" family psu_year_y
      drop u_`var'`x'0

      gen u_`var'`x'1 = uni_y
      estimate_effects u_`var'`x'1 score_rd_o cutoff_o uni_o 1 `bw11' `bw21' "& `var' == `x' & female_y == 1 & Sample == 1" family psu_year_y
      drop u_`var'`x'1
    }
}

tables "m1_*" "iv1_*" "fs1_*" score_rd_o "tableF4"
estimates drop _all
