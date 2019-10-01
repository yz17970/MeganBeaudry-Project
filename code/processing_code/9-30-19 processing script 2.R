#
#this script loads the raw data, processes and cleans it 
#and saves it as Rds file in the processed_data folder

#load needed packages. make sure they are installed.
library(readxl)
library(dplyr)
library(imputeTS)

#load data. path is relative to project directory.
library(RCurl)
data <- getURL("https://raw.githubusercontent.com/epid8060fall2019/MeganBeaudry-Project_WQ/master/data/raw_data/9-30-19%20raw%20data%20epid%20project.csv")
dataWQ <- read.csv(text = data, header = FALSE, stringsAsFactors = FALSE)
str(dataWQ)

#take a look at the data
dplyr::glimpse(dataWQ)

#all the data are factors - we NEED To convert
#USE as.numeric, as.factors as appropriate 

#I need to remake the headers, so I am going to delete the rows that contain various header infomration.
dataWQ <- dataWQ[-c(1,2,3,4), ]

#We need to import the headers appropriately 
colnames(dataWQ) <- c('Date', 'Date Sampled', 'Week', 'Pond', 'Sampling Site', 'Sample ID', 'Rainfall', 'HF183', 'HumM2', 'CG01', 'LeeSg', 'Dog3', 'MuBac', 'Rum2Bac', 'A_butlzeri_HSP60', 'Salmonella_spp_InvA', 'Campylobacter_spp_Van_Dkye', 'Enterococcus_CCE', 'Shigatoxin_1', 'Shigatoxin_2','themotolerant_coliforms', 'E_coli', 'Enteroalert', 'thermotolerant_coliforms')

#Want to check how colums are assigned
sapply(dataWQ, mode)
sapply(dataWQ, class)
class(dataWQ$HF183)

# CONVERT TO VARIABLES
#first have to convert character then to numeric. This will convert all characters to NA
dataWQ$HF183 <- as.numeric(as.character(dataWQ$HF183))
dataWQ$HumM2 <- as.numeric(as.character(dataWQ$HumM2))
dataWQ$CG01 <- as.numeric(as.character(dataWQ$CG01))
dataWQ$LeeSg <- as.numeric(as.character(dataWQ$LeeSg))
dataWQ$Dog3 <- as.numeric(as.character(dataWQ$Dog3))
dataWQ$MuBac <- as.numeric(as.character(dataWQ$MuBac))
dataWQ$Rum2Bac <- as.numeric(as.character(dataWQ$Rum2Bac))
dataWQ$A_butlzeri_HSP60 <- as.numeric(as.character(dataWQ$A_butlzeri_HSP60))
dataWQ$Salmonella_spp_InvA <- as.numeric(as.character(dataWQ$Salmonella_spp_InvA))
dataWQ$SEnterococcus_CCE <- as.numeric(as.character(dataWQ$Enterococcus_CCE))
dataWQ$Campylobacter_spp_Van_Dkye <- as.numeric(as.character(dataWQ$Campylobacter_spp_Van_Dkye))

#NEED TO CONVERT STX TO YES OR NO 

#Now we have to replace NAs with 0
HF183_A <- na_replace(dataWQ$HF183, 0)
HumM2_A <- na_replace(dataWQ$HumM2, 0)
CG01_A <- na_replace(dataWQ$CGO1, 0)
LeeSg_A <- na_replace(dataWQ$LeeSg, 0)
Dog3_A <- na_replace(dataWQ$Dog3, 0)
MuBac_A <- na_replace(dataWQ$MuBac, 0)
Rum2Bac_A <- na_replace(dataWQ$Rum2Bac, 0)
A_butzleri_HSP60_A <- na_replace(dataWQ$A_butlzeri_HSP60, 0)
Salmonella_spp_InvA_A <- na_replace(dataWQ$Salmonella_spp_InvA, 0)
Campylobacter_spp_Van_Dkye_A <- na_replace(dataWQ$Campylobacter_spp_Van_Dkye, 0)

#check the data
print(HF183_A)


#Now we need to figure out how to deal with Not detects....
#Might have to convert all to NA first, then use na.assign to reassign the number
#or could you use assign
transform(dataWQ, HF183 = as.numeric(HF183))


df %>%
  replace_with_na_if("not detected")

assign('not detected', 0, envir = globalenv())

# looks like we have measurements for height (in centimeters) and weight (in kilogram)



# this is one way of doing it. Note that if the data gets updated, 
# we need to decide if the thresholds are ok (newborns could be <50)

processeddata <- rawdata %>% dplyr::filter( Height != "sixty" ) %>% 
  mutate_all(type.convert) %>% 
  dplyr::filter(Height > 50 & Weight < 1000)

# save data as RDS
# I suggest you save your processed and cleaned data as RDS or RDA/Rdata files. 
# This preserves coding like factors, characters, numeric, etc. 
# If you save as CSV, that information would get lost.
# See here for some suggestions on how to store your processed data:
# http://www.sthda.com/english/wiki/saving-data-into-r-data-format-rds-and-rdata
saveRDS(cleandata, file = "./data/processed_data/processeddata.rds")


