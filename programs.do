/*******************************************************************************

        Programs to Replicate Neighbors' Effects on University Enrollment

                            Andrés Barrios Fernández
                                December 13, 2020

This file defines the programs used for estimating the effects and generating the
figures presented in the paper.
********************************************************************************/

********************************************************************************
*** Program to estimate first stage, reduced form and 2SLS effects:
*** Used to estimate main effect, heterogeneous effects, bandwidth variations.
********************************************************************************
capture program drop estimate_effects
program define estimate_effects

  *** Arguments:
  *** o: outcome.
  *** rv: running variable.
  *** iv: instrumental variable.
  *** t: treatment variable.
  *** x: degree of running variable.
  *** bw1: bandwidth to the left.
  *** bw2: bandwidth to the right.
  *** restrictions: sample restrictions.
  *** cluster: clustering level to compute standard errors.
  *** yfe: year fixed effects.
	args o rv iv t x bw1 bw2 restrictions cluster yfe

  *** Definition of local macros:
	local if "`rv' >= -`bw1' & `rv' <= `bw2' `restrictions'"
  local covs1  c.`rv' c.`rv'#1.`iv'
	local covs2  c.`rv' c.`rv'#c.`rv' c.`rv'#1.`iv' c.`rv'#c.`rv'#1.`iv'

	*** Reduced form effect:
	#delimit;
	reghdfe `o' `iv' `covs`x'' if `o' !=. &  `if',
	absorb(i.`yfe') cluster(`cluster');
	#delimit cr
	estadd ysumm
	estimates store m`x'_`o'

  *** 2SLS effects
	#delimit;
	ivreghdfe `o' `covs`x'' (`t' = `iv') if `o' !=. & `if',
	absorb(i.`yfe') cluster(`cluster') first ffirst savefirst savefprefix(fs_);
	#delimit cr
	estadd ysumm
	estadd scalar fstage = e(widstat)
	estimates store iv`x'_`o'

  *** First stage effects:
	estimates restore fs_`t'
	estimates store fs`x'_`o'

end

********************************************************************************
*** Program to generate tables:
********************************************************************************
capture program drop tables
program define tables

  *** Arguments:
  *** rf: reduced form estimates to add.
  *** iv: iv estimates to add.
  *** fs: fs estimates to add.
  *** rv: running variable.
  *** file_name: name of the table.
	args rf iv fs rv file_name

	*** TABLE II - University Enrollment:
	#delimit;
	estout `rf'
	using "`file_name'_rf.tex",
	cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))
	stats(N ymean, fmt(0 2) labels("N. of students" "Outcome mean" ))
	mlabels() collabels(none) note(" ") style(tex) replace label starlevels(* 0.10 ** 0.05 *** 0.01)
	indicate("Running variable polynomial = *`rv'*");
	#delimit cr

	#delimit;
	estout `iv'
	using "`file_name'_2sls.tex",
	cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))
	stats(N fstage ymean, fmt(0 2 2) labels("N. of students" "Kleibergen-Paap F statistic" "Outcome mean" ))
	mlabels() collabels(none) note(" ") style(tex) replace label starlevels(* 0.10 ** 0.05 *** 0.01)
	indicate("Running variable polynomial = *`rv'*");
	#delimit cr

	#delimit;
	estout `fs'
	using "`file_name'_fs.tex",
	cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))
	stats(N, fmt(0) labels("N. of students"))
	mlabels() collabels(none) note(" ") style(tex) replace label starlevels(* 0.10 ** 0.05 *** 0.01)
	indicate("Running variable polynomial = *`rv'*");
	#delimit cr

end program

