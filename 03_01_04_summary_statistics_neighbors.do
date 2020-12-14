/*******************************************************************************
                        Summary Statistics Neighbors
                                Table: A.I
*******************************************************************************/
local bw11 = 37.07
local bw21 = 74.51


*** Older sibling
#delimit;
local stat_siblings female_o age_o LowIncome_o MidIncome_o HighIncome_o pe_o1 pe_o2 pe_o3 pe_o4 pe_o5 pe_o6
private_hi_o public_hi_o  public_o charter_o private_o HC_o TP_o
hs_gpa12_o score_rd_o Single_o paid_job_o live_parents_o
live_relatives_o live_independently_o family_size_o work_fg_o  hh_father_o
hh_mother_o hh_applicant_o hh_other_o;
#delimit cr;

*** Younger sibling
#delimit;
local stat_applicants female_y age_y LowIncome_y MidIncome_y HighIncome_y pe_y1 pe_y2 pe_y3 pe_y4 pe_y5 pe_y6
private_hi_y public_hi_y  public_y charter_y private_y HC_y TP_y  
hs_gpa9_y hs_gpa12_y score_rd_y Single_y paid_job_y live_parents_y
live_relatives_y live_independently_y family_size_y work_fg_y hh_father_y
hh_mother_y hh_applicant_y hh_other_y age_dif;
#delimit cr;

*** Whole Sample
eststo: estpost tabstat `stat_siblings' `stat_applicants' if Sample == 1, stat(mean) col(stat)
est sto m1
esttab m1 using "sum_stat_siblings1.tex", cells("mean(fmt(2))") label replace
eststo clear
estimates drop _all

*** OBW
eststo: estpost tabstat `stat_siblings' `stat_applicants' if Sample == 1 & score_rd_o >= -`bw11' & score_rd_o <= `bw21' , stat(mean) col(stat)
est sto m1
esttab m1 using "sum_stat_siblings2.tex", cells("mean(fmt(2))") label replace
eststo clear
estimates drop _all
