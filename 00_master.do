/*******************************************************************************

				      NEIGHBOR EFFECTS ON UNIVERSITY ENROLLMENT

                      Andrés Barrios-Fernández
                          December, 2020

          Replication files for AEJ Applied Economics version.

*******************************************************************************/

clear
set more off
cap log close
set scheme s1mono
set seed 1000

*** Definition of globals:
global dash "/"

global main_path " "

global input_path 	"${main_path}${dash}"
global code_path  	"${main_path}${dash}"
global temp_path  	"${main_path}${dash}"
global output_path  "${main_path}${dash}"

*** Set replication = 1 to run the code that can be run using the data available
*** in andresbarriosf.github.io next to the link to the paper. Download the data,
*** set the paths to the relevant directories and the run the 00_master.do file.
global replication = 1

do "${code_path}${dash}programs.do"

********************************************************************************
*** I. ESTIMATION SAMPLES
***    Prepare datasets.
***    Prepare estimation samples.
********************************************************************************

*** 1.1 Generate main datasets:
if $replication != 1 {
  do "${code_path}${dash}01_01_00_neighborhood_units.do"
  do "${code_path}${dash}01_01_01_finding_neighbors.do"
  do "${code_path}${dash}01_01_02_psu_scores.do"
  do "${code_path}${dash}01_01_03_psu_applications.do"
  do "${code_path}${dash}01_01_04_psu_ses.do"
  do "${code_path}${dash}01_01_05_psu_siblings.do"
  do "${code_path}${dash}01_01_06_he_funding.do"
}

do "${code_path}${dash}01_01_07_he_enrollment.do"
do "${code_path}${dash}01_01_08_hs_registers.do"
do "${code_path}${dash}01_01_09_he_graduation.do"

if $replication != 1 {
  do "${code_path}${dash}01_01_10_combining_ds.do"
  do "${code_path}${dash}01_01_11_ds_and_neighbors.do"

  *** 1.2.2 Generate estimation samples:
  do "${code_path}${dash}01_02_01_estimation_samples.do"

  ******************************************************************************
  *** II. ESTIMATION OF NEIGHBORS' EFFECTS
  ***    Closest neighbor in t-1.
  ***    Closest neighbor in other periods.
  ***    Other close neighbors in t-1.
  ******************************************************************************
  cd "$output_path${dash}01_Neighbors"

  *** 2.1 Estimate the effect of the closest neighbor going to university in t-1:
  use "${temp_path}${dash}aej_closest_neighbor1.dta", clear
  estimates drop _all
  do "${code_path}${dash}02_01_01_main_neighbors_results.do"
  do "${code_path}${dash}02_01_02_heterogeneity_neighbors_results.do"
  do "${code_path}${dash}02_01_03_mediating_neighbors_results.do"
  do "${code_path}${dash}02_01_04_summary_statistics_neighbors.do"
  do "${code_path}${dash}02_01_05_robustness_neighbors_results.do"

  *** 2.2 Estimate the effect of the closest neighbor going to university in other time periods:
  use "${temp_path}${dash}aej_closest_neighbor_multiple_t.dta", clear
  estimates drop _all
  do "${code_path}${dash}02_02_01_neighbors_results_other_t.do"

  *** 2.3 Estimate the effect of other closest neighbor going to university in t-1:
  use "${temp_path}${dash}aej_close_neighbor_multiple_d.dta", clear
  estimates drop _all
  do "${code_path}${dash}02_03_01_neighbors_results_other_d.do"

  ******************************************************************************
  *** III. ESTIMATION OF SIBLINGS' EFFECTS
  ******************************************************************************
  cd "$output_path${dash}02_Siblings"

  *** 3.1 Estimate the effect of an older sibling going to university:
  use "${temp_path}${dash}aej_siblings.dta", clear
  estimates drop _all

  do "${code_path}${dash}03_01_01_main_siblings_results.do"
  do "${code_path}${dash}03_01_02_heterogeneity_siblings_results.do"
  do "${code_path}${dash}03_01_03_mediating_siblings_results.do"
  do "${code_path}${dash}03_01_04_summary_statistics_neighbors.do"
  do "${code_path}${dash}03_01_05_robustness_siblings_results.do"

  ******************************************************************************
  *** IV. Descriptive Figures
  ******************************************************************************
  *** Figure 1
  do "${code_path}${dash}04_01_01_he_attendance_by_ability.do"

  *** Figure K.II Online Appendix (requested by data editor). This file can be
  *** run using the Household Survey 2015 that is available online (look at the
  *** Readme file in the repository for the address from which it can be downloaded).
  do "${code_path}${dash}04_01_02_uni_attendance_by_ability.do"
}
