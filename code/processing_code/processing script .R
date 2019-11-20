#this script loads the raw data, processes and cleans it 
#and saves it as Rds file in the processed_data folder

#load needed packages. make sure they are installed.
library(readxl)
library(dplyr)
library(imputeTS)
library(stringr)
library(lubridate)

#load data. path is relative to project directory.
library(RCurl)
data <- getURL("https://raw.githubusercontent.com/epid8060fall2019/MeganBeaudry-Project_WQ/master/data/raw_data/10-02-19%20raw%20data%20epid%20project.csv")
dataWQ <- read.csv(text = data, header = FALSE, stringsAsFactors = FALSE)
str(dataWQ)

#take a look at the data
dplyr::glimpse(dataWQ)

#all the data are factors - we NEED To convert
#USE as.numeric, as.factors as appropriate 

#I need to remake the headers, so I am going to delete the rows that contain various header infomration.
dataWQ <- dataWQ[-c(1,2,3,4,538), ]

#We need to import the headers appropriately 
colnames(dataWQ) <- c('Date', 'Date_Sampled', 'Week', 'Pond', 'Sampling_Site', 'Sample_ID', 'Rainfall', 'HF183', 'HumM2', 'CG01', 'LeeSg', 'Dog3', 'MuBac', 'Rum2Bac', 'A_butzleri_HSP60', 'Salmonella_spp_InvA', 'Campylobacter_spp_Van_Dkye', 'Enterococcus_CCE', 'Shigatoxin_1', 'Shigatoxin_2', 'x', 'y', 'total_coliforms', 'E_coli', 'Enteroalert', 'thermotolerant_coliforms')



#now subset the columns we want by deleting the ones that are blank
dataWQ = subset(dataWQ, select = -c(x,y))

#Want to check how colums are assigned
sapply(dataWQ, mode)
sapply(dataWQ, class)
class(dataWQ$HF183)

#LOD FOR MOLECULAR DATA
#Want to convert our DNQs to a value before they are converted to NAs. This applies for all qPCR data measured in copies per 100ml
#The value that we are replaceing it with is based on the LOD95 - found in a table that i would like to include as an appedix in the publication
#First we need to make sure they are all 
dataWQ$HF183[which(dataWQ$HF183=="DNQ")] <- "4727"
dataWQ$HumM2[which(dataWQ$HumM2=="DNQ")] <- "14076"
dataWQ$CG01[which(dataWQ$CG01=="DNQ")] <- "2568"
dataWQ$LeeSg[which(dataWQ$LeeSg=="DNQ")] <- "3846"
dataWQ$Dog3[which(dataWQ$Dog3=="DNQ")] <- "2868"
dataWQ$MuBac[which(dataWQ$MuBac=="DNQ")] <- "7176"
dataWQ$Rum2Bac[which(dataWQ$Rum2Bac=="DNQ")] <- "5730"
dataWQ$A_butzleri_HSP60[which(dataWQ$A_butzleri_HSP60=="DNQ")] <- "4932"
dataWQ$Salmonella_spp_InvA[which(dataWQ$Salmonella_spp_InvA=="DNQ")] <- "2964"
dataWQ$Campylobacter_spp_Van_Dkye[which(dataWQ$Campylobacter_spp_Van_Dkye=="DNQ")] <- "7176"

#LOD FOR CULTURE DATA
#We also need to deal with some of LOD for culture methods. Even though I may not use the culture methods for this publication, I will use them in others
#Right now I am going to set the value to 9, until I hear back from my co-author
#For ones that above the LOD I am going to set them to the LOD
#Enteroalert is sensitive to 1 enterococci per 100 ml - so a reading of NIL will be converted to 0
#Colilert is senstive to 1 e. coli per 100 ml - so a reading of NIL will be converted to 0
#Execeeding quantificatio limits will be set at respective quantification limit
dataWQ$thermotolerant_coliforms[which(dataWQ$thermotolerant_coliforms=="less than 10")] <- "9"
dataWQ$thermotolerant_coliforms[which(dataWQ$thermotolerant_coliforms=="Less than 10")] <- "9"
dataWQ$thermotolerant_coliforms[which(dataWQ$thermotolerant_coliforms=="<10")] <- "9"
dataWQ$thermotolerant_coliforms[which(dataWQ$thermotolerant_coliforms=="<10**")] <- "11"
dataWQ$thermotolerant_coliforms[which(dataWQ$thermotolerant_coliforms=="more than 600")] <- "600"
dataWQ$thermotolerant_coliforms[which(dataWQ$thermotolerant_coliforms==">600")] <- "600"
dataWQ$thermotolerant_coliforms[which(dataWQ$thermotolerant_coliforms=="NIL")] <- "0"
dataWQ$thermotolerant_coliforms[which(dataWQ$thermotolerant_coliforms=="At least 280 (precise quanitation could not be done due to background growth)")] <- "600"

