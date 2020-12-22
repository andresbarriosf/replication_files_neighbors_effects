/*******************************************************************************

																PSU SCORES

	Generate datasets with psu scores and variables to count the number of
	individuals registered for the PSU each year in the regions that I study.

*******************************************************************************/

*** PSU Performance
forvalues x = 2004/2016{

	import delimited "${input_path}${dash}A_INSCRITOS_PUNTAJES_PSU_`x'_PRIV_MRUN.csv", delimiter(";") varnames(1) encoding(ISO-8859-1) clear

	gen agno = año_proceso - 1

	#delimit;
	destring mrun año_proceso cod_sexo rbd codigo_enseñanza grupo_dependencia codigo_region codigo_comuna
	año_egreso promedio_notas ptje_nem ptje_ranking lyc* mate* hycs* ciencias* promlm*, replace;
	#delimit cr;

	tostring fecha_nacimiento rama_educacional nombre_* bea, replace

	gen psu_anterior = (mate_anterior >= 150 & mate_anterior <= 850 & lyc_anterior >= 150 & lyc_anterior <= 850)

	#delimit;
	keep mrun año_proceso cod_sexo fecha_nacimiento  rama_educacional
	rbd  grupo_dependencia
	codigo_region nombre_region codigo_comuna nombre_comuna
	año_egreso promedio_notas ptje_nem ptje_ranking
	lyc_actual mate_actual hycs_actual ciencias_actual promlm_actual bea psu_anterior;
	#delimit cr;

	#delimit;
	order mrun año_proceso cod_sexo fecha_nacimiento rama_educacional
	rbd  grupo_dependencia
	codigo_region nombre_region codigo_comuna nombre_comuna
	año_egreso promedio_notas ptje_nem ptje_ranking
	lyc_actual mate_actual hycs_actual ciencias_actual promlm_actual bea psu_anterior;
	#delimit cr;

	compress
	save "${temp_path}${dash}psu_scores`x'.dta", replace
}
