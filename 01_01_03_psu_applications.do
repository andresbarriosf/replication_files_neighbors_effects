/*******************************************************************************

								            PSU APPLICATIONS

	Generate register of applications to universities that are part of the
	"Sistema Unico de Admisión"

*******************************************************************************/

*** PSU APPLICATIONS
forvalues x = 2004/2016{

	import delimited "${input_path}${dash}C_POSTULACIONES_SELECCION_PSU_`x'_PRIV_MRUN.csv", delimiter(";") varnames(1) encoding(ISO-8859-1) clear

	#delimit;
	keep mrun año_proceso situacion_postulante
	preferencia codigo_carrera nombre_carrera sede_carrera sigla_universidad
	estado_preferencia  puntaje lugar;
	#delimit cr;

	label variable situacion_postulante "P: por lo menos una postulación activa; C: no cumple requisitos."
	label variable preferencia "Preferencia"

	#delimit;
	label define ep 0 "No utilizada" 9 "Falta NEM" 10 "Inválida" 11 "Repetida" 13 "Excede postulaciones permitidas"
	14 "Error en provincia" 15 "Error en sexo" 16 "Fuera de rango" 17 "Bajo puntaje ponderado mínimo"
	19 "No aprueba prueba especial excl." 20 "No rinde prueba especial a ponderar" 21 "Error año de egreso"
	22 "Excede ingresos por vía regular" 23 "Impédimento académico" 24 "Seleccionado" 25 "Lista de espera"
	26 "Seleccionado en preferencia anterior" 27 "Prueba lenguaje" 28 "Prueba matemáticas" 29 "Prueba historia"
	30 "Prueba ciencias" 31 "Bajo promedio LM mínimo" 32 "EM no acreditada" 35 "No rinde H o C" 36 "Promedio LM < 450"
	37 "No cumple pp inicial - p.especial";
	#delimit cr;

	label values estado_preferencia ep

	reshape wide codigo_carrera nombre_carrera sede_carrera sigla_universidad estado_preferencia puntaje lugar, i(mrun) j(preferencia)

	save "${temp_path}${dash}psu_application`x'.dta", replace
}