dataWQ$Enteroalert[which(dataWQ$Enteroalert=="NIL")] <- "0"
dataWQ$Enteroalert[which(dataWQ$Enteroalert=="nil")] <- "0"
dataWQ$Enteroalert[which(dataWQ$Enteroalert=="more than 201")] <- "201"
dataWQ$Enteroalert[which(dataWQ$Enteroalert==">201")] <- "201"
dataWQ$Enteroalert[which(dataWQ$Enteroalert=="<1")] <- "0"
dataWQ$Enteroalert[which(dataWQ$Enteroalert=="<10")] <- "9"
dataWQ$Enteroalert[which(dataWQ$Enteroalert=="less than 1")] <- "0"


dataWQ$E_coli[which(dataWQ$E_coli=="NIL")] <- "0"
dataWQ$E_coli[which(dataWQ$E_coli=="less than 1")] <- "0"
dataWQ$E_coli[which(dataWQ$E_coli=="<1")] <- "0"
dataWQ$E_coli[which(dataWQ$E_coli=="more than 2419.6")] <- "2419.6"

dataWQ$total_coliforms[which(dataWQ$total_coliforms=="More than 2419.6")] <- "2419.6"
dataWQ$total_coliforms[which(dataWQ$total_coliforms=="more than 2419.6")] <- "2419.6"

#Need to fix the ponds so they are all the same
unique(dataWQ$Pond)
dataWQ$Pond <- recode(dataWQ$Pond, "Country Hillls" = "Country_Hills")
dataWQ$Pond <- recode(dataWQ$Pond, "Country Hills" = "Country_Hills")
dataWQ$Pond <- recode(dataWQ$Pond, "County Hills" = "Country_Hills")
dataWQ$Pond <- recode(dataWQ$Pond, "McCall_Lake " = "McCall_Lake")
dataWQ$Pond <- recode(dataWQ$Pond, "Inverness " = "Inverness")

