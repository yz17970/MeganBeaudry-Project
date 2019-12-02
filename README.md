__Analysis of stormwater quality data from Alberta, Canada__
This is the class project for Megan Beaudry, a general overview is provided below.

This data was collected by myself during my Master of Science at the Univeristy of Alberta. 
This is water quality data Alberta. This project focuses specifically on Arcobacter butzleri. 

__Install R Studio__
In order to reproduce this manuscript, you need to have R studio installed on your computer. If you do not, follow these instructions: 
1. Install R - follow the instruction located in the link below. PLease use version 3.5 or newer for the USA. https://www.r-project.org/
2. Install R studio - Select the free version to install r studio. Use the link below: https://rstudio.com/products/rstudio/download/

__Locating all data, scripts, and figures__
All code, figures, and text are reproducible from various subfolders within the project directory.

__Data__
_Raw data_
Raw Data can be found in the data folder under the subfolder raw_data. The only raw data that was cleaned was the "10-02-19raw data epid project". This file is a cvs. Another raw data table is 10-8-19 LOD95 Table. This data table may go to supplemental material.

_Processed data_
Processed data can be found in the processed data folder under the subfolder processed_data. 
This data is made by the processing r script, which is loacted in the code -> processing_code -> processing script.r.

__Code__
All code can be found in the code folder.
_Processing Code_
Processing code can be found in the code folder under the subfolder processing code and is an r script titled "processing script". Instructions for running the processing code can be found in the ReadMe file in the folder code.
_Analysis Code_
Analysis code can be found in the folder code under the subfolder analysis code. This folder contains exploratory analysis, univariate analysis, bivariate analysis, and tree.
  _Exploratory Analysis_
  Exploratory analysis is an rmd file titled "11-29-19 exploratory analysis". Instructions for running the exploratory analysis code can be found in the ReadMe file in the folder code. All figures of interest generated in exploratory scripts are saved as png files under the folder results.
  _Univariate Analysis_
  Univariate analysis is an rmd file titled "11-23-19 exploratory analysis". Instructions for running the univariate analysis code can be found in the ReadMe file in the folder code. All figures of interest generated in the scripts are saved as png files under the folder results.
  _Bivariate Analysis_
  Bivariate analysis is an rmd file titled "11-26-19 bivariate code". Instructions for running the bivariate analysis code can be found in the ReadMe file in the folder code. All figures of interest generated in the scripts are saved as png files under the folder results.
  _Tree Pond_
  To make the regresssion tree run the rmd file titled "11-23-19 tree pond". Instructions for running the tree code can be found in the ReadMe file in the folder code. All figures of interest generated in the scripts are saved as png files under the folder results.
  _Tree Arcobacter butzleri_
  To make the regresssion tree run the rmd file titled "11-23-19 arco tree". Instructions for running the tree code can be found in the ReadMe file in the folder code. All figures of interest generated in the scripts are saved as png files under the folder results.
  _Linear and Simple Models_
  To produce linear and simple models run the "11-25-19 linear and simple model" script. Instructions for running the code can be found in the ReadMe file in the folder code. All figures of interest generated in the scripts are saved as png files under the folder results.
  
__Results__
Opening the results folder will show all figures generates .png files or .rds files.

__Products__
_Manuscipt_
To produce the manuscript, open the rmd titled "11-23-19 Beaudry_Project_Template." Knit to word document. 

_Supplemental Material_
To produce the manuscript, open the rmd titled "11-23-19 supplmental material_A." Knit to word document. 

_Slides_
A short of series can be produced by opening the rmd title "11-26-19 slides." Knit to html or powerpoing.
_
The final manuscript is in the products folder.

IN SUMMARY:
1) Go to the data follow - Follow the readme
2) Go to the code folder - Follow the readme
3) Go to the products folder - Follow the readme




