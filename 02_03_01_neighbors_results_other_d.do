/*******************************************************************************
                  Effects by Distance and Other Neighbors' Definitions

                            				Table: G.I
                            			Figures: III
*******************************************************************************/

*** Figure III *****************************************************************
forvalues x = 1/4{
	coefficients_for_plots  uni_o score_rd cutoff uni 1 49.09 64.35 "& distance_quartiles == `x'" fid_2_o psu_year_o "iv" `x' "Quartile `x'"
}
coefficients_plots "iv" "vertical" "figure3" cutoff uni 

*** Table G.I ******************************************************************
foreach var of varlist best100 best125 best150 best175 best200 {

			if "`var'" == "best100" local text u100
			if "`var'" == "best125" local text u125
			if "`var'" == "best150" local text u150
			if "`var'" == "best175" local text u175
			if "`var'" == "best200" local text u200
			

			gen `text' = uni_o
			estimate_effects 	`text' score_rd cutoff uni 1 49.09 64.35 "& `var' == 1" fid_2_o psu_year_o
			drop `text'
}

tables "m1_u100 m1_u125 m1_u150 m1_u175 m1_u200" "iv1_u100 iv1_u125 iv1_u150 iv1_u175 iv1_u200" "fs1_u100 fs1_u125 fs1_u150 fs1_u175 fs1_u200" score_rd "tableG1"
estimates drop _all
