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

/***  Closest applicant T1:  ***************************************************
+ Identification: mrun_n, mrun, id
+ Treatment: uni2_n
+ Instrument: cutoff_n
+ Running variable: score_rd_n
+ Timing: psu_year, psu_year_n yr_1 yr_2 yr_3 yr_4 yr_5 yr_6
+ Clustering: fid_2_n

+ Outcomes:
  *** Tables ***
  - km_to_code
  - distance_rank

  ** Figures ***
  - pa_registered50 pa_registered100 pa_registered150 pa_registered200

*******************************************************************************/
use "/Volumes/Andres for MAC/00_replication_files_jmp/closest_neighbor_nn1.dta", clear

local id_vars       mrun mrun_n id psu_year psu_year_n yr_1 yr_2 yr_3 yr_4 yr_5 yr_6
local estimation    score_rd_n cutoff_n uni2_n distance_rank
local clustering    fid_2_n
local outcomes      pa_registered50 pa_registered100 pa_registered150 pa_registered200 km_to_code

keep  `id_vars' `estimation' `clustering' `outcomes'
order `id_vars' `estimation' `clustering' `outcomes'

keep if distance_rank == 1 | id == 1
rename uni2_n uni_n

save "/Volumes/Andres for MAC/00_final_datasets_aej_applied/aej_close_applicants1.dta", replace

/***  Multiple T:  ***************************************************
+ Identification: mrun_o, mrun
+ Treatment:  uni2
+ Instrument: cutoff
+ Running variable: score_rd
+ Timing: psu_year_o psu_year yr_1 yr_2 yr_3 yr_4 yr_5 yr_6 yr_7
+ Clustering: fid_2_o
+ Outcomes: uni2_o
+ Restrictions: file
** 08_multiple_neighbors.do
*******************************************************************************/
keep if closest_neighbor3 == 1 & Sample0 == 1 & km_to_code <= 0.15
label variable file "Gap between the applicant and the neighbor"

keep mrun uni2 cutoff score_rd psu_year file mrun_o uni2_o psu_year_o yr_* fid_2_o
rename (uni2 uni2_o)(uni uni_o)
estimates drop _all
save "/Volumes/Andres for MAC/00_final_datasets_aej_applied/aej_closest_neighbor_multiple_t.dta", replace

/*** No apply to funding *******************************************************
+ Identification: mrun_o, mrun
+ Treatment:  uni2
+ Instrument: cutoff
+ Running variable: score_rd
+ Timing: psu_year_o psu_year yr_1 yr_2 yr_3 yr_4 yr_5 yr_6 yr_7
+ Clustering: fid_2_o

+ Outcomes:
  - uni2_o takes_psu2 applyFA_o cond_score_rd_o g12_gpa_o

** 09_robustness_no_applicants.do
*******************************************************************************/
use  "/Volumes/Andres for MAC/00_replication_files_jmp/closest_neighbor_gap1b.dta", clear

gen cutoff = score_rd >= 0
gen cond_score_rd_o = score_rd_o if score_rd_o >-475
gen takes_psu2      = psu_reading_o > -4 & psu_math_o > -4 & (psu_history_o >= -4 | psu_science_o >-4)
replace applyFA_o = 0 if applyFA_o ==.
tab psu_year_o, gen(yr_)

keep if Sample0B == 1 & closest_neighbor3b == 1 & km_to_code <= 0.15
keep mrun psu_year score_rd cutoff uni2 mrun_o psu_year_o yr_* uni2_o takes_psu2 applyFA_o cond_score_rd_o g12_gpa_o fid_2_o
rename (uni2 uni2_o)(uni uni_o)

save "/Volumes/Andres for MAC/00_final_datasets_aej_applied/aej_closest_neighbor_no_funding.dta", replace

/***  Multiple D:  ***************************************************
+ Identification: mrun_o, mrun
+ Treatment:  uni2
+ Instrument: cutoff
+ Running variable: score_rd
+ Timing: psu_year_o psu_year yr_1 yr_2 yr_3 yr_4 yr_5 yr_6
+ Clustering: fid_2_o
+ Outcomes: uni2_o
+ Other variables: km_to_code distance_quartile best*
** 2_11_other_neighbors.do
*******************************************************************************/
keep if Sample0 == 1
keep mrun psu_year score_rd cutoff uni2 mrun psu_year_o uni2_o yr_* distance_quartile best* km_to_code fid_2_o
compress
rename (uni2 uni2_o)(uni uni_o)
save "/Volumes/Andres for MAC/00_final_datasets_aej_applied/aej_close_neighbor_multiple_d.dta",



/***  Older sibling:  ****************************************************
+ Identification: mrun_o, mrun_y
+ Treatment: attendsU2_o attendsU2_y
+ Instrument: cutoff_o
+ Running variable: score_rd_o
+ Timing: psu_year_o, psu_year, yr_1, yr_2, yr_3, yr_4, yr_5, yr_6, yr_7,...,yr_9
+ Clustering: mrun_madre

+ Outcomes:
  *** Tables ***
  - Table 02: uni2_y
  - Table 03: he_o, voc_o, uni_acc, enrolls_cruch_o, uni_maj_acc, same_uni, diff_uni
  - Table 04: retention_inst_o, retention_uni_o, university_degree_o, any_degree_o
  - Table 05: same_gender, age_difference5
  - Table 10: takes_psu2 active_cruch_o applyFA_o cutoff_o receives_funding_o g12_attendance_o g12_gpa_o score_rd_o cond_score_rd_o

  - Table F2: psu_female

  *** Figures ***
  - Figure D1: loans

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
keep if Sample1 == 1 | Sample1B == 1

local id_vars       mrun psu_year mrun_o psu_year_o yr_1 yr_2 yr_3 yr_4 yr_5 yr_6
local estimation    score_rd cutoff uni2 Sample 
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