#It looks like we also have some inconsistencies with how sampling site names were entered (capitlization)
#Lets fix that too. Consisteny is key!!
unique(dataWQ$Sampling_Site)
dataWQ$Sampling_Site <- recode(dataWQ$Sampling_Site, "Outfall wp26B" = "Outfall WP26B")
dataWQ$Sampling_Site <- recode(dataWQ$Sampling_Site, "Outfall Wp31 C" = "Outfall WP31C")
dataWQ$Sampling_Site <- recode(dataWQ$Sampling_Site, "Outfall Wp31C" = "Outfall WP31C")
dataWQ$Sampling_Site <- recode(dataWQ$Sampling_Site, "inlet 3/4" = "Inlet 3/4")
dataWQ$Sampling_Site <- recode(dataWQ$Sampling_Site, "Outfall Wp31E" = "Outfall WP31E")
dataWQ$Sampling_Site <- recode(dataWQ$Sampling_Site, "Outfall WP31e" = "Outfall WP31E")
dataWQ$Sampling_Site <- recode(dataWQ$Sampling_Site, "Inlet Wp31B" = "Inlet WP31B")
dataWQ$Sampling_Site <- recode(dataWQ$Sampling_Site, "Outfall/inlet" = "Outfall_Inlet")
dataWQ$Sampling_Site <- recode(dataWQ$Sampling_Site, "Outfalls/inlet" = "Outfall_Inlet")
dataWQ$Sampling_Site <- recode(dataWQ$Sampling_Site, "Outfalls inlet" = "Outfall_Inlet")
dataWQ$Sampling_Site <- recode(dataWQ$Sampling_Site, "Inlet pr60" = "Inlet PR60")
dataWQ$Sampling_Site <- recode(dataWQ$Sampling_Site, "Outfall Wp31A" = "Outfall WP31A")
dataWQ$Sampling_Site <- recode(dataWQ$Sampling_Site, "Inlet WP31A" = "Outfall WP31A")
dataWQ$Sampling_Site <- recode(dataWQ$Sampling_Site, "Inlet  3/4" = "Inlet 3/4")
dataWQ$Sampling_Site <- recode(dataWQ$Sampling_Site, "Outfall Wp26B" = "Outfall WP26B")
dataWQ$Sampling_Site <- recode(dataWQ$Sampling_Site, "Outfall WP3D" = "Outfall WP31D")
dataWQ$Sampling_Site <- recode(dataWQ$Sampling_Site, "Outfall Wp31D" = "Outfall WP31D")
dataWQ$Sampling_Site <- recode(dataWQ$Sampling_Site, "Outfall Wp26C" = "Outfall WP26C")
dataWQ$Sampling_Site <- recode(dataWQ$Sampling_Site, "Outfall Wp26D" = "Outfall WP26D")
dataWQ$Sampling_Site <- recode(dataWQ$Sampling_Site, "outfall WP31C" = "Outfall WP31C")
dataWQ$Sampling_Site <- recode(dataWQ$Sampling_Site, "WP31E" = "Outfall WP31E")
dataWQ$Sampling_Site <- recode(dataWQ$Sampling_Site, "Outfall WP3LE" = "Outfall WP31E")
dataWQ$Sampling_Site <- recode(dataWQ$Sampling_Site, "Outfalls Inlet" = "Outfall_Inlet")
dataWQ$Sampling_Site <- recode(dataWQ$Sampling_Site, "Outfalls/Inlet" = "Outfall_Inlet")
dataWQ$Sampling_Site <- recode(dataWQ$Sampling_Site, "Outfall WP31B" = "Inlet WP31B")



#The shigatoxin data is a presence or absence test. We want to treat "not tested" (so those that were not positive for E. coli and therefore could not have shigatoxin) as na
#The reason to converting this to NA and not just "no" is that the water sample is not positive for E. coli, STX is usually found. STX is similar to other "AB toxins" like cholera toxin, so I do not want assume that STX will never show up in any other bacteria. 
dataWQ$Shigatoxin_1[which(dataWQ$Shigatoxin_1=="not tested")] <- "NA"
dataWQ$Shigatoxin_1[which(dataWQ$Shigatoxin_1=="Not tested")] <- "NA"
dataWQ$Shigatoxin_2[which(dataWQ$Shigatoxin_2=="Not tested")] <- "NA"

