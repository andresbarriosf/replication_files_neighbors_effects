/*******************************************************************************
                        Summary Statistics Neighbors
                                Table: I
                              Figure: I.1

*******************************************************************************/

******* Table with Summary Statistics
*** Characteristics of neighbors
#delimit;
local stat_neighbours psu_female psu_age lowIncome midIncome highIncome pe_n1 pe_n2 pe_n3 pe_n4 pe_n5 pe_n6
private_hi_n public_hi_n other_hi_n  public_n charter_n private_n hc tp
g12_gpa g9_gpa score_rd single married divorced widow work live_parents_n
live_relatives_n live_independently_n live_others_n family_group hh_father_n hh_mother_n
hh_applicant_n hh_other_n;
#delimit cr

*** Characteristics of potential applicants
#delimit;
local stat_applicants psu_female_o psu_age_o ad lowIncome_o midIncome_o highIncome_o
pe_o1 pe_o2 pe_o3 pe_o4 pe_o5 pe_o6 private_hi_o public_hi_o other_hi_o
public_o charter_o private_o hc_o tp_o
g9_gpa_o g12_gpa_o score_rd_o  single_o married_o divorced_o widow_o work_o live_parents_o
live_relatives_o live_independently_o live_others_o family_group_o hh_father_o hh_mother_o
hh_applicant_o hh_other_o km_to_code;
#delimit cr

*** All the individuals in the sample:
eststo: estpost tabstat `stat_neighbours' `stat_applicants', stat(mean) col(stat)
est sto m1
esttab m1 using "sum_stat_neighbours1.tex", cells("mean(fmt(2))") label replace
eststo clear
estimates drop _all

*** Only individuals within the OBW for main results:
eststo: estpost tabstat `stat_neighbours' `stat_applicants' if score_rd >= -`bw1' & score_rd <= `bw2', stat(mean) col(stat)
est sto m1
esttab m1 using "sum_stat_neighbours2.tex", cells("mean(fmt(2))") label replace
eststo clear
estimates drop _all

*** Distribution of distance to the closest neighbor:
#delimit;
histogram km_to_code if km_to_code <= 0.5,
width(0.01) start(0) frequency fcolor(navy8)
ytitle(Frequency) ytitle(, size(small) orientation(vertical))
ylabel(, labsize(vsmall) angle(horizontal) format(%9.0fc))
xtitle(Distance to closest neighbor (km)) xtitle(, size(small))
xlabel(, labsize(vsmall) format(%4.3f))
legend(off);
#delimit cr

graph save "distance_to_closest_neighbour.gph", replace
graph export "distance_to_closest_neighbour.pdf", replace as(pdf)
