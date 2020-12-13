# replication_files_neighbors_effects

# Neighbors' Effects on University Enrollment
**Andrés Barrios-Fernández**
- This repository contains the files required to replicate the main results of **"Neighbors' Effects on University Enrollment"** (December, 2020). 
- The first version of the paper was published on September, 2018 and different versions of the paper circulated under the name "Should I Stay or Should I Go? Neighbors' Effects on University Enrollment" (see for instance https://cep.lse.ac.uk/_new/publications/abstract.asp?index=6475)
- The current version corresponds to a revised version of the previous ones. The latest version of the paper can always be found at  https://andresbarriosf.github.io  

## CODE 
All the do-files in this repository can be executed from the "master_file.do". I organized the individual do-files in two independent folders:
1.  **"Neighbors"**: this folder contains the code used to estimate neighbors' effects. 
2.  **"Siblings"**: this folder contains the code used to estimate siblings' effects.
3.  **"Samples"**: this folder contains the do-files used to generate the estimation samples. 

## DATASETS 
The raw data that we use in this project is subject to some restrictions that prevent us from making it  public.

1.  **Ministry of Education**: most datasets used in this project, including high school enrollment, higher education enrollment, higher education funding, and higher education completion can be downloaded from the Ministry of Education website: http://datosabiertos.mineduc.cl/. Data on last names identifiers was created by the Research Center of the Ministry of Education for this project. In order to obtain customized data, researchers need to enter an application describing the purpose of the research. The documents to apply for customized data can be obtained from estadisticas@mineduc.cl.

2. **DEMRE**: the datasets containing individual test scores in the university admission exam (PSU), as well as the ones containing information on individuals socioeconomic characteristics, applications, and enrollment to universities that participate of the centralized admission system are in charge of the DEMRE. In order to get access to their data it is necessary to fill an application form describing the research project for which the data will be used at https://demre.cl/portales/portal-bases-datos.  In order to be able to merge this data with the registers of the MINEDUC, the researcher needs to explicitly mention that s/he plans to do that. If the application is approved the data will be prepared and delivery by the Ministry of Education to ensure that the individual identifier matches the one in their registers. In this project I got authorization to use parents' identifiers and students' addresses. These variables are not part of the standard variables they provide. I got access to them after contacting the director by email and setting a meeting in the DEMRE headquarters in Santiago, Chile. Apart from the research proposal described above, I presented the project to the DEMRE team and had to sign additional data protection agreements. None of these data can be shared with third parties, but it is available for any researcher that presents an interesting proposal. 

3. **Other datasets**:
- CENSUS data: can be requested from the national statistical office (www.ine.cl). The geographic data of the census can be obtained through the "Portal de Transparencia". 
- National Household Survey: data can be downloaded from the website of the Ministry of Social Development (http://observatorio.ministeriodesarrollosocial.gob.cl/casen/casen_obj.php). 

## REPLICATION
My main analyses combine many of these files. Since the identification of neighbors and siblings depends on data provided by the DEMRE, I cannot make public or share with third parties the final datasets used in the estimations. However, you can contact me in case you need guidance with data applications (andres.bafer@alumni.lse.ac.uk). 

### The code used to process the data and perform the analyses can be downloaded from https://andresbarriosf.github.io

(C) All right reserved to Andrés Barrios-Fernández.