#I aslo want to replace the yes and no in the shigatoxin data with positive and negative
#When I recording the data originally, i recorded the CT values (or cycle threshold). This is not important to analysis, so we will ignore it.
dataWQ$Shigatoxin_1[which(dataWQ$Shigatoxin_1=="Yes")] <- "positive"
dataWQ$Shigatoxin_1[which(dataWQ$Shigatoxin_1=="Yes CT 34.934")] <- "positive"
dataWQ$Shigatoxin_1[which(dataWQ$Shigatoxin_1=="Yes CT 34")] <- "positive"
dataWQ$Shigatoxin_1[which(dataWQ$Shigatoxin_1=="Yes Ct 31")] <- "positive"
dataWQ$Shigatoxin_1[which(dataWQ$Shigatoxin_1=="Yes CT 30")] <- "positive"
dataWQ$Shigatoxin_1[which(dataWQ$Shigatoxin_1=="Yes CT 32")] <- "positive"
dataWQ$Shigatoxin_1[which(dataWQ$Shigatoxin_1=="Yes Ct 38")] <- "positive"
dataWQ$Shigatoxin_1[which(dataWQ$Shigatoxin_1=="Yes CT 36")] <- "positive"
dataWQ$Shigatoxin_1[which(dataWQ$Shigatoxin_1=="Yes ct 36")] <- "positive"
dataWQ$Shigatoxin_1[which(dataWQ$Shigatoxin_1=="Yes ct 35")] <- "positive"
dataWQ$Shigatoxin_1[which(dataWQ$Shigatoxin_1=="Yes Ct 34")] <- "positive"
dataWQ$Shigatoxin_1[which(dataWQ$Shigatoxin_1=="Yes CT 37")] <- "positive"
dataWQ$Shigatoxin_1[which(dataWQ$Shigatoxin_1=="yes CT 34")] <- "positive"
dataWQ$Shigatoxin_1[which(dataWQ$Shigatoxin_1=="Yes CT 29")] <- "positive"
dataWQ$Shigatoxin_1[which(dataWQ$Shigatoxin_1=="Yes CT 38")] <- "positive"
dataWQ$Shigatoxin_1[which(dataWQ$Shigatoxin_1=="Yes - CT 38.19")] <- "positive"
dataWQ$Shigatoxin_1[which(dataWQ$Shigatoxin_1=="yes CT 38")] <- "positive"
dataWQ$Shigatoxin_1[which(dataWQ$Shigatoxin_1=="Yes ct 36")] <- "positive"
dataWQ$Shigatoxin_1[which(dataWQ$Shigatoxin_1=="Yes ct 35")] <- "positive"
dataWQ$Shigatoxin_1[which(dataWQ$Shigatoxin_1=="Yes Ct 34")] <- "positive"
dataWQ$Shigatoxin_1[which(dataWQ$Shigatoxin_1=="yes CT 37")] <- "positive"
dataWQ$Shigatoxin_1[which(dataWQ$Shigatoxin_1=="yes ct 36")] <- "positive"
dataWQ$Shigatoxin_1[which(dataWQ$Shigatoxin_1=="yes ct 35")] <- "positive"
dataWQ$Shigatoxin_1[which(dataWQ$Shigatoxin_1=="yes Ct 34")] <- "positive"
dataWQ$Shigatoxin_1[which(dataWQ$Shigatoxin_1=="No")] <- "negative"
dataWQ$Shigatoxin_1[which(dataWQ$Shigatoxin_1=="#REF!")] <- "negative"
dataWQ$Shigatoxin_1[which(dataWQ$Shigatoxin_1=="Not Tested ")] <- "NA"
dataWQ$Shigatoxin_1[which(dataWQ$Shigatoxin_1=="no")] <- "negative"
unique(dataWQ$Shigatoxin_1)
unique(dataWQ$Shigatoxin_2)
dataWQ$Shigatoxin_2[which(dataWQ$Shigatoxin_2=="Yes")] <- "positive"
dataWQ$Shigatoxin_2[which(dataWQ$Shigatoxin_2=="Yes-CT 24")] <- "positive"
dataWQ$Shigatoxin_2[which(dataWQ$Shigatoxin_2=="Yes - CT 37")] <- "positive"
dataWQ$Shigatoxin_2[which(dataWQ$Shigatoxin_2=="Yes - CT 24.43")] <- "positive"
dataWQ$Shigatoxin_2[which(dataWQ$Shigatoxin_2=="Yes - CT 36")] <- "positive"
dataWQ$Shigatoxin_2[which(dataWQ$Shigatoxin_2=="Yes - CT 36")] <- "positive"
dataWQ$Shigatoxin_2[which(dataWQ$Shigatoxin_2=="Yes - CT 32.673")] <- "positive"
dataWQ$Shigatoxin_2[which(dataWQ$Shigatoxin_2=="Yes - CT 36.168")] <- "positive"
dataWQ$Shigatoxin_2[which(dataWQ$Shigatoxin_2=="Yes - CT 38.774")] <- "positive"
dataWQ$Shigatoxin_2[which(dataWQ$Shigatoxin_2=="Yes - CT 30935")] <- "positive"
dataWQ$Shigatoxin_2[which(dataWQ$Shigatoxin_2=="Yes- CT 31.029")] <- "positive"
dataWQ$Shigatoxin_2[which(dataWQ$Shigatoxin_2=="Yes- CT 35.698")] <- "positive"
dataWQ$Shigatoxin_2[which(dataWQ$Shigatoxin_2=="Yes - CT 36.517")] <- "positive"
dataWQ$Shigatoxin_2[which(dataWQ$Shigatoxin_2=="Yes - 33.169")] <- "positive"
dataWQ$Shigatoxin_2[which(dataWQ$Shigatoxin_2=="Yes -35.495")] <- "positive"
dataWQ$Shigatoxin_2[which(dataWQ$Shigatoxin_2=="Yes - CT 28.395")] <- "positive"
dataWQ$Shigatoxin_2[which(dataWQ$Shigatoxin_2=="Yes -CT 30.573")] <- "positive"
dataWQ$Shigatoxin_2[which(dataWQ$Shigatoxin_2=="yes - CT 32.673")] <- "positive"
dataWQ$Shigatoxin_2[which(dataWQ$Shigatoxin_2=="Yes -CT 38.642")] <- "positive"
dataWQ$Shigatoxin_2[which(dataWQ$Shigatoxin_2=="Yes - CT 30.573")] <- "positive"
dataWQ$Shigatoxin_2[which(dataWQ$Shigatoxin_2=="yes- CT 35.698")] <- "positive"
dataWQ$Shigatoxin_2[which(dataWQ$Shigatoxin_2=="Yes CT 27")] <- "positive"
dataWQ$Shigatoxin_2[which(dataWQ$Shigatoxin_2=="yes - ct 36")] <- "positive"
dataWQ$Shigatoxin_2[which(dataWQ$Shigatoxin_2=="Yes CT 30")] <- "positive"
dataWQ$Shigatoxin_2[which(dataWQ$Shigatoxin_2=="Yes CT 29")] <- "positive"
dataWQ$Shigatoxin_2[which(dataWQ$Shigatoxin_2=="Yes -CT 31")] <- "positive"
dataWQ$Shigatoxin_2[which(dataWQ$Shigatoxin_2=="Yes - CT 31")] <- "positive"
dataWQ$Shigatoxin_2[which(dataWQ$Shigatoxin_2=="yes - CT 38")] <- "positive"
dataWQ$Shigatoxin_2[which(dataWQ$Shigatoxin_2=="Yes - CT 38.166")] <- "positive"
dataWQ$Shigatoxin_2[which(dataWQ$Shigatoxin_2=="Yes - CT 35.251")] <- "positive"
dataWQ$Shigatoxin_2[which(dataWQ$Shigatoxin_2=="Yes - CT 30.628")] <- "positive"
dataWQ$Shigatoxin_2[which(dataWQ$Shigatoxin_2=="No")] <- "negative"
dataWQ$Shigatoxin_2[which(dataWQ$Shigatoxin_2=="#REF!")] <- "negative"
dataWQ$Shigatoxin_2[which(dataWQ$Shigatoxin_2=="")] <- "NA"
dataWQ$Shigatoxin_2[which(dataWQ$Shigatoxin_2=="not tested")] <- "NA"
dataWQ$Shigatoxin_2[which(dataWQ$Shigatoxin_2=="rerun")] <- "NA"

