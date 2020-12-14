/*******************************************************************************
                Effects of Close Neighbors Applying at Different T

                            		Figure: G.I
*******************************************************************************/

*** Figure G.I *****************************************************************

coefficients_for_plots uni_o score_rd cutoff uni 1 49.09 64.35 "& file >= 2"  fid_2_o psu_year_o "iv" 1 "≤-2"
coefficients_for_plots uni_o score_rd cutoff uni 1 49.09 64.35 "& file == 1"  fid_2_o psu_year_o "iv" 2 "-1"
coefficients_for_plots uni_o score_rd cutoff uni 1 49.09 64.35 "& file == 0"  fid_2_o psu_year_o "iv" 3 "0"
coefficients_for_plots uni_o score_rd cutoff uni 1 49.09 64.35 "& file == -1" fid_2_o psu_year_o "iv" 4 "1"
coefficients_for_plots uni_o score_rd cutoff uni 1 49.09 64.35 "& file <= -2" fid_2_o psu_year_o "iv" 5 "≥2"

coefficients_plots "iv" "vertical" "figureG1" cutoff uni
