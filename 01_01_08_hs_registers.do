/*******************************************************************************

							           HIGH SCHOOL VARIABLES

	Individuals completing high school between 2002-2015.

	(1) Schools' characteristics.
	(2) Individuals' attendance and performance: grade 12
	(3) Individuals' municipality in grade 12.
	(4) Individuals' municipality in grade 9.
	(4) Individuals' performance in grades 9-11.

*******************************************************************************/

*** 1.1 High School Graduates:
*** 1.1.1 All years but 2004 and 2006:
foreach x of numlist 2002 2003 2005 2007 2008 2009 2010 2011 2012 2013 2014 2015{

	import delimited "${input_path}${dash}Rendimiento_estudiantes_`x'.csv", delimiter(";") varnames(1) encoding(ISO-8859-1) clear

	destring mrun gen_alu cod_com_alu rbd cod_reg_rbd cod_com_rbd rural_rbd cod_depe cod_ense cod_grado, replace
	destring prom_gral asistencia, replace dpcomma
	tostring fec_nac_alu nom_com_alu nom_com_rbd let_cur sit_fin, replace

		if `x' == 2014{
			rename sit_final_r sit_fin_r
		}

	*Keep observations of students in their last year of high school:
	keep if cod_ense  >= 310 & cod_ense !=.
	keep if cod_grado == 4 | (cod_ense == 363 & cod_grado == 3)
	replace cod_grado = 4

	*Dealing with repeated observations:
	duplicates tag mrun, gen(rep)

	*Drop duplicates that appear as repeating or transfering if we observe at
	*least once the student passing:
	generate fs = 1 if sit_fin == "P"
	replace  fs = 2 if sit_fin == "R"
	replace  fs = 3 if sit_fin == "T"
	bys mrun: egen minFS = min(fs)

	drop if rep >= 1 & minFS == 1 & fs > 1
	drop rep fs minFS

	*Drop randomly observations that appear twice in the same school.
	duplicates drop mrun rbd, force

	*Generate some variables maybe useful later:
	bys rbd: egen nstudents_rbd = count(mrun)
	bys rbd cod_ense: egen nstudents_ense  = count(mrun)
	bys rbd let_cur	: egen nstudents_class = count(mrun)

	duplicates tag mrun, gen(rep)
	drop if rep >= 1
	drop rep

	#delimit;
	order mrun gen_alu fec_nac_alu
		  cod_com_alu nom_com_alu
		  rbd cod_reg_rbd cod_com_rbd nom_com_rbd rural_rbd cod_depe rural_rbd
		  cod_ense cod_grado let_cur prom_gral asistencia sit_fin
		  nstudents_rbd nstudents_ense nstudents_class;
	#delimit cr;

	#delimit;
	keep mrun gen_alu fec_nac_alu
		  cod_com_alu nom_com_alu
		  rbd cod_reg_rbd cod_com_rbd nom_com_rbd rural_rbd cod_depe
		  cod_ense cod_grado let_cur prom_gral asistencia sit_fin
		  nstudents_rbd nstudents_ense nstudents_class;
	#delimit cr;

	generate año_egreso = `x'
	generate agno = `x'
	compress

	save "${temp_path}${dash}egresadosHS_`x'.dta", replace
}

*** (1.1.2) 2004:
import delimited "${input_path}${dash}Rendimiento_estudiantes_2004.csv", delimiter(";") varnames(1) encoding(ISO-8859-1) clear

rename (dvrbd codense codgrado letra año sexo fechanac sit_final)(dgv_rbd cod_ense cod_grado let_cur agno gen_alu fec_nac_alu sit_fin)

destring mrun gen_alu rbd cod_ense cod_grado, replace
destring prom_gral asistencia, replace dpcomma
tostring fec_nac_alu let_cur sit_fin, replace

keep if cod_ense  >= 310 & cod_ense !=.
keep if cod_grado == 4 | (cod_ense == 363 & cod_grado == 3)
replace cod_grado = 4

*Dealing with repeated observations:
duplicates tag mrun, gen(rep)

*Drop duplicates that appear as repeating or transfering if we observe at
*least once the student passing:
generate fs = 1 if sit_fin == "P"
replace  fs = 2 if sit_fin == "R"
replace  fs = 3 if sit_fin == "T"
bys mrun: egen minFS = min(fs)