#Going through the above section was a lesson on being consistent in data entry saves time down the line...

# CONVERT TO VARIABLES
#first have to convert character then to numeric. This will convert all characters to NA
dataWQ$HF183 <- as.numeric(as.character(dataWQ$HF183))
dataWQ$HumM2 <- as.numeric(as.character(dataWQ$HumM2))
dataWQ$CG01 <- as.numeric(as.character(dataWQ$CG01))
dataWQ$LeeSg <- as.numeric(as.character(dataWQ$LeeSg))
dataWQ$Dog3 <- as.numeric(as.character(dataWQ$Dog3))
dataWQ$MuBac <- as.numeric(as.character(dataWQ$MuBac))
dataWQ$Rum2Bac <- as.numeric(as.character(dataWQ$Rum2Bac))
dataWQ$A_butzleri_HSP60 <- as.numeric(as.character(dataWQ$A_butzleri_HSP60))
dataWQ$Salmonella_spp_InvA <- as.numeric(as.character(dataWQ$Salmonella_spp_InvA))
dataWQ$Campylobacter_spp_Van_Dkye <- as.numeric(as.character(dataWQ$Campylobacter_spp_Van_Dkye))
dataWQ$Enterococcus_CCE <- as.numeric(as.character(dataWQ$Enterococcus_CCE))
dataWQ$total_coliforms <- as.numeric(as.character(dataWQ$total_coliforms))
dataWQ$E_coli <- as.numeric(as.character(dataWQ$E_coli))
dataWQ$Enteroalert <- as.numeric(as.character(dataWQ$Enteroalert))
dataWQ$thermotolerant_coliforms <- as.numeric(as.character(dataWQ$thermotolerant_coliforms))


