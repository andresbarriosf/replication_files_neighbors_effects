/***  Closest neighbor T1:  ****************************************************
+ Identification: mrun_o, mrun.
+ Treatment: uni2.
+ Instrument: cutoff.
+ Running variable: score_rd_o.
+ Timing: psu_year_o, psu_year, yr_1, yr_2, yr_3, yr_4, yr_5 and yr_6.
+ Clustering: fid_2_o, psu_rbd_o, psu_municipality_o

+ Outcomes:
  *** Tables ***
  - Table 02: uni2_o
  - Table 03: he_o, voc_o, uni_acc, enrolls_cruch_o, uni_maj_acc, same_uni, diff_uni
  - Table 04: retention_inst_o, retention_uni_o, university_degree_o, any_degree_o
  - Table 05: similar_ses2, same_gender, age_difference1
  - Table 06: old_neighbor_o, neighbor_remains, mother_housewife.
  - Table 10: takes_psu2 active_cruch_o applyFA_o cutoff_o receives_funding_o g12_attendance_o g12_gpa_o score_rd_o cond_score_rd_o

  - Table C3: psu_region_o (13)
  - Table F1: lowIncome_o, midIncome_o, highIncome_o, hc_o, tp_o, psu_female_o, and positive_difference
  - Table F2: psu_female

  *** Figures ***
  - Figure D1: loans
  - Figure E4: att1

+ Summary statistics and discontinuities:

  *** Tables ***
  - psu_female, psu_female_o
  - psu_age, psu_age_o
  - lowIncome_o, lowIncome, midIncome_o, midIncome, highIncome_o, highIncome
  - pe_n1 pe_n2 pe_n3 pe_n4 pe_n5 pe_n6 pe_n7
  - pe_o1 pe_o2 pe_o3 pe_o4 pe_o5 pe_o6 pe_o7
  - public_n public_o charter_n charter_o private_n private_o
  - g12_gpa_o g12_gpa
  - score_rd_o score_rd
  - family_group_o family_group
  - hh_father_n hh_mother_n hh_applicant_n hh_father_o hh_mother_o hh_applicant_o
  - ad, km_to_code

  *** Figures ***
  - single single_o
  - family_group_work_o, family_group_work, family_group_he_o, family_group_he
  - work_o work
  - private_hi_n public_hi_n private_hi_o public_hi_o
  - g9_gpa_o, g12_gpa
  - both_alive_n father_alive_n mother_alive_n none_alive_n both_alive_o father_alive_o mother_alive_o none_alive_o
  - hc_o hc tp_o tp
  - live_parents_n live_relatives_n live_independently_n live_parents_o live_relatives_o live_independently_o

*******************************************************************************/

use "/Volumes/Andres for MAC/00_replication_files_jmp/neighbors_ds121120.dta"
keep if closest_neighbor3 == 1 & Sample0 == 1 & km_to_code <= 0.150

local id_vars       mrun psu_year mrun_o psu_year_o yr_1 yr_2 yr_3 yr_4 yr_5 yr_6
local estimation    score_rd cutoff uni2
local clustering    fid_2_o psu_municipality_o psu_region_o

#delimit;
local outcomes      uni2_o he_o voc_o uni_acc enrolls_cruch_o uni_maj_acc same_uni diff_uni
                    retention_inst_o retention_uni_o university_degree_o any_degree_o
                    takes_psu2 active_cruch_o applyFA_o cutoff_o receives_funding_o g12_attendance_o g12_gpa_o score_rd_o cond_score_rd_o loans;
#delimit cr

#delimit;
local sum_stats     psu_female  psu_female_o psu_male_o psu_age psu_age_o ad
                    pe_n1 pe_n2 pe_n3 pe_n4 pe_n5 pe_n6 pe_n7
                    pe_o1 pe_o2 pe_o3 pe_o4 pe_o5 pe_o6 pe_o7
                    lowIncome_o midIncome_o highIncome_o lowIncome midIncome highIncome
                    psu_rbd_o
                    public_n  charter_n private_n public_o charter_o private_o hc_o tp_o hc tp
                    g12_gpa g12_gpa_o g9_gpa_o
                    family_group family_group_o family_group_work family_group_work_o family_group_he family_group_he_o
                    hh_father_n hh_mother_n hh_applicant_n hh_father_o hh_mother_o hh_applicant_o
                    work work_o single single_o
                    private_hi_n public_hi_n private_hi_o public_hi_o
                    both_alive_n father_alive_n mother_alive_n none_alive_n both_alive_o father_alive_o mother_alive_o none_alive_o
                    live_parents_n live_relatives_n live_independently_n live_parents_o live_relatives_o live_independently_o
                    km_to_code;
#delimit cr

local heterogeneity similar_ses2 same_gender age_difference1 old_neighbor_o neighbor_remains mother_housewife psu_region_o positive_difference negative_difference att1

keep  `id_vars' `estimation' `clustering' `outcomes' `sum_stats' `heterogeneity'
order `id_vars' `estimation' `clustering' `outcomes' `sum_stats' `heterogeneity'

rename (uni2 uni2_o)(uni uni_o)

save "/Volumes/Andres for MAC/00_final_datasets_aej_applied/aej_closest_neighbor1.dta", replace