drop if rep >= 1 & minFS == 1 & fs > 1
drop rep fs minFS

*Generate some variables maybe useful later:
bys rbd: egen nstudents_rbd = count(mrun)
bys rbd cod_ense: egen nstudents_ense  = count(mrun)
bys rbd let_cur	: egen nstudents_class = count(mrun)

duplicates tag mrun, gen(rep)
drop if rep >= 1
drop rep

merge m:1 rbd using "${input_path}${dash}School Directory (2004).dta"
drop if _merge == 2
drop _merge

generate cod_reg_rbd = 1  if cod_com_rbd >= 1000  & cod_com_rbd < 2000
replace  cod_reg_rbd = 2  if cod_com_rbd >= 2000  & cod_com_rbd < 3000
replace  cod_reg_rbd = 3  if cod_com_rbd >= 3000  & cod_com_rbd < 4000
replace  cod_reg_rbd = 4  if cod_com_rbd >= 4000  & cod_com_rbd < 5000
replace  cod_reg_rbd = 5  if cod_com_rbd >= 5000  & cod_com_rbd < 6000
replace  cod_reg_rbd = 6  if cod_com_rbd >= 6000  & cod_com_rbd < 7000
replace  cod_reg_rbd = 7  if cod_com_rbd >= 7000  & cod_com_rbd < 8000
replace  cod_reg_rbd = 8  if cod_com_rbd >= 8000  & cod_com_rbd < 9000
replace  cod_reg_rbd = 9  if cod_com_rbd >= 9000  & cod_com_rbd < 10000
replace  cod_reg_rbd = 10 if cod_com_rbd >= 10000 & cod_com_rbd < 11000
replace  cod_reg_rbd = 11 if cod_com_rbd >= 11000 & cod_com_rbd < 12000
replace  cod_reg_rbd = 12 if cod_com_rbd >= 12000 & cod_com_rbd < 13000
replace  cod_reg_rbd = 13 if cod_com_rbd >= 13000 & cod_com_rbd < 14000

#delimit;
order mrun gen_alu fec_nac_alu
  rbd cod_reg_rbd cod_com_rbd nom_com_rbd rural_rbd cod_depe rural_rbd
  cod_ense cod_grado let_cur prom_gral asistencia sit_fin
  nstudents_rbd nstudents_ense nstudents_class;
#delimit cr;

#delimit;
keep mrun gen_alu fec_nac_alu
  rbd cod_reg_rbd cod_com_rbd nom_com_rbd rural_rbd cod_depe
  cod_ense cod_grado let_cur prom_gral asistencia sit_fin
  nstudents_rbd nstudents_ense nstudents_class;
#delimit cr;

destring cod_reg_rbd cod_com_rbd rural_rbd cod_depe, replace
tostring nom_com_rbd, replace

gen año_egreso = 2004
gen agno = 2005
compress

save "${temp_path}${dash}egresadosHS_2004.dta", replace

*** (1.1.3) 2006:
import delimited "${input_path}${dash}Rendimiento_estudiantes_2006.csv", delimiter(";") varnames(1) encoding(ISO-8859-1) clear

rename (dvrbd cod_ens cod_grado letra año sexo fechanac sit_final)(dgv_rbd cod_ense cod_grado let_cur agno gen_alu fec_nac_alu sit_fin)
destring mrun gen_alu rbd cod_ense cod_grado, replace
destring prom_gral asistencia, replace dpcomma
tostring fec_nac_alu let_cur sit_fin, replace

keep if cod_ense  >= 310 & cod_ense !=.
keep if cod_grado == 4 | (cod_ense == 363 & cod_grado == 3)
replace cod_grado = 4

*Dealing with repeated observations:
duplicates tag mrun, gen(rep)

*Drop duplicates that appear as repeating or transfering if we observe at
*least once the student passing:
generate fs = 1 if sit_fin == "P"
replace  fs = 2 if sit_fin == "R"
replace  fs = 3 if sit_fin == "T"
bys mrun: egen minFS = min(fs)

drop if rep >= 1 & minFS == 1 & fs > 1
drop rep fs minFS

*Generate some variables maybe useful later:
bys rbd: egen nstudents_rbd = count(mrun)
bys rbd cod_ense: egen nstudents_ense  = count(mrun)
bys rbd let_cur	: egen nstudents_class = count(mrun)