#Now we have to replace NAs with 1/2 of the LOD, cause that is how we are going to graph them
#This was decided in conjuction with coauthors 
#This will make the data show up as values in my global environment
HF183_A <- na_replace(dataWQ$HF183, 2136)
HumM2_A <- na_replace(dataWQ$HumM2, 7038)
CG01_A <- na_replace(dataWQ$CGO1, 1284)
LeeSg_A <- na_replace(dataWQ$LeeSg, 1923)
Dog3_A <- na_replace(dataWQ$Dog3, 1434)
MuBac_A <- na_replace(dataWQ$MuBac, 3588)
Rum2Bac_A <- na_replace(dataWQ$Rum2Bac, 2865)
A_butzleri_HSP60_A <- na_replace(dataWQ$A_butzleri_HSP60, 2466)
Salmonella_spp_InvA_A <- na_replace(dataWQ$Salmonella_spp_InvA, 1482)
Campylobacter_spp_Van_Dkye_A <- na_replace(dataWQ$Campylobacter_spp_Van_Dkye, 3588)

#I replaced the na in the DF...
#again, the value 0 can be changed
dataWQ$HF183 <- na_replace(dataWQ$HF183, 2136)
dataWQ$HumM2 <- na_replace(dataWQ$HumM2, 7038)
dataWQ$CG01 <- na_replace(dataWQ$CG01, 1284)
dataWQ$LeeSg <- na_replace(dataWQ$LeeSg, 1923)
dataWQ$Dog3 <- na_replace(dataWQ$Dog3, 1434)
dataWQ$MuBac <- na_replace(dataWQ$MuBac, 3588)
dataWQ$Rum2Bac <- na_replace(dataWQ$Rum2Bac, 2865)
dataWQ$A_butzleri_HSP60 <- na_replace(dataWQ$A_butzleri_HSP60, 2466)
dataWQ$Salmonella_spp_InvA <- na_replace(dataWQ$Salmonella_spp_InvA, 1482)
dataWQ$Campylobacter_spp_Van_Dkye <- na_replace(dataWQ$Campylobacter_spp_Van_Dkye,3588)

#check the data
print(HF183_A)

#LOG TRANSFORMATION
#Finally, we want to log transform the data
#In water quality studies, data is often measured in log as risk is assessed in log reduction targets
#Additinally, microbial data represents a wide range of values, so they can be easier to assess in log form 
dataWQ[,c(8,9,10,11,12,13,14,15,16,17,18,21,22,23,24)] <- log10(dataWQ[,c(8,9,10,11,12,13,14,15,16,17,18,21,22,23,24)])

#In addition we can also do the sharpiro-wilkes test for normality
#the p-value > 0.05 implying that the distribution of the data are not significantly different from normal distribution. 
#In other words, we can assume the normality.
shapiro.test(dataWQ$HF183)
shapiro.test(dataWQ$HumM2)
shapiro.test(dataWQ$CG01)
shapiro.test(dataWQ$LeeSg)
shapiro.test(dataWQ$Dog3)
shapiro.test(dataWQ$MuBac)
shapiro.test(dataWQ$Rum2Bac)
shapiro.test(dataWQ$A_butzleri_HSP60)
shapiro.test(dataWQ$Salmonella_spp_InvA)
shapiro.test(dataWQ$Campylobacter_spp_Van_Dkye)
shapiro.test(dataWQ$MuBac)

