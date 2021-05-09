/*******************************************************************************

		FIGURE I: University enrollment by household income,
						ability level, and municipality

*******************************************************************************/

clear
set more off
set scheme s1mono
set seed 1000

*** I. Prepare datasets

*** 1.1 Import school directory datasets:
foreach num of numlist 2006 2008 2010 2012 {
	import delimited "${input_path}${dash}Directorio_Establecimientos_`x'.csv", clear
	save "${input_path}${dash}School Directory (`num').dta", replace
}

*** 1.2 Combine SIMCE scores, SES and school municipality:
*** 2006
***
use "${input_path}${dash}simce2m2006_alu_publica_final.dta", clear

xtile veintile_math = ptje_mate2m_alu, n(20)

keep if veintile_math !=.
keep if mrun !=.
keep agno mrun rbd idalumno gen_alu veintile_math

merge 1:1 idalumno using "${input_path}${dash}simce2m2006_cpad_publica_final.dta", keepusing(cpad_p14)
drop if _merge == 2
drop _merge

rename cpad_p14 household_income
replace household_income =. if household_income == 0 | household_income == 99
compress

gen sexo = "H" if gen_alu == 1
replace sexo = "F" if gen_alu == 2

merge m:1 mrun using "${temp_path}${dash}enrollmentHE_2009.dta", keepusing(ties1)
drop if _merge == 2

gen attendsHE  = _merge == 3
gen attendsUni = ties1  == "Universidades"
drop ties1 _merge

merge m:1 rbd using  "${input_path}${dash}School Directory (2006).dta", keepusing(cod_com_rbd nom_com_rbd)
drop if _merge == 2
drop _merge

save "${temp_path}${dash}2006.dta", replace

*** 2008
use "${input_path}${dash}simce2m2008_alu_publica_final.dta", clear

xtile veintile_math = ptje_mate2m_alu, n(20)

keep if veintile_math !=.
keep if mrun !=.
keep agno mrun rbd idalumno gen_alu veintile_math

merge 1:1 idalumno using "${input_path}${dash}simce2m2008_cpad_publica_final.dta", keepusing(cpad_p07_*)
drop if _merge == 2
drop _merge

generate household_income = 1 if cpad_p07_01 == 1
replace  household_income = 2 if cpad_p07_02 == 1
replace  household_income = 3 if cpad_p07_03 == 1
replace  household_income = 4 if cpad_p07_04 == 1
replace  household_income = 5 if cpad_p07_05 == 1
replace  household_income = 6 if cpad_p07_06 == 1
replace  household_income = 7 if cpad_p07_07 == 1
replace  household_income = 8 if cpad_p07_08 == 1
replace  household_income = 9 if cpad_p07_09 == 1
replace  household_income = 10 if cpad_p07_10 == 1
replace  household_income = 11 if cpad_p07_11 == 1
replace  household_income = 12 if cpad_p07_12 == 1
replace  household_income = 13 if cpad_p07_13 == 1
egen nr = rowtotal(cpad_p07_*)
drop cpad_p07_*
replace household_income =. if nr > 1
drop nr
compress

gen sexo = "H" if gen_alu == 1
replace sexo = "F" if gen_alu == 2

merge m:1 mrun using "${temp_path}${dash}enrollmentHE_2011.dta", keepusing(ties1)
drop if _merge == 2

gen attendsHE  = _merge == 3
gen attendsUni = ties1  == "Universidades"
drop ties1 _merge

merge m:1 rbd using  "${input_path}${dash}School Directory (2008).dta", keepusing(cod_com_rbd nom_com_rbd)
drop if _merge == 2
drop _merge

save "${temp_path}${dash}2008.dta", replace

*** 2010
use "${input_path}${dash}simce2m2010_alu_publica_final.dta", clear

xtile veintile_math = ptje_mate2m_alu, n(20)

keep if veintile_math !=.
keep if mrun !=.
keep agno mrun rbd idalumno gen_alu veintile_math


merge 1:1 idalumno using "${input_path}${dash}simce2m2010_cpad_publica_final.dta", keepusing(cpad_p11_*)
drop if _merge == 2
drop _merge

