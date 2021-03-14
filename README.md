# replication_files_neighbors_effects

# Neighbors' Effects on University Enrollment
**Andrés Barrios-Fernández**
- This repository contains the files required to replicate the main results of **"Neighbors' Effects on University Enrollment"** (March, 2021).
- The first version of the paper was published on September, 2018 and different versions of the paper circulated under the name "Should I Stay or Should I Go? Neighbors' Effects on University Enrollment" (see for instance https://cep.lse.ac.uk/_new/publications/abstract.asp?index=6475)
- The current version corresponds to a revised version of the previous ones. The latest version of the paper can always be found at  https://andresbarriosf.github.io

## OVERVIEW
The code in this replication package constructs the analysis sample from two main data sources: The  Chilean Ministry of Education and the Departamento de Evaluación, Medición y Registro Educacional (DEMRE)  of the University of Chile. DEMRE is the institution in charge of the centralized university admission system. Most of the code in this package corresponds to STATA do-files. The only exception is the code used to geocode addresses that is written in Python. The sample generation and all the analyses can be executed from a single master file. The code generates all tables and figures presented in the paper. 

## CODE
All the do-files in this repository can be executed from the "master_file.do". I organized the individual do-files in three groups. The number at the beginning of their name reflects their purpose:
1.  **"Sample"**: these do-files are the ones used to generate the estimation samples.
2.  **"Neighbors"**: these do-files contain the code used to estimate neighbors' effects.
3.  **"Siblings"**: these do-files contain the code used to estimate siblings' effects.
4.  **"Programs"**: this do-file defines all the programs that are later call from the "Neighbors" and "Siblings" do-files to generate the tables and figures. 
In addition to these do-files I define a multiple programs in the do-file "program.do". I also include in the repository the python program used to geocode addresses ("geocode.py"). Note that to geocode addresses I used the Google Geocoding API. In order to use it you need to activate a Google Cloud account and generate a valid api-key. Check prices before you start sending requests.

## INSTRUCTIONS TO REPLICATORS:
1. First, obtain access to all required datasets. 
2. Define relevant paths (data directory, temp file directory, code directory, and output directory). 
3. Execute "master_file.do"

## SOFTWARE REQUIEREMENTS:
Stata (code was last run with version 16). 
- rdrobust (as of December, 2020)
- estout (as of December, 2020)
- ivreghdfe (as of December, 2020)

Python 2.7.16

## MEMORY AND RUNTIME REQUIREMENTS:
The code was was last run on a Macbook Pro:
- Processor: 2.5 GHz Dual-Core Intel Core i7.
- Memory: 16 GB 2133 MHz LPDDR3

Under these conditions the sample construction took 6 hours. The replication of tables and figures can be run in less than 1 hour.

## DATA AVAILABILITY
The raw data that we use in this project is subject to some restrictions that prevent me from making it public.

1.  **Ministry of Education**: most datasets used in this project, including high school enrollment, higher education enrollment, higher education funding, and higher education completion can be downloaded from the Ministry of Education website: http://datosabiertos.mineduc.cl/. Data on last names identifiers was created by the Research Center of the Ministry of Education for this project. In order to obtain customized data, researchers need to enter an application describing the purpose of the research. The documents to apply for customized data can be obtained from estadisticas@mineduc.cl. Below the titles under which the datasets used in this project are classified in the web site of the Ministry of Education:

1.1 Rendimiento por estudiante: datasets containing individual level data on the school, educational track, and grade in which students are enrolled. It also contains information on attendance and GPA. 
1.2  Postulaciones a becas y créditos en educación superior: individual level data on applications to funding for higher education.
1.3  Asignaciones de becas y créditos en educación superior: individual level data  on the  allocation of funding for higher education.
1.4 Matrícula en educación superior: individual level data on the higher education institution and major in which each student is enrolled. It also contains some characteristics of the institutions and programs.
1.5 Titulados de educación superior: individual level data on higher education graduates. Contains the institution and major from which individuals graduate. 

2. **DEMRE**: the datasets containing individual test scores in the university admission exam (PSU), as well as the ones containing information on individuals socioeconomic characteristics, applications, and enrollment to universities that participate of the centralized admission system are owned by the DEMRE. In order to get access to their data it is necessary to fill an application form describing the research project for which the data will be used at https://demre.cl/portales/portal-bases-datos.  In order to be able to merge this data with the registers of the MINEDUC, the researcher needs to explicitly mention that s/he plans to do that. If the application is approved the data will be prepared and delivery by the Ministry of Education to ensure that the individual identifier matches the one in their registers. In this project, I got authorization to use parents' identifiers and students' addresses. These variables are not part of the standard variables provided by the DEMRE. I got access to them after contacting the DEMRE director by email and setting a meeting in the DEMRE headquarters in Santiago, Chile. Apart from the research proposal described above, I presented the project to the DEMRE research team and had to sign additional data protection agreements. None of these data can be shared with third parties, but it is available for any researcher that presents a research proposal to the DEMRE and obtains its approval. If you need guidance on how to apply for this data, do not hesitate in contacting me.  Below the name of the datasets according to the classification used by DEMRE:

2.1 Inscritos: individual level data containing the universe of individuals registered for the admission exam. This dataset also contains the scores students obtain in the different sections of the test.
2.2 Postulaciones: individual level data containing all the applications submitted by students through the centralizad admission system. It contains the rank of preferences, the application score of individuals for each institution and program combination in their rank of preferences, and the status of each application (i.e., admitted, waiting list, etc).
2.3 Matricula: individual level data containing information on the institution in which individuals enroll (only reports enrollment for universities that take part on the centralized admission system). 
2.4 Socioeconomico: individual level data containing socioeconomic variables of students registered for taking the admission exam. 

3. **Other datasets**:
- CENSUS data: can be requested from the national statistical office (www.ine.cl). The geographic data of the census can be obtained through the "Portal de Transparencia". This portal is accessible from the INE website.
- National Household Survey: data is public and can be downloaded from the website of the Ministry of Social Development (http://observatorio.ministeriodesarrollosocial.gob.cl/casen/casen_obj.php).

+ I certify that the author of the manuscript have legitimate access to and permission to use the data used in this manuscript.

## REPLICATION
My main analyses combine many of these files. Since the identification of neighbors and siblings depends on data provided by the DEMRE, I cannot make public or share with third parties the final datasets used for the estimations. However, you can contact me in case you need guidance with data applications or if you have any doubt about how to process the data (andres.bafer@alumni.lse.ac.uk).

### The code used to process the data and perform the analyses can be downloaded from https://andresbarriosf.github.io

(C) All right reserved to Andrés Barrios-Fernández.
