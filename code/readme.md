__Setup__
Before running the scripts mention below, please install the following packages if they are not already installed on your computer. You can use the command install.packages(""), and instert the package name between the quotes.
Packages to be installed:
readxl 
dylyr
corrplot
plotly
naniar
broom
zoo
ggpubr
ggplot2
caret
formattable
vcd
cowplot
grid
Hmisc
qwraps2
maggritr
doParallel
rpart
rpart.plot
mda
ranger
visdat
e1071
tigerstats
tidyverse
ggthemes
forcats
knitr
gridExtra
RColorBrewer


If you wish to knit the code, in the top left hand corner of R studio click the knit button (there is a yarn icon next to it). Select word document. The script may take a few minutes to knit. These document can then be saved and transferred to other files for future use.

If you only wish to run the code, in the middle of the r studio click the run button and select "run all" to run the entire script. 
__Processing__
To run the processing code please go to the processing_code folder. This code cleans and wrangles the data. Run this code by selecting "run all". Inside this code there is a breakdown of the reasoning for each cleaning step.

__Analysis__ 
_FIRST: Exploratory Analysis_
First run the exploraty analysis code. Exploratory analysis code is saved under "11-29-19 exploratory analysis" as both an rmd and word document for viewing. This script focuses on looking at relationships between our pathogen of interest, Arcobacter butzleri and other contaminents or water quality indicators. These are not final figures, but rather an exploration of the data. 

_SECOND: Univariate Analysis_
Second, run the "11-23-19 univariate analysis code". This code will save all univariate figures in the results folder. This includes final figures and tables for the maniscript.

_THIRD: Bivaraite Analysis_
Thrid, run the "11-26-19 bivariate code". This code will save all univariate figures in the results folder. This includes final figures and tables for the maniscript.

_FOURTH: Tree Pond_
Fourth, run the "11-23-19 tree_pond_final". This code will produce a random forest tree. It may take 5-15 minutes to run depending on your computer. This code includes a final random forest tree for the manuscript. 

_FIFTH: Arco Tree_
Fifth, run the "11-23-19 arco_tree". This code will produce a random forest tree. It may take 5-15 minutes to run depending on your computer. This code includes a final random forest tree for the manuscript. 

_SIXTH: Linear and Simple Models_
Sixth, run the "11-25-19 linear and simple models" code to produce tables that contain information on linear and simple linears. 



