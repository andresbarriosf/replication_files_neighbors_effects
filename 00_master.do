/*******************************************************************************

				      NEIGHBOR EFFECTS ON UNIVERSITY ENROLLMENT

                      Andrés Barrios-Fernández
                          December, 2020

          Replication files for AEJ Applied Economics version.

*******************************************************************************/

clear
set more off
cap log close

*** Definition of globals:
global slash "/"

global main_path "${slash}Users${slash}andresbarriosfernandez${slash}Dropbox${slash}00. JMP Replication Files"

global input_path 	"${main_path}${slash}01. Input"
global code_path  	"${main_path}${slash}07. R&R AEJ CODE"
global temp_path  	"${main_path}${slash}08. R&R AEJ DATA"
global output_path  "${main_path}${slash}09. R&R AEJ OUTPUT"

do "${code_path}${dash}programs.do"
********************************************************************************
*** I. ESTIMATION SAMPLES
***    Prepare common datasets.
***    Prepare neighbors' datasets.
***    Prepare siblings datasets.
********************************************************************************

*** 1.1 Generate common datasets:
do "${code_path}${dash}02_01_psu_scores.do"
do "${code_path}${dash}02_02_psu_applications.do"
do "${code_path}${dash}02_03_psu_ses.do"
do "${code_path}${dash}02_04_psu_siblings.do"
do "${code_path}${dash}02_05_he_enrollment.do"
do "${code_path}${dash}02_06_funding.do"
do "${code_path}${dash}02_07_high_school.do"
do "${code_path}${dash}02_08_hei_characteristics.do"
do "${code_path}${dash}02_09_he_graduation.do"
do "${code_path}${dash}02_10_combine_datasets.do"

*** 1.2 Generate neighbors' datasets:
*** 1.2.1 Identify close neighbors:
do "${code_path}${dash}01. Finding neighbors.do"

*** 1.2.2 Generate neighbors' estimation samples:
do "${code_path}${dash}03. generate estimation samples.do"

*** 1.3 Generate siblings' datasets:
*** 1.3.1 Identify siblings:
do "${code_path}${dash}01_03_01_finding_siblings.do"

*** 1.3.2 Generate siblings' estimation samples:
do "${code_path}${dash}01_03_02_siblings_estimation_samples.do"

********************************************************************************
*** II. ESTIMATION OF NEIGHBORS' EFFECTS
***    Closest neighbor in t-1.
***    Closest neighbor in other periods.
***    Other close neighbors in t-1.
********************************************************************************
cd "$output_path${dash}Neighbors"

*** 2.1 Estimate the effect of the closest neighbor going to university in t-1:
use "${temp_path}${dash}closest_neighbor_t1.dta", clear
estimates drop _all

do "${code_path}${dash}02_01_01_main_neighbors_results.do"
do "${code_path}${dash}02_01_02_heterogeneity_neighbors_results.do"
do "${code_path}${dash}02_01_03_mediating_neighbors_results.do"
do "${code_path}${dash}02_01_04_robustness_neighbors_results.do"
do "${code_path}${dash}02_01_05_summary_statistics_neighbors.do"

*** 2.2 Estimate the effect of the closest neighbor going to university in other time periods:
use "${temp_path}${dash}closest_neighbor_multiple_t.dta", clear
estimates drop _all

do "${code_path}${dash}02_02_01_neighbors_results_other_t.do"

*** 2.3 Estimate the effect of other closest neighbor going to university in t-1:
use "${temp_path}${dash}closest_neighbor_multiple_d.dta", clear
estimates drop _all

do "${code_path}${dash}02_02_03_neighbors_results_other_d.do"

********************************************************************************
*** III. ESTIMATION OF SIBLINGS' EFFECTS
********************************************************************************
cd "$output_path${dash}Siblings"

*** 3.1 Estimate the effect of an older sibling going to university:
use "${temp_path}${dash}siblings.dta", clear
estimates drop _all

do "${code_path}${dash}03_01_01_main_siblings_results.do"
do "${code_path}${dash}03_01_02_heterogeneity_siblings_results.do"
do "${code_path}${dash}03_01_03_mediating_siblings_results.do"
do "${code_path}${dash}03_01_04_robustness_siblings_results.do"
