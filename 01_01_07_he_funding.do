/*******************************************************************************

						        FUNDING FOR HIGHER EDUCATION

				Funding for higher education between 2006-2016

				(1) Scholarships
				(2) CAE
				(3) FSCU

*******************************************************************************/

*** CAE (2006-2016)
import delimited "${input_path}${dash}20170609_BASE 1.1 TABLA DE CRÉDITOS HISTÓRICA 2006 - 2016_PUBL.csv", delimiter(";") varnames(1) encoding(ISO-8859-1) clear
bys mrun ano_licitacion: egen count_cae = rank(ano_operacion), track

#delimit;
keep mrun genero ano_licitacion ano_operacion
monto_credito_uf tipo_ies_cod esn_cod sede_cod
carrera_cod nombre_ies nombre_sede nombre_carrera
anos_duracion_carrera areal_carrera aref_carrera
plazo_credito situacion quintil arancel_solicitado count_cae;
#delimit cr;

forvalues x = 2006/2016{
	preserve
	keep if ano_licitacion == `x' & ano_operacion == `x'
	drop ano_operacion count_cae
	save "${temp_path}${dash}cae_`x'.dta", replace
	restore
}

save "${temp_path}${dash}cae_0616.dta", replace

*** FUAS: Scholarships and FSCU (2006-2016)
forvalues x = 2006/2016{
	*** A. Applicants
	import delimited "${input_path}${dash}20170602_POSTULACIONES_FUAS_`x'_PUBL.csv", delimiter(";") varnames(1) encoding(ISO-8859-1) clear
	save "${temp_path}${dash}fuas_application`x'.dta", replace

	*** B. Beneficiaries
	import delimited "${input_path}${dash}Asignacion `x' PA_MRUN.csv", delimiter(";") varnames(1) encoding(ISO-8859-1) clear
	bys mrun: gen contador = _n
	reshape wide beneficio_becaofscu, i(mrun) j(contador)
	save "${temp_path}${dash}fuas_assignacion`x'.dta", replace
}

*** Combine datasets
forvalues x = 2006/2016{

	use "${temp_path}${dash}fuas_application`x'.dta", clear
	duplicates drop mrun, force

	merge 1:1 mrun using "${temp_path}${dash}fuas_assignacion`x'.dta"
	drop _merge

	merge 1:1 mrun using "${temp_path}${dash}cae_`x'.dta"
	drop _merge

	*Beneficios:
	generate fscu  = beneficio1 == "FSCU" | beneficio2 == "FSCU" | beneficio3 == "FSCU"
	generate cae1  = ano_licitacion == `x'
	generate cae2  = ano_licitacion == `x' & (tipo_ies_cod == 0 | tipo_ies_cod == 1)

	#delimit;
	generate beca1 = beneficio1 == "BBIC" | beneficio1 == "BJGM" | beneficio1 ==  "BJGME" | beneficio1 == "BPED" | beneficio1 == "BVP"  | beneficio1 == "BVP2" | beneficio1 == "BPSU" | beneficio1 == "GRATUIDAD" | beneficio1 == "ART" | beneficio1 == "BNA" | beneficio1 == "BHPE" | beneficio1 == "BEA" | beneficio1 == "BET" | beneficio1 == "BNM" | beneficio1 == "BNM I" | beneficio1 == "BNM II" | beneficio1 == "BNM III" |
					 beneficio2 == "BBIC" | beneficio2 == "BJGM" | beneficio2 ==  "BJGME" | beneficio2 == "BPED" | beneficio2 == "BVP"  | beneficio2 == "BVP2" | beneficio2 == "BPSU" | beneficio2 == "GRATUIDAD" | beneficio2 == "ART" | beneficio2 == "BNA" | beneficio2 == "BHPE" | beneficio2 == "BEA" | beneficio2 == "BET" | beneficio2 == "BNM" | beneficio2 == "BNM I" | beneficio2 == "BNM II" | beneficio2 == "BNM III" |
					 beneficio3 == "BBIC" | beneficio3 == "BJGM" | beneficio3 ==  "BJGME" | beneficio3 == "BPED" | beneficio3 == "BVP"  | beneficio3 == "BVP3" | beneficio3 == "BPSU" | beneficio3 == "GRATUIDAD" | beneficio3 == "ART" | beneficio3 == "BNA" | beneficio3 == "BHPE" | beneficio3 == "BEA" | beneficio3 == "BET" | beneficio3 == "BNM" | beneficio3 == "BNM I" | beneficio3 == "BNM II" | beneficio3 == "BNM III" ;
	#delimit cr;

	#delimit;
	generate beca2 = beneficio1 == "BBIC" | beneficio1 == "BJGM" | beneficio1 ==  "BJGME" | beneficio1 == "BPED" | beneficio1 == "BVP"  | beneficio1 == "BVP2" | beneficio1 == "BPSU" | beneficio1 == "GRATUIDAD" | beneficio1 == "ART" | beneficio1 == "BNA" | beneficio1 == "BEA" |
					 beneficio2 == "BBIC" | beneficio2 == "BJGM" | beneficio2 ==  "BJGME" | beneficio2 == "BPED" | beneficio2 == "BVP"  | beneficio2 == "BVP2" | beneficio2 == "BPSU" | beneficio2 == "GRATUIDAD" | beneficio2 == "ART" | beneficio2 == "BNA" | beneficio2 == "BEA" |
					 beneficio3 == "BBIC" | beneficio3 == "BJGM" | beneficio3 ==  "BJGME" | beneficio3 == "BPED" | beneficio3 == "BVP"  | beneficio3 == "BVP3" | beneficio3 == "BPSU" | beneficio3 == "GRATUIDAD" | beneficio3 == "ART" | beneficio3 == "BNA" | beneficio3 == "BEA" ;
	#delimit cr;

	*Variables to keep
	keep mrun año_proceso quintil_fuas genero_fuas año_nac_alu fscu cae1 cae2 beca1 beca2 tipo_ies_cod
	replace año_proceso = `x'

	save "${temp_path}${dash}beneficios`x'.dta", replace
}