generate household_income = 1 if cpad_p11_01 == 1
replace  household_income = 2 if cpad_p11_02 == 1
replace  household_income = 3 if cpad_p11_03 == 1
replace  household_income = 4 if cpad_p11_04 == 1
replace  household_income = 5 if cpad_p11_05 == 1
replace  household_income = 6 if cpad_p11_06 == 1
replace  household_income = 7 if cpad_p11_07 == 1
replace  household_income = 8 if cpad_p11_08 == 1
replace  household_income = 9 if cpad_p11_09 == 1
replace  household_income = 10 if cpad_p11_10 == 1
replace  household_income = 11 if cpad_p11_11 == 1
replace  household_income = 12 if cpad_p11_12 == 1
replace  household_income = 13 if cpad_p11_13 == 1
replace  household_income = 14 if cpad_p11_14 == 1
replace  household_income = 15 if cpad_p11_15 == 1

egen nr = rowtotal(cpad_p11_*)
drop cpad_p11_*
replace household_income =. if nr > 1
drop nr
compress

gen sexo = "H" if gen_alu == 1
replace sexo = "F" if gen_alu == 2

merge m:1 mrun  using "${temp_path}${dash}enrollmentHE_2013.dta", keepusing(ties1)
drop if _merge == 2

gen attendsHE  = _merge == 3
gen attendsUni = ties1  == "Universidades"
drop ties1 _merge

merge m:1 rbd using  "${input_path}${dash}School Directory (2010).dta", keepusing(cod_com_rbd nom_com_rbd)
drop if _merge == 2
drop _merge

save "${temp_path}${dash}2010.dta", replace

*** 2012
use "${input_path}${dash}simce2m2012_alu_publica_final.dta", clear

xtile veintile_math = ptje_mate2m_alu, n(20)

keep if veintile_math !=.
keep if mrun !=.
keep agno mrun rbd idalumno gen_alu veintile_math

merge 1:1 idalumno using "${input_path}${dash}simce2m2012_cpad_publica_final.dta", keepusing(cpad_p10)
drop if _merge == 2
drop _merge

rename cpad_p10 household_income
replace household_income =. if household_income == 0 | household_income == 99
compress

gen sexo = "H" if gen_alu == 1
replace sexo = "F" if gen_alu == 2

merge m:1 mrun using "${temp_path}${dash}enrollmentHE_2015.dta", keepusing(ties1)
drop if _merge == 2

gen attendsHE  = _merge == 3
gen attendsUni = ties1  == "Universidades"
drop ties1 _merge

merge m:1 rbd using  "${input_path}${dash}School Directory (2012).dta", keepusing(cod_com_rbd nom_com_rbd)
drop if _merge == 2
drop _merge

save "${temp_path}${dash}2012.dta", replace

*** II. Combine datasets and generate figure:
*** 2.1 Combine datasets
clear
forvalues x = 2006(2)2012 {

	append using "${temp_path}${dash}`x'.dta"

}

cap drop income shareHE shareU cid nid veintileB
generate income = 1 if household_income == 1
replace  income = 2 if household_income >= 13 & household_income !=.

bys income veintile_math nom_com_rbd: egen shareHE = mean(attendsHE)
bys income veintile_math nom_com_rbd: egen shareU = mean(attendsUni)
bys income veintile_math nom_com_rbd: gen cid = _n
bys income veintile_math nom_com_rbd: gen nid = _N

gen veintileB = veintile_math - 0.25 if income == 1
replace veintileB = veintile_math + 0.25 if income == 2

*** 2.2 Generate figure:
#delimit;
twoway (scatter shareHE veintileB if cid == 1 & income == 1 & nid >= 10, sort mcolor(navy8) msize(vsmall) msymbol(triangle_hollow))
(scatter shareHE veintileB if cid == 1 & income == 2 & nid >= 10, sort mcolor(maroon) msize(vsmall) msymbol(circle_hollow))
(qfit attendsHE veintile_math if income == 1, lcolor(navy8))
(qfit attendsHE veintile_math if income == 2, lcolor(maroon)),
ytitle(" ") ytitle(, color(none))
yscale(range(0 1))
ylabel(0(0.1)1, labels labsize(small) angle(horizontal) format(%02.1f))
xtitle(Veintile in standardized test performance) xtitle(, size(small))
xlabel(1(1)20, labsize(small))
legend(order(1 "Low income" 2 "High income")
rows(1) size(small));
#delimit cr

graph save "${output_path}${dash}figure1.gph", replace
graph export "${output_path}${dash}figure1.pdf", as(pdf) replace