********************************************************************************
*** Program to generate reduced form plots
********************************************************************************
capture program drop reduced_form_plot
program define reduced_form_plot

  *** Arguments:
  *** o: outcome
  *** rv: running variable.
  *** iv: instrumental variable.
  *** x: degree of running variable.
  *** bw1: bandwidth to the left.
  *** bw2: bandwidth to the right.
  *** bin1: bins width to the left.
  *** bin2: bins width to the right.
  *** restrictions: sample restrictions.
  *** cluster: clustering level to compute standard errors.
  *** yfe: year fixed effects.
  *** yfeb: number of year fixed effects.
  *** file_name: name of the file.
  args o x rv iv bw1 bw2 bin1 bin2 restrictions cluster yfe yfeb file_name

  *** Locals:
	local if "`rv' >= -`bw1' & `rv' <= `bw2' `restrictions'"
	local vtext1: variable label `o'
  local vtext2: variable label `iv'

  if `yfeb' == 6 local years "yr_2 yr_3 yr_4 yr_5 yr_6"
  if `yfeb' == 9 local years "yr_2 yr_3 yr_4 yr_5 yr_6 yr_7 yr_8 yr_9"

	*** Remove years noise:
	reg `o' i.`yfe' if `o' !=. & `if', cluster(`cluster')
	predict `o'2, residuals


	sum `o' if `o' !=. & `rv' >=-5 & `rv' < 0 & `if'

	replace `o'2 = `o'2 + r(mean)
	local nbins1 = round(`bw1'/`bin1')
	local nbins2 = round(`bw2'/`bin2')

  *** Generate bins:
	#delimit;
	rdplot `o'2 `rv' if `if', c(0) p(`x')
	nbins(`nbins1' `nbins2')  kernel(uniform) covs(`years')
	h(`bw1' `bw2') support(`bw1' `bw2') hide genvars;
	#delimit cr;

	bys rdplot_mean_y: gen bin_id = _n

  *** Define parameters for chart:
	sum rdplot_mean_y
	local lb = round(r(min),0.05) - 0.05
	local ub = round(r(max),0.05) + 0.05
	local gap = 0.05

  *** Degree 1:
	if `x' == 1{

		#delimit;
		twoway (histogram `rv', yaxis(2) width(2.5) start(-`bw1') frequency fintensity(40) fcolor(edkblue) lwidth(none))
		(lfitci `o'2 `rv' if `rv' <  0,  ciplot(rline)   lcolor(red))
		(lfitci `o'2 `rv' if `rv' >= 0,  ciplot(rline)   lcolor(red))
		(scatter rdplot_mean_y rdplot_mean_x if bin_id == 1, sort  mcolor(navy) msize(vsmall) msymbol(circle))
		(scatteri `lb' 0 `ub' 0, recast(line) lpattern(dash) lcolor(black))
		if `o' !=. & `if',
		ytitle("`vtext1'") ytitle(, size(small) orientation(rvertical))
		yscale(range(`lb' `ub')) ylabel(`lb'(`gap')`ub' , labels labsize(vsmall) labcolor(black) angle(horizontal) format(%9.0gc))
		ytitle(Frequencies, axis(2)) ytitle(, size(small) axis(2))
		ylabel(, labsize(vsmall) angle(horizontal) format(%9.0gc) axis(2))
		xtitle("`vtext2'") xtitle(, size(small))
		xlabel(-`bw1'(5)`bw2', labsize(vsmall))
		legend(off)
		plotregion(lcolor(black) lwidth(thin));
		#delimit cr
	}

  *** Degree 2:
	if `x' == 2{

		#delimit;
		twoway (histogram `rv', yaxis(2) width(2.5) start(-`bw1') frequency fintensity(40) fcolor(edkblue) lwidth(none))
		(qfitci `o'2 `rv' if `rv' <  0,  ciplot(rline)  lcolor(red))
		(qfitci `o'2 `rv' if `rv' >= 0,  ciplot(rline)  lcolor(red))
		(scatter rdplot_mean_y rdplot_mean_x if bin_id == 1, sort  mcolor(navy) msize(vsmall) msymbol(circle))
		(scatteri `lb' 0 `ub' 0, recast(line) lpattern(dash) lcolor(black))
		if `o' !=. & `if',
		ytitle("`vtext1'") ytitle(, size(small) orientation(rvertical))
		yscale(range(`lb' `ub')) ylabel(`lb'(`gap')`ub' , labels labsize(vsmall) labcolor(black) angle(horizontal) format(%9.0gc))
		ytitle(Frequencies, axis(2)) ytitle(, size(small) axis(2))
		ylabel(, labsize(vsmall) angle(horizontal) format(%9.0gc) axis(2))
		xtitle("`vtext2'") xtitle(, size(small))
		xlabel(-`bw1'(5)`bw2', labsize(vsmall))
		legend(off)
		plotregion(lcolor(black) lwidth(thin));
		#delimit cr

	}

	drop rdplot_id rdplot_mean_x rdplot_mean_y rdplot_ci_l rdplot_ci_r bin_id rdplot_N rdplot_min_bin rdplot_max_bin rdplot_mean_bin rdplot_se_y rdplot_hat_y `o'2

	graph save   "`file_name'.gph",replace
	graph export "`file_name'.pdf",replace as(pdf)

end

********************************************************************************
*** Program to etimate coefficients for plots:
********************************************************************************
capture program drop coefficients_for_plots
program define coefficients_for_plots

  *** Arguments:
  *** o: outcome.
  *** rv: running variable.
  *** iv: instrumental variable.
  *** t: treatment variable.
  *** x: degree of running variable.
  *** bw1: bandwidth to the left.
  *** bw2: bandwidth to the right.
  *** restrictions: sample restrictions.
  *** cluster: clustering level to compute standard errors.
  *** yfe: year fixed effects.
  *** plot: type of plot (rf, iv, all).
  *** counter: identifier of model.
  *** my_label: label to use for the coefficient.
  args o rv iv t x bw1 bw2 restrictions cluster yfe plot counter my_label

  *** Definition of local macros:
	local if "`rv' >= -`bw1' & `rv' <= `bw2' `restrictions'"
  local covs1  c.`rv' c.`rv'#1.`iv'
	local covs2  c.`rv' c.`rv'#c.`rv' c.`rv'#1.`iv' c.`rv'#c.`rv'#1.`iv'

  *** Estimate effects for chart:

	*** 1. Reduced form effect:
  if "`plot'" == "rf" | "`plot'" == "all" {

    gen `iv'_chart`counter' = `iv'
    label variable `iv'_chart`counter' "`my_label'"

  	#delimit;
  	reghdfe `o' `iv'_chart`counter' `covs`x'' if `o' !=. &  `if',
  	absorb(`yfe') cluster(`cluster');
  	#delimit cr
  	estadd ysumm
  	estimates store m_`counter'
  }

  *** 2. 2SLS effects
  if "`plot'" == "iv" | "`plot'" == "all" {

    gen `t'_chart`counter' = `t'
    label variable `t'_chart`counter' "`my_label'"

  	#delimit;
  	ivreghdfe `o' `covs`x'' (`t'_chart`counter' = `iv') if `o' !=. & `if',
  	absorb(`yfe') cluster(`cluster') first ffirst savefirst savefprefix(fs_);
  	#delimit cr
  	estadd ysumm
  	estadd scalar fstage = e(widstat)
  	estimates store iv_`counter'
  }

  *** 3. First stage effects:
  if "`plot'" == "all" {
    estimates restore fs_`t'_chart`counter'
    estimates store fs_`counter'
  }

end

********************************************************************************
*** Program to plot the coefficients:
********************************************************************************
capture program drop coefficients_plots
program define coefficients_plots

  *** Arguments:
  *** plot: type of plot (rf, iv, all).
  *** plot_opts: horizontal or vertical.
  *** file_name: name of the file.
  args plot plot_opts file_name iv t

  *** Horizontal
  if "`plot_opts'" == "horizontal" {

    *** Reduced form:
    if "`plot'" == "rf" | "`plot'" == "all" {
      #delimit;
      coefplot m_*
      , xline(0, lwidth(thin) lpattern(dash) lcolor(red)) keep(`iv'_chart*) levels(95)
      msymbol(circle) mcolor(navy) msize(medsmall) legend(off) ciopts(recast(rcap)
      lwidth(thin) lcolor(navy)) grid(none) offset(0) format(%03.2f)
      ylabel( , labsize(vsmall) angle(horizontal))
      xlabel(-0.05(0.05)0.05, labsize(small) angle(horizontal))
      xsize(5.5) ysize(6.5);
      #delimit cr

      graph save   "rf_`file_name'.gph", replace
      graph export "rf_`file_name'.pdf", replace as(pdf)
      if "`plot'" == "rf"  drop `iv'_chart*
    }

    *** 2sls:
    if "`plot'" == "iv" | "`plot'" == "all" {
      #delimit;
      coefplot iv_*
      , xline(0, lwidth(thin) lpattern(dash) lcolor(red)) keep(`t'_chart*) levels(95)
      msymbol(circle) mcolor(navy) msize(medsmall) legend(off) ciopts(recast(rcap)
      lwidth(thin) lcolor(navy)) grid(none) offset(0) format(%03.2f)
      ylabel( , labsize(vsmall) angle(horizontal))
      xlabel(-0.20(0.05)0.20, labsize(small) angle(horizontal))
      xsize(5.5) ysize(6.5);
      #delimit cr

      graph save   "iv_`file_name'.gph", replace
      graph export "iv_`file_name'.pdf", replace as(pdf)
      drop `t'_chart*
    }

    *** First stage:
    if "`plot'" == "all" {
      #delimit;
      coefplot fs_*
      , xline(0, lwidth(thin) lpattern(dash) lcolor(red)) keep(`iv'_chart*) levels(95)
      msymbol(circle) mcolor(navy) msize(medsmall) legend(off) ciopts(recast(rcap)
      lwidth(thin) lcolor(navy)) grid(none) offset(0) format(%03.2f)
      ylabel( , labsize(vsmall) angle(horizontal))
      xlabel(-0.05(0.05)0.25, labsize(small) angle(horizontal))
      xsize(5.5) ysize(6.5);
      #delimit cr

      graph save   "fs_`file_name'.gph", replace
      graph export "fs_`file_name'.pdf", replace as(pdf)
      drop `iv'_chart*
    }
  }

  *** Vertical
  if "`plot_opts'" == "vertical" {

    *** Reduced form:
    if "`plot'" == "rf" | "`plot'" == "all" {
      #delimit;
      coefplot m_*
      , vertical yline(0, lwidth(thin) lpattern(dash) lcolor(red)) keep(`iv'_chart*) levels(95)
      msymbol(circle) mcolor(navy) msize(medsmall) legend(off) ciopts(recast(rcap)
      lwidth(thin) lcolor(navy)) grid(none) offset(0) format(%03.2f)
      xlabel( , labsize(vsmall) angle(horizontal))
      ylabel(-0.05(0.05)0.05, labsize(small) angle(horizontal))
      xsize(6.5) ysize(5.5);
      #delimit cr

      graph save   "rf_`file_name'.gph", replace
      graph export "rf_`file_name'.pdf", replace as(pdf)
      if "`plot'" == "rf"   drop `iv'_chart*
    }

    *** 2sls:
    if "`plot'" == "iv" | "`plot'" == "all" {
      #delimit;
      coefplot iv_*
      , vertical yline(0, lwidth(thin) lpattern(dash) lcolor(red)) keep(`t'_chart*) levels(95)
      msymbol(circle) mcolor(navy) msize(medsmall) legend(off) ciopts(recast(rcap)
      lwidth(thin) lcolor(navy)) grid(none) offset(0) format(%03.2f)
      xlabel( , labsize(vsmall) angle(horizontal))
      ylabel(-0.20(0.05)0.20, labsize(small) angle(horizontal))
      xsize(6.5) ysize(5.5);
      #delimit cr

      graph save   "iv_`file_name'.gph", replace
      graph export "iv_`file_name'.pdf", replace as(pdf)
      drop `t'_chart*
    }

    *** First stage:
    if "`plot'" == "all" {
      #delimit;
      coefplot fs_*
      , vertical yline(0, lwidth(thin) lpattern(dash) lcolor(red)) keep(`iv'_chart*) levels(95)
      msymbol(circle) mcolor(navy) msize(medsmall) legend(off) ciopts(recast(rcap)
      lwidth(thin) lcolor(navy)) grid(none) offset(0) format(%03.2f)
      xlabel( , labsize(vsmall) angle(horizontal))
      ylabel(-0.05(0.05)0.25, labsize(small) angle(horizontal))
      xsize(6.5) ysize(5.5);
      #delimit cr

      graph save   "fs_`file_name'.gph", replace
      graph export "fs_`file_name'.pdf", replace as(pdf)
      drop `iv'_chart*
    }
  }

end

********************************************************************************
*** Program to clean string names:
********************************************************************************
capture program drop clean_name
program define clean_name

	args var_name

	replace `var_name' = subinstr(`var_name', "Á", "A", .)
	replace `var_name' = subinstr(`var_name', "À", "A", .)

	replace `var_name' = subinstr(`var_name', "É", "E", .)
	replace `var_name' = subinstr(`var_name', "È", "E", .)

	replace `var_name' = subinstr(`var_name', "Í", "I", .)
	replace `var_name' = subinstr(`var_name', "Ì", "I", .)

	replace `var_name' = subinstr(`var_name', "Ó", "O", .)
	replace `var_name' = subinstr(`var_name', "Ò", "O", .)

	replace `var_name' = subinstr(`var_name', "Ú", "U", .)
	replace `var_name' = subinstr(`var_name', "Ù", "U", .)
	replace `var_name' = subinstr(`var_name', "Ü", "U", .)

	replace `var_name' = subinstr(`var_name', "Ñ", "N",.)
	replace `var_name' = subinstr(`var_name', "'", "",.)

	replace `var' = "PONTIFICIA UNIVERSIDAD CATOLICA DE CHILE" if strpos(`var', "PONTIFICIA") > 0 & strpos(`var', "CHILE") > 0
	replace `var' = "UNIVERSIDAD ADOLFO IBANEZ" if strpos(`var', "UNIVERSIDAD ADOLFO") > 0
	replace `var' = "UNIVERSIDAD AUSTRAL DE CHILE" if strpos(`var', "UNIVERSIDAD AUSTRAL") > 0
	replace `var' = "UNIVERSIDAD CATOLICA SILVA HENRIQUEZ" if strpos(`var', "UNIVERSIDAD") > 0 & strpos(`var', "CARDENAL") > 0
	replace `var' = "UNIVERSIDAD CATOLICA DEL NORTE" if strpos(`var', "UNIVERSIDAD CAT") > 0 & strpos(`var', "DEL NORTE") > 0
	replace `var' = "UNIVERSIDAD CIENCIAS DE LA INFORMATICA" if strpos(`var', "UNIVERSIDAD CIENCIAS DE LA INFOR") > 0
	replace `var' = "UNIVERSIDAD DE ARTE Y CIENCIAS SOCIALES ARCIS" if strpos(`var', "UNIVERSIDAD DE ARTE Y CIENCIAS SOCIALES") > 0 & strpos(`var', "ARCIS") > 0
	replace `var' = "UNIVERSIDAD UNIACC" if strpos(`var', "UNIVERSIDAD DE ARTES, CIENCIAS Y COMUNICACION - UNIACC") > 0
	replace `var' = "UNIVERSIDAD DE CONCEPCION" if strpos(`var', "UNIVERSIDAD DE CONCEPCI") > 0
	replace `var' = "UNIVERSIDAD DE LAS AMERICAS" if strpos(`var', "UNIVERSIDAD DE LAS AM") > 0
	replace `var' = "UNIVERSIDAD DE PLAYA ANCHA DE CIENCIAS DE LA EDUCACION" if strpos(`var', "UNIVERSIDAD DE PLAYA ANCHA") > 0
	replace `var' = "UNIVERSIDAD DE VINA DEL MAR" if strpos(`var', "UNIVERSIDAD DE VI") > 0
	replace `var' = "UNIVERSIDAD DEL PACIFICO" if strpos(`var', "UNIVERSIDAD DEL PA") > 0
	replace `var' = "UNIVERSIDAD SEK" if strpos(`var', "UNIVERSIDAD INTERNACIONAL SEK") > 0
	replace `var' = "UNIVERSIDAD UCINF" if strpos(`var', "UNIVERSIDAD CIENCIAS DE LA INFORMATICA") > 0

	forvalues x = 1/10{
		replace `var_name' = subinstr(`var_name', "  ", " ",.)
	}

	replace `var_name' = strtrim(`var_name')

end
