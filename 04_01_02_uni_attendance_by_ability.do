/*******************************************************************************

		FIGURE KII:  Share of students going to university
					by household income (2015)

*******************************************************************************/

clear
set more off
set scheme s1mono
set seed 1000


use "${input_path}${dash}Casen 2015.dta", clear

*** Generate dummy variable indicating whether and individual is attending
*** university
gen universidad = e8 == 8 | e8 == 9
tab dau if edad >= 18 & edad <= 24, summarize(universidad)

#delimit;
graph bar (mean) universidad2 if edad >= 18 & edad <= 24,
over(dau, label(labsize(small)))
bar(1, fcolor(navy) lcolor(none)) bargap(5)
ytitle(Share of 18-24 years-old individuals in university)
ytitle(, size(small))
ylabel(0(0.1)0.6, labels labsize(small) labcolor(black) angle(horizontal) format(%02.1f) nogrid);
#delimit cr;

graph save  "${output_path}${dash}figure_k2.gph", replace
graph export  "${output_path}${dash}figure_k2.pdf", as(pdf) replace