duplicates tag mrun, gen(rep)
drop if rep >= 1
drop rep

merge m:1 rbd using "${input_path}${dash}School Directory (2006).dta"
drop if _merge == 2
drop _merge

#delimit;
order mrun gen_alu fec_nac_alu
  rbd cod_reg_rbd cod_com_rbd nom_com_rbd rural_rbd cod_depe rural_rbd
  cod_ense cod_grado let_cur prom_gral asistencia sit_fin
  nstudents_rbd nstudents_ense nstudents_class;
#delimit cr;

#delimit;
keep mrun gen_alu fec_nac_alu
  rbd cod_reg_rbd cod_com_rbd nom_com_rbd rural_rbd cod_depe
  cod_ense cod_grado let_cur prom_gral asistencia sit_fin
  nstudents_rbd nstudents_ense nstudents_class;
#delimit cr;

destring cod_reg_rbd cod_com_rbd rural_rbd cod_depe, replace
tostring nom_com_rbd, replace

gen año_egreso = 2006
gen agno = 2006
compress
save "${temp_path}${dash}egresadosHS_2006.dta", replace

*** 1.2. 9th Graders ***********************************************************
foreach x of numlist 2002 2003 2005 2007 2008 2009 2010 2011 2012 2013 2014{

	import delimited "${input_path}${dash}Rendimiento_estudiantes_`x'.csv", delimiter(";") clear

	keep if cod_grado == 1
	keep if sit_fin   == "P"

	#delimit;
	keep if cod_ense == 310 | cod_ense == 410 | cod_ense == 510 | cod_ense == 610
	| cod_ense == 710 | cod_ense == 810 | cod_ense == 910;
	#delimit cr;

	#delimit;
	keep agno mrun gen_alu fec_nac_alu rbd cod_reg_rbd cod_com_rbd nom_com_rbd
	cod_depe rural_rbd cod_ense cod_grado cod_com_alu nom_com_alu prom_gral
	asistencia sit_fin;
	#delimit cr

	duplicates drop
	destring mrun, replace
	drop if mrun ==.

	tostring fec_nac_alu, replace
	gen year  = substr(fec_nac_alu,1,4)
	gen month = substr(fec_nac_alu,5,2)
	gen day   = substr(fec_nac_alu,7,2)
	destring year month day, replace

	duplicates drop mrun gen_alu fec_nac_alu, force

	bys rbd: gen nstudents = _N

	destring prom_gral, replace dpcomma
	bys rbd: egen rank_g9   = rank(prom_gral), unique
	gen percentile  = rank_g9/nstudents

	gen decile   =.
	gen veintile =.

	forvalues y = 1/20{

		local lb = (`y'-1)/10
		local ub = `y'/10

		local lb2 = (`y'-1)/20
		local ub2 = `y'/20

		if `y' <= 10 {

			replace decile = `y' if percentile >=  `lb' & percentile <= `ub' & decile ==. & nstudents >= 10
		}

		replace veintile = `y' if percentile >=  `lb2' & percentile <= `ub2' & veintile ==. & nstudents >= 20

	}

	compress
	save "${temp_path}${dash}grade9_`x'.dta", replace

}

*** 2004:
import delimited "${input_path}${dash}Rendimiento_estudiantes_2004.csv", delimiter(";") clear

rename(codense codgrado año sexo fechanac sit_final)(cod_ense cod_grado agno gen_alu fec_nac_alu sit_fin)
replace agno = 2004

keep if cod_grado == 1
keep if sit_fin   == "P"

#delimit;
keep if cod_ense == 310 | cod_ense == 410 | cod_ense == 510 | cod_ense == 610
| cod_ense == 710 | cod_ense == 810 | cod_ense == 910;
#delimit cr;

merge m:1 rbd using "${input_path}${dash}School Directory (2004).dta"

#delimit;
keep agno mrun gen_alu fec_nac_alu rbd cod_com_rbd nom_com_rbd
cod_depe rural_rbd cod_ense cod_grado prom_gral asistencia sit_fin;
#delimit cr

duplicates drop
destring mrun, replace
drop if mrun ==.

tostring fec_nac_alu, replace
split(fec_nac_alu), gen(dob_)
gen year  = dob_3
gen month = 1 if dob_1 == "Jan"
replace month = 2 if dob_1 == "Feb"
replace month = 3 if dob_1 == "Mar"
replace month = 4 if dob_1 == "Apr"
replace month = 5 if dob_1 == "May"
replace month = 6 if dob_1 == "Jun"
replace month = 7 if dob_1 == "Jul"
replace month = 8 if dob_1 == "Aug"
replace month = 9 if dob_1 == "Sep"
replace month = 10 if dob_1 == "Oct"
replace month = 11 if dob_1 == "Nov"
replace month = 12 if dob_1 == "Dec"
gen day   = dob_2
destring year month day, replace

duplicates drop mrun gen_alu fec_nac_alu, force

bys rbd: gen nstudents = _N

destring prom_gral, replace dpcomma
bys rbd: egen rank_g9   = rank(prom_gral), unique
gen percentile  = rank_g9/nstudents

gen decile   =.
gen veintile =.

forvalues y = 1/20{

	local lb = (`y'-1)/10
	local ub = `y'/10

	local lb2 = (`y'-1)/20
	local ub2 = `y'/20

	if `y' <= 10 {

		replace decile = `y' if percentile >=  `lb' & percentile <= `ub' & decile ==. & nstudents >= 10
	}

	replace veintile = `y' if percentile >=  `lb2' & percentile <= `ub2' & veintile ==. & nstudents >= 20

}

compress
save "${temp_path}${dash}grade9_2004.dta", replace

*** 2006:
import delimited "${input_path}${dash}Rendimiento_estudiantes_2006.csv", delimiter(";") clear

rename(cod_ens cod_grado año sexo fechanac sit_final)(cod_ense cod_grado agno gen_alu fec_nac_alu sit_fin)
replace agno = 2006

keep if cod_grado == 1
keep if sit_fin   == "P"

#delimit;
keep if cod_ense == 310 | cod_ense == 410 | cod_ense == 510 | cod_ense == 610
| cod_ense == 710 | cod_ense == 810 | cod_ense == 910;
#delimit cr;

merge m:1 rbd using "${input_path}${dash}School Directory (2006).dta"

#delimit;
keep agno mrun gen_alu fec_nac_alu rbd cod_com_rbd nom_com_rbd
cod_depe rural_rbd cod_ense cod_grado prom_gral asistencia sit_fin;
#delimit cr

duplicates drop
destring mrun, replace
drop if mrun ==.

tostring fec_nac_alu, replace
split(fec_nac_alu), gen(dob_)
gen year  = dob_3
gen month = 1 if dob_1 == "Jan"
replace month = 2 if dob_1 == "Feb"
replace month = 3 if dob_1 == "Mar"
replace month = 4 if dob_1 == "Apr"
replace month = 5 if dob_1 == "May"
replace month = 6 if dob_1 == "Jun"
replace month = 7 if dob_1 == "Jul"
replace month = 8 if dob_1 == "Aug"
replace month = 9 if dob_1 == "Sep"
replace month = 10 if dob_1 == "Oct"
replace month = 11 if dob_1 == "Nov"
replace month = 12 if dob_1 == "Dec"
gen day   = dob_2
destring year month day, replace

duplicates drop mrun gen_alu fec_nac_alu, force

bys rbd: gen nstudents = _N

destring prom_gral, replace dpcomma
bys rbd: egen rank_g9   = rank(prom_gral), unique
gen percentile  = rank_g9/nstudents

gen decile   =.
gen veintile =.

forvalues y = 1/20{

	local lb = (`y'-1)/10
	local ub = `y'/10

	local lb2 = (`y'-1)/20
	local ub2 = `y'/20

	if `y' <= 10 {

		replace decile = `y' if percentile >=  `lb' & percentile <= `ub' & decile ==. & nstudents >= 10
	}

	replace veintile = `y' if percentile >=  `lb2' & percentile <= `ub2' & veintile ==. & nstudents >= 20

}

compress
save "${temp_path}${dash}grade9_2006.dta", replace


forvalues x = 2002/2012 {

	use grade9_`x'.dta, clear

	bys mrun: egen max = max(asistencia)
	duplicates tag mrun, gen(rep)
	drop if asistencia < max & rep >= 1
	drop rep max

	bys mrun: egen max = max(prom_gral)
	duplicates tag mrun, gen(rep)
	drop if prom_gral < max & rep >= 1
	drop rep max

	duplicates drop mrun, force

	save, replace

}