#Unfortunately, this replaces the 0 with -infinity. We want those back
dataWQ$HF183[which(dataWQ$HF183=="-Inf")] <- "0"
dataWQ$HumM2[which(dataWQ$HumM2=="-Inf")] <- "0"
dataWQ$CG01[which(dataWQ$CG01=="-Inf")] <- "0"
dataWQ$LeeSg[which(dataWQ$LeeSg=="-Inf")] <- "0"
dataWQ$Dog3[which(dataWQ$Dog3=="-Inf")] <- "0"
dataWQ$MuBac[which(dataWQ$MuBac=="-Inf")] <- "0"
dataWQ$Rum2Bac[which(dataWQ$Rum2Bac=="-Inf")] <- "0"
dataWQ$A_butzleri_HSP60[which(dataWQ$A_butzleri_HSP60=="-Inf")] <- "0"
dataWQ$Salmonella_spp_InvA[which(dataWQ$Salmonella_spp_InvA=="-Inf")] <- "0"
dataWQ$Campylobacter_spp_Van_Dkye[which(dataWQ$Campylobacter_spp_Van_Dkye=="-Inf")] <- "0"
dataWQ$Enterococcus_CCE[which(dataWQ$Enterococcus_CCE=="-Inf")] <- "0"
dataWQ$total_coliforms[which(dataWQ$total_coliforms=="-Inf")] <- "0"
dataWQ$E_coli[which(dataWQ$E_coli=="-Inf")] <- "0"
dataWQ$Enteroalert[which(dataWQ$Enteroalert=="-Inf")] <- "0"
dataWQ$thermotolerant_coliforms[which(dataWQ$thermotolerant_coliforms=="-Inf")] <- "0"

#PROBLEM - NOW THE DATA IS NOT NUMERIC. 
#Now we have to convert it back
dataWQ$HF183 <- as.numeric(as.character(dataWQ$HF183))
dataWQ$HumM2 <- as.numeric(as.character(dataWQ$HumM2))
dataWQ$CG01 <- as.numeric(as.character(dataWQ$CG01))
dataWQ$LeeSg <- as.numeric(as.character(dataWQ$LeeSg))
dataWQ$Dog3 <- as.numeric(as.character(dataWQ$Dog3))
dataWQ$MuBac <- as.numeric(as.character(dataWQ$MuBac))
dataWQ$Rum2Bac <- as.numeric(as.character(dataWQ$Rum2Bac))
dataWQ$A_butzleri_HSP60 <- as.numeric(as.character(dataWQ$A_butzleri_HSP60))
dataWQ$Salmonella_spp_InvA <- as.numeric(as.character(dataWQ$Salmonella_spp_InvA))
dataWQ$Campylobacter_spp_Van_Dkye <- as.numeric(as.character(dataWQ$Campylobacter_spp_Van_Dkye))
dataWQ$Enterococcus_CCE <- as.numeric(as.character(dataWQ$Enterococcus_CCE))
dataWQ$total_coliforms <- as.numeric(as.character(dataWQ$total_coliforms))
dataWQ$E_coli <- as.numeric(as.character(dataWQ$E_coli))
dataWQ$Enteroalert <- as.numeric(as.character(dataWQ$Enteroalert))
dataWQ$thermotolerant_coliforms <- as.numeric(as.character(dataWQ$thermotolerant_coliforms))
dataWQ$Enteroalert[which(dataWQ$Enterococcus_CCE=="52.136517")] <- "3.2"
dataWQ$Enteroalert[which(dataWQ$Enterococcus_CCE=="NA")] <- "1.2"


#Lets check the classification
sapply(dataWQ, mode)
sapply(dataWQ, class)
#Good all are numeric 

#Now to deal with the dates

library(lubridate)
library(tidyverse)


dataWQ$Date_Sampled <- as.Date(dataWQ$Date_Sampled, format = "%m/%d/%Y")
class(dataWQ$Date_Sampled)


#Name the new data clean data
cleandata <- dataWQ


#save as rds
saveRDS(cleandata, file = "./data/processed_data/clean_water_quality_data.rds")

# I suggest you save your processed and cleaned data as RDS or RDA/Rdata files. 
# This preserves coding like factors, characters, numeric, etc. 
# If you save as CSV, that information would get lost.
# See here for some suggestions on how to store your processed data:
# http://www.sthda.com/english/wiki/saving-data-into-r-data-format-rds-and-rdata
saveRDS(cleandata, file = "./data/processed_data/processeddata.rds")


