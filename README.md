# replication_files_neighbors_effects

# Code for Replication of Neighbors' Effects on University Enrollment
**Andrés Barrios-Fernández**
- This repository contains the code required to replicate the main results of **"Neighbors' Effects on University Enrollment"** (March, 2021).
- The first version of the paper was published on September, 2018 and different versions of the paper circulated under the name "Should I Stay or Should I Go? Neighbors' Effects on University Enrollment" (see for instance https://cep.lse.ac.uk/_new/publications/abstract.asp?index=6475)
- The current version corresponds to a revised version of the previous ones. The latest version of the paper can always be found at  https://andresbarriosf.github.io

## OVERVIEW
The code in this replication package constructs the analysis sample from two main data sources: The  Chilean Ministry of Education and the Departamento de Evaluación, Medición y Registro Educacional (DEMRE)  of the University of Chile. DEMRE is the institution in charge of the centralized university admission system. Most of the code in this package corresponds to STATA do-files. The only exception is the code used to geocode addresses that is written in Python. The sample generation and all the analyses can be executed from a single master file (00_masterd.do). The code generates all tables and figures presented in the paper.

## CODE
All the do-files in this repository can be executed from the "00_master.do". I organized the individual do-files in four groups. The number at the beginning of their name reflects their purpose:
1.  **"Sample"**: these do-files are the ones used to generate the estimation samples. <br/>
2.  **"Neighbors"**: these do-files contain the code used to estimate neighbors' effects. <br/>
3.  **"Siblings"**: these do-files contain the code used to estimate siblings' effects. <br/>
4.  **"Descriptives"**: these do-files contain the code used to generate descriptive figures or statistics based on standardized tests (SIMCE) and on the household survey (CASEN, 2015). <br/>
5.  **"Programs"**: all the programs that are later called from the "Neighbors" and "Siblings" do-files are defined in the do-file programs.do. They are needed to generate the tables and figures in the paper. <br/>
I also include in the repository the python script used to geocode addresses ("geocode.py"). Note that to geocode addresses I used the Google Geocoding API. In order to use it you need to activate a Google Cloud account and generate a valid api-key. Check prices before you start sending requests.

## INSTRUCTIONS TO REPLICATORS:
1. First, obtain access to all required datasets (see details below). <br/>
2. Define relevant paths (data directory, temp file directory, code directory, and output directory).  <br/>
3. Check that the names of the raw datasets have not changed. If they have changed, rename them following the convention described in the Data Availability section. <br/>
4. Execute "00_master.do" <br/>

(*) To try the code with some of the publicly available data, download the datasets available on my personal website (https://andresbarriosf.github.io). Then, set the paths to the relevant directories, set the global variable "replication" in line 31 of the master file to 1 and execute it.

## SOFTWARE REQUIEREMENTS:
Stata (code was last run with version 16).  <br/>
- rdrobust (as of December, 2020) <br/>
- estout (as of December, 2020) <br/>
- ivreghdfe (as of December, 2020) <br/>
- reghdfe (as of December, 2020) <br/>
- coefplot (as of December, 2020) <br/>
- geonear (as of December, 2020) <br/>
- shp2dta (as of December, 2020) <br/>
- geoinpoly (as of December, 2020) <br/>
- renvarlab (as of December, 2020) <br/>

Python 2.7.16

## MEMORY AND RUNTIME REQUIREMENTS:
The code was was last run on a Macbook Pro: <br/>
- Processor: 2.5 GHz Dual-Core Intel Core i7. <br/>
- Memory: 16 GB 2133 MHz LPDDR3 <br/>

Under these conditions the sample construction took 6 hours. The replication of tables and figures can be run in less than 1 hour.

## HARDWARE REQUIREMENTS:
Most of the analyses performed in the paper were implemented using Stata 16. The following website describes the hardware requierements to run Stata (https://www.stata.com/support/faqs/windows/hardware-requirements/).  Apart from the requirements described in the link, it is necessary to have enough storage space (datasets generated use around 100 GB of hard drive space), and since Stata use of RAM depends on the size of the datasets that are being used, running the code in a computer with less than 8GB of RAM could be difficult. For the geocoding process the only requirement is to count with an stable internet connection.

## DATA AVAILABILITY
The raw data that we use in this project is subject to privacy restrictions that prevent me from making it public. Below, I describe the main sources of data used in this project.

1.  **Ministry of Education**: most of the information used in this project, including school directories, high school enrollment, higher education enrollment, higher education funding, and higher education completion is currently available in the Ministry of Education website: http://datosabiertos.mineduc.cl/. The data on higher education was not available online when I started this project and therefore, some of the analyses in the paper had to be implemented on site or using data directly provided by the former Divisi\'on de Educaci\'on Superior (currently Subsecretar\'ia de Educaci\'on Superior) of the Ministry of Education. Additional details on this under each sub-title.
<br/>
In addition, I use some custom made data generated by the Research Center of the Ministry of Education for this project. In order to obtain customized data, and datasets not published on their website, researchers need to submit an application describing the research question, methodology, duration and the type of data requiered. The applicaiton also includes a section on data protection. The forms to apply for customized or additional data can be obtained from estadisticas@mineduc.cl. There are no restrictions to access the data based on nationality or place of residence. However, emails and application forms need to be written in Spanish. Below, a brief description of the main datasets used in this project and either links from where they can be downloaded or instructions to obtain them: <br/>

1.1 Directorio de establecimientos: datasets containing characteristics of the schools, including their municipality. These data are only used to generate figure 1 (http://datos.mineduc.cl/dashboards/20015/descarga-bases-de-datos-directorio-de-establecimientos-educacionales/). Since the names of these files can vary over time, before using the replication code they need to be renamed using the following convention:  <br/>
"Directorio_Establecimientos_year.csv"
<br/>

1.2 Rendimiento por estudiante: datasets containing individual level data on the school, educational track, and grade in which students are enrolled. It also contains information on attendance and GPA (http://datos.mineduc.cl/dashboards/19881/informacion-de-rendimiento-academico/). Since the names of these files can vary over time, before using the replication code they need to be renamed using the following convention:  <br/>
"Rendimiento_estudiantes_year.csv"
<br/>

1.3 Matrícula en educación superior: individual level data on the higher education institution and major in which each student is enrolled. It also contains some characteristics of the institutions and programs (http://datos.mineduc.cl/dashboards/20195/descarga-bases-de-datos-matricula-en-educacion-superior/). Since the names of these files can vary over time, before using the replication code they need to be renamed using the following convention:  <br/>
"Matricula_Educacion_Superior_year.csv"
<br/>

1.4 Titulados de educación superior: individual level data on higher education graduates. Contains the institution and major from which individuals graduate (http://datos.mineduc.cl/dashboards/20207/descarga-bases-de-datos-titulados-de-educacion-superior/). Since the names of these files can vary over time, before using the replication code they need to be renamed using the following convention:  <br/>
"Titulados_Educacion_Superior_year.csv"
<br/>

1.5 Postulaciones y asignaciones a becas y créditos en educación superior: individual level data on applications and allocation of funding for higher education (http://datos.mineduc.cl/dashboards/20208/descarga-base-de-datos-postulaciones-a-becas-y-creditos-en-educacion-superior/ and http://datos.mineduc.cl/dashboards/20209/descarga-base-de-datos-asignaciones-de-becas-y-creditos-en-educacion-superior/). These data were made public only recently, and although they contain the main information required to implement the analyses I perform in the paper, their structure and the variable names they use are slightly different from the ones I obtained through the Divisi\'on de Educaci\'on Superior (currently Subsecretar\'ia de Educaci\'on Superior). Therefore, the code included in this repository to clean and prepare the raw data does not perfectly match them. The version of the data I use in the paper should be available throguh the Departamento de Ayudas Estudiantiles and the Research Centre of the Ministry of Education (estadisticas@mineduc.cl). I complemented the data of the Ministry of Education with data managed by the Comisi\'on Ingresa. Comisi\'on Ingresa (https://portal.ingresa.cl/) is the public agency responsible for the Cr\'edito con Aval del Estadio (CAE), one of the subsidized student-loan programs available in Chile. This organization depends on the Ministry of Education and in order to access their data researchers need to obtain their authorization and submit a data applicaiton to the Research Center of the Ministry of Educaiton. The data application form can be obtained from estadisticas@mineduc.cl. Comisi\'on Ingresa can be contacted at +56 2 261-86854 or oficinadepartes@ingresa.cl. In addition to this paper, these data have been used in several other published work including Solis (2017) and Bucarey et al. (2020), something that confirms the data availability for research purposes. For any doubt on accessing or processing this data, researchers can contact me at andres.bafer@alumni.lse.ac.uk.

2. **DEMRE**: the datasets containing individual test scores in the university admission exam (PSU), as well as the ones containing information on individuals socioeconomic characteristics, applications, and enrollment to universities that participate of the centralized admission system are property of DEMRE. In order to get access to their data, it is necessary to fill an application form describing the research project for which the data will be used at https://investigador.demre.cl/formInvestigador.html. Researchers are required to attach a support letter from the institution to which they are affiliated, which is ultimately responsible for the correct use of the data. In order to be able to merge this data with the registers of the MINEDUC, the researcher needs to explicitly mention that s/he plans to do that. If the application is succesful, the data will be prepared and delivery by the Ministry of Education to ensure that the individual identifier used in these data matches the one in their registers. Once DEMRE approves the application, the researcher will receive a letter confirming the approval. At that point, the researcher needs to contact the Research Centre of the Ministry of Education through the email estadisticas@mineduc.cl asking for the forms to apply for data. The researcher should fill that application describing the research project and return it together with the confirmation letter from DEMRE to the Ministry of Education. There are no restrictions to access the data based on nationality or place of residence. However, emails and application forms need to be submitted in Spanish.
<br/>
In this project, on top of the variables included in the standard datasets, I got authorization to use parents' identifiers and students' addresses. I use these variables to identify both siblings and neighbors. I got access to them after contacting the DEMRE director by email (contact details on the following link https://www.uchile.cl/portal/presentacion/asuntos-academicos/demre/presentacion/110091/ubicacion-y-contacto) and setting a meeting with her in the DEMRE headquarters in Santiago, Chile. Apart from the research proposal described above, I presented the project to other members of the DEMRE research team. They specifically included authorization to use these variables on the letter that I submitted to the Ministry of Education.  None of these data can be shared with third parties, but it is available for any researcher that presents a research proposal to the DEMRE and obtains its approval. For any doubt on accessing or processing this data, researchers can contact me at andres.bafer@alumni.lse.ac.uk.  Below the name of the datasets according to the classification used by DEMRE: <br/>

2.1 Inscritos: individual level data containing the universe of individuals registered for the admission exam. This dataset also contains the scores students obtain in the different sections of the test. <br/>
Since the names of these files can vary over time, before using the replication code they need to be renamed using the following convention:  <br/>
"A_INSCRITOS_PUNTAJES_PSU_year_PRIV_MRUN.csv"
<br/>

2.2 Postulaciones: individual level data containing all the applications submitted by students through the centralizad admission system. It contains the rank of preferences, the application score of individuals for each institution and program combination in their rank of preferences, and the status of each application (i.e., admitted, waiting list, etc). <br/>
Since the names of these files can vary over time, before using the replication code they need to be renamed using the following convention:  <br/>
"C_POSTULACIONES_SELECCION_PSU_year_PRIV_MRUN.csv"
<br/>

2.3 Matricula: individual level data containing information on the institution in which individuals enroll (only reports enrollment for universities that take part on the centralized admission system).  <br/>
Since the names of these files can vary over time, before using the replication code they need to be renamed using the following convention:  <br/>
"D_MATRICULA_PSU_year_PRIV_MRUN.csv"
<br/>

2.4 Socioeconomico: individual level data containing socioeconomic variables of students registered for taking the admission exam.  <br/>
Since the names of these files can vary over time, before using the replication code they need to be renamed using the following convention:  <br/>
"B_SOCIOECONOMICO_DOMICILIO_PSU_year_PRIV_MRUN.csv"
<br/>

3. **Other datasets**: <br/>

3.1 Agencia de la Calidad de la Educaci\'on:
<br/>
SIMCE: To create Figure I of the paper, I use data on standardized test scores. Specifically I use data from the 2006, 2008, 2010 and 2012 waves of the SIMCE applied to students in grade 10. I combine data on test scores, with the answers that parents provide to a survey that is applied together with the test. To access these data researchers need to fill the form available https://formulario.agenciaeducacion.cl/solicitud_cargar. There are no restrictions to access the data based on nationality or place of residence. However, the application form need to be completed in Spanish.  Since the names of these files can vary over time, before using the replication code they need to be renamed using the following convention:  <br/>
- "simce2myear_alu_publica_final.dta"
- "simce2myear_cpad_publica_final.dta"
<br/>

3.2 National Household Survey: data is public and can be downloaded from the website of the Ministerio de Desarrollo Social y de la Familia (http://observatorio.ministeriodesarrollosocial.gob.cl/casen/casen_obj.php). This dataset is only used to generate Figure K.II in the Online Appendix. It is included here following a request of the data editor:
<br/>
Since the name of this files coud change, before using the replication code it needs to be renamed as follows:  <br/>
"Casen 2015.dta"
<br/>

3.3 Ministerio de Desarrollo Social y de la Familia (unidades vecinales):
<br/>
In most of the specifications presented in the paper, standard errors are clustered at the neighborhood unit level. Neighborhood units are defined by the Ministerio de Desarrollo Social y la Familia and the shape files containing their borders can be downloaded from the following website: http://siist.ministeriodesarrollosocial.gob.cl/descargar/shape. In the paper I use the neighborhood units of 2017. Since the name of this files can vary over time, before using the replication code the shape file needs to be renamed as follows:  <br/>
"unidades_vecinales_2017.shp"
<br/>
<br/>

+ I certify that the author of the manuscript has legitimate access to and permission to use the data used in this manuscript.

## REPLICATION
My main analyses combine many of these files. Since the identification of neighbors and siblings depends on data provided by the DEMRE, I cannot make public or share with third parties the final datasets used for the estimations. However, you can contact me in case you need guidance with data applications or if you have any doubt about how to process the data (andres.bafer@alumni.lse.ac.uk).
<br/>
The code used to process the data and perform the analyses can be downloaded from https://andresbarriosf.github.io.

## REFERENCES
Alonso Bucarey, Dante Contreras, and Pablo Muñoz, 2020. "Labor Market Returns to Student Loans for University: Evidence from Chile". Journal of Labor Economics, 38:4, 959-1007.<br/>
Alex Solis, 2017. "Credit Access and College Enrollment". Journal of Political Economy, 125:2, 562-622.

(C) All right reserved to Andrés Barrios-Fernández.
