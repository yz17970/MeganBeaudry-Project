This is the class project for Megan Beaudry, a general overview is provided below.

This data was collected by myself during my Master of Science at the Univeristy of Alberta. 
This is water quality data Alberta. This project focuses specifically on Arcobacter butzleri. 

All code, figures, and text are reproducible from various subfolders within the project directory.

Raw Data can be found in the data folder under the subfolder raw_data. The only raw data that was cleaned was the "10-02-19raw data epid project". This file is a cvs. Another raw data table is 10-8-19 LOD95 Table. This data table may go to supplemental material.

Processed data can be found in the processed data folder under the subfolder processed_data. This data is made by the processing r script.  

Processing code can be found in the code folder under the subfolder processing code and is an r script titled "processing script". Instructions for running the processing code can be found in the ReadMe file in the folder code.

Analysis code can be found in the folder code under the subfolder analysis code. Exploratory analysis is an rmd file titled "10-31-19 exploratory analysis". Instructions for running the exploratory analysis code can be found in the ReadMe file in the folder code. All figures of interest generated in both exploratory scripts are saved as png files under the folder results.

The final manuscript is in the products folder.

IN SUMMARY:
1) Go to the data follow - Follow the readme
2) Go to the code folder - Follow the readme
3) Go to the products folder - Follow the readme










A template file and folder structure for a data analysis project/paper done with R/Rmarkdown/Github. 

# Pre-requisites

This is a template for a data analysis project using R, Rmarkdown (and variants, e.g. bookdown), Github and a reference manager that can handle bibtex (I recommend [Jabref](http://www.jabref.org/) or [Zotero](https://www.zotero.org/)). It is also assumed that you have a word processor installed (e.g. MS Word or [LibreOffice](https://www.libreoffice.org/)). You need that software stack to make use of this template.

# Template structure

* All data goes into the subfolders inside the `data` folder.
* All code goes into the `code` folder or subfolders.
* All results (figures, tables, computed values) go into `results` folder or subfolders.
* All products (manuscripts, supplement, presentation slides, web apps, etc.) go into `products` subfolders.
* See the various `readme.md` files in those folders for some more information.

# Template content 

The template comes with a few files that are meant as illustrative examples of the kinds of content you would place in the different folders. 

* There is a simple, made-up dataset in the `raw_data` folder. 
* The `processing_code` folder contains a single R script which loads the raw data, performs a bit of cleaning, and saves the result in the `processed_data` folder.
* The `analysis_code` folder contains an R script which loads the processed data, fits a simple model, and produces a figure and some numeric output, which is saved in the `results` folder.
* The `products` folder contains an example `bibtex` and CSL style file for references. Those files are used by the example manuscript, poster and slides.
* The `poster` and `slides` folders contain very basic examples of posters and slides made with R Markdown. Note that especially for slides, there are many different formats. You might find a different format more suitable. Check the R Markdown documentation. 
* The  `manuscript` folder contains a template for a report written in Rmarkdown (bookdown, to be precise). If you access this repository as part of [my Modern Applied Data Science course](https://andreashandel.github.io/MADAcourse/), the sections are guides for your project. If you found your way to this repository outside the course, you might only be interested in seeing how the file pulls in results and references and generates a word document as output, without paying attention to the detailed structure.

# Getting started

This is a Github template repository. The best way to get it and start using it is [by following these steps.](https://help.github.com/en/articles/creating-a-repository-from-a-template)

Once you got the repository, you can check out the examples by executing them in order. First run the cleaning script, which will produce the processed data. Then run the analysis script, which will take the processed data and produce some results. Then you can run the manuscript, poster and slides example files in any order. Those files pull in the generated results and display them. These files also pull in references from the `bibtex` file and format them according to the CSL style.


