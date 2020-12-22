/*******************************************************************************

									PSU SES

	Generate datasets with variables characterizing individuals registered
	for the PSU.

*******************************************************************************/
forvalues x = 2004/2016{

	import delimited "${input_path}${dash}B_SOCIOECONOMICO_DOMICILIO_PSU_`x'_PRIV_MRUN.csv", delimiter(";") varnames(1) encoding(ISO-8859-1) clear

	#delimit;
	keep mrun año_proceso
	estado_civil tiene_trabajo_rem horario_trabajo horas_que_dedica_trabajo
	viven_sus_padres de_proseguir_estudios
	grupo_familiar cuantos_trabajan_del_grupo_famil quien_es_el_jefe_familia
	cuantos_estudian_grupo_familiar_ v14 v15 v16 v17 v18
	ingreso_bruto_fam cobertura_salud educacion_padre educacion_madre
	situacion_ocupacional_padre situacion_ocupacional_madre
	codigo_region codigo_provincia codigo_comuna nombre_provincia nombre_comuna ciudad;
	#delimit cr;

	rename(cuantos_estudian_grupo_familiar_ v14 v15 v16 v17 v18)(fg_preschoolEd fg_primaryEd fg_secondaryEd fg_secondary4Ed fg_higherEd fg_otherEd)

	label define cstatus    0 "No information" 1 "Single" 2 "Married" 3 "Divorced"  4 "Widow"
	label values estado_civil cstatus
	label variable estado_civil "Civil status"

	label define wstatus    0 "No information" 1 "No"  2 "Sometimes" 3 "Yes, always"
	label values tiene_trabajo_rem wstatus
	label variable tiene_trabajo_rem "Has a paid job?"

	label define wschedule  0 "No information" 1 "Day"  2 "Evening"  3 "Night"  4 "No fix schedule"
	label values horario_trabajo wschedule
	label variable horario_trabajo "Work schedule"

	label define alive_par 0 "No information" 1 "Both alive" 2 "Just mother" 3 "Just father" 4 "None of them"
	label values viven_sus_padres alive_par
	label variable viven_sus_padres "Parents alive?"

	label define lwith		0 "No information" 1 "Parents" 2 "Relatives" 3 "Independently" 4 "Student acomodation" 5 "Others"
	label values de_proseguir_estudios lwith
	label variable de_proseguir_estudios "Lives with"

	label define hh			0 "No information" 1 "Father"  2 "Mother"  3 "The applicant" 4  "Applicant's Spouse"  5 "Other relative"  6 "Other person" 7 "Grandparent" 8 "Sibling"
	label values quien_es_el_jefe_familia hh
	label variable quien_es_el_jefe_familia "Household head"

	label define health     0 "No information" 1 "FONASA"  2 "ISAPRE"	 3 "Other"		   4 "DIPRECA"			   5 "CAPREDENA"
	label values cobertura_salud health
	label variable cobertura_salud "Health insurance"

	label define par_edu    0 "No information" 1 "No studies" 2 "Incomplete primary" 3 "Primary" 4 "Incomplete secondary" 5 "Secondary" 6 "Incomplete CFT" 7 "CFT" 8 "Incomplete University" 9 "University" 10 "Other studies" 11 "Incomplete IP" 12 "Complete IP"
	replace educacion_padre = 0 if educacion_padre == 13
	label values educacion_padre par_edu
	label variable educacion_padre "Father's Education"

	replace educacion_madre = 0 if educacion_madre == 13
	label values educacion_madre par_edu
	label variable educacion_madre "Mother's Education"

	generate parental_ed = 1 if educacion_padre <= 3  & educacion_madre <=3
	replace  parental_ed = 2 if educacion_padre <= 5  & educacion_madre <= 5 & parental_ed != 1
	replace  parental_ed = 3 if educacion_padre == 10 & educacion_madre <=7  & parental_ed != 1 & parental_ed != 2
	replace  parental_ed = 3 if educacion_madre == 10 & educacion_padre <=7  & parental_ed != 1 & parental_ed != 2 & parental_ed != 3
	replace  parental_ed = 4 if educacion_padre <= 7 & educacion_madre <= 7  & parental_ed != 1 & parental_ed != 2 & parental_ed != 3
	replace  parental_ed = 6 if educacion_padre <= 9 & educacion_madre <= 9  & parental_ed != 1 & parental_ed != 2 & parental_ed != 3 & parental_ed != 4
	replace  parental_ed = 5 if educacion_padre <= 12 & educacion_madre <= 12  & parental_ed != 1 & parental_ed != 2 & parental_ed != 3 & parental_ed != 4 & parental_ed != 6
	replace  parental_ed =.  if educacion_padre == 0 & educacion_madre == 0

	label define par_edu2 1 "Primary education or less" 2 "Secondary education" 3 "Other" 4 "CFT" 5 "IP" 6 "University"
	label values parental_ed par_edu2


	if `x' < 2008{
		#delimit;
		label define inc 1 "$278.000 or less" 2 "$278,001-$834,000" 3 "$834,001-$1,400,000" 4 "$1.400,001-$1,950,000"
		5 "$1,950,001-$2,500,000" 6 "$2,500,001 or more";
		#delimit cr;

		generate lowIncome = ingreso_bruto_fam == 1
		replace  lowIncome = . if ingreso_bruto_fam < 1 | ingreso_bruto_fam > 6

		generate midIncome = ingreso_bruto_fam == 2
		replace  midIncome = . if ingreso_bruto_fam < 1 | ingreso_bruto_fam > 6

		generate highIncome = ingreso_bruto_fam >= 3
		replace  highIncome = . if ingreso_bruto_fam < 1 | ingreso_bruto_fam > 6
	}

	if `x' == 2008{
		#delimit;
		label define inc 1 "$135,000 or less" 2 "$135,001-$270,000" 3 "$270,001-$405,000" 4 "$405,001-$540,000"
		5 "$540,001-$675,000" 6 "$675,001-$810,000" 7 "$810,001-$1,080,000" 8 "$1,080,001 or more";
		#delimit cr;

		generate lowIncome = ingreso_bruto_fam <= 2
		replace  lowIncome = . if ingreso_bruto_fam < 1 | ingreso_bruto_fam > 8

		generate midIncome = ingreso_bruto_fam >= 3 & ingreso_bruto_fam <= 6
		replace  midIncome = . if ingreso_bruto_fam < 1 | ingreso_bruto_fam > 8

		generate highIncome = ingreso_bruto_fam >= 7
		replace  highIncome = . if ingreso_bruto_fam < 1 | ingreso_bruto_fam > 8
	}

	if `x' >= 2009{
		#delimit;
		label define inc 1 "$144,000 or less" 2 "$144,001-$288,000" 3 "$288,001-$432,000" 4 "$432,001-$576,000"
		5 "$576,001-$720,000" 6 "$720,001-$864,000" 7 "$864,001-$1,008,000" 8 "$1,008,001-$1,152,000"
		9 "$1,152,001-$1,296,000" 10 "$1,296,001-$1,440,000" 11 "$1,440,001-$1,584,000"
		12 "$1,584,001 or more";
		#delimit cr;

		generate lowIncome = ingreso_bruto_fam <= 2
		replace  lowIncome = . if ingreso_bruto_fam < 1 | ingreso_bruto_fam > 12

		generate midIncome = ingreso_bruto_fam >= 3 & ingreso_bruto_fam <= 6
		replace  midIncome = . if ingreso_bruto_fam < 1 | ingreso_bruto_fam > 12

		generate highIncome = ingreso_bruto_fam >= 7
		replace  highIncome = . if ingreso_bruto_fam < 1 | ingreso_bruto_fam > 12

	}

	label values ingreso_bruto_fam inc
	save "${temp_path}${dash}psu_ses`x'.dta", replace
}
