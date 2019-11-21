###################
# Multivariate Model Subset Selection
# Brian McKay 
# 4-10-19
####################

#Clean up global enviroment
rm(list=ls())

#Remove any packages that might have conflicts with the required packages
if(!is.null(names(sessionInfo()$otherPkgs))){
  lapply(paste('package:',names(sessionInfo()$otherPkgs),sep=""),detach,character.only=TRUE,unload=TRUE)}

#Load or install required packages ####
if (require('parallelMap')==FALSE) {install.packages('parallelMap', repos="https://cran.rstudio.com"); require(parallelMap)}
if (require('mlr')==FALSE) {install.packages('mlr', repos="https://cran.rstudio.com"); require(mlr)}
if (require('tidyverse')==FALSE) {install.packages('tidyverse', repos="https://cran.rstudio.com"); require(tidyverse)}

#Load data
clean_water_quality_data <- readRDS("../../data/processed_data/clean_water_quality_data.rds")

#set random number seed, a Good year
#set.seed(1987)
#set.seed(2012)
set.seed(0634)

# ANY diagnosis Subset selection ##################################################################

#mydata<-select(SympAct_Any_Pos, ActivityLevel, CoughYN,  ChestCongestion, NasalCongestion, Sneeze, RunnyNose,
               #ChillsSweats, Fatigue, SubjectiveFever, 
               #Headache, WeaknessYN, MyalgiaYN, SwollenLymphNodes,
               #AbPain, ChestPain, Diarrhea, EyePn, Insomnia, 
               #ItchyEye, Nausea, EarPn, Pharyngitis, Breathless, 
               #ToothPn, Vomit, Wheeze)
mydata <- clean_water_quality_data
#name of outcome variable is activity level
outcome <- mydata$A_butzleri_HSP60
predictors <- mydata[,-1]

npred=ncol(predictors) #number of predictors
nobs=nrow(mydata) # number of observations
SST = sum( (outcome - mean(outcome))^2 ) #for R2 computations below

##
#doing a bit of predictive modeling with mlr
print(sprintf('****doing a bit of linear model feature selection with mlr****'))

## Generate the task, i.e. outcome and predictors to be fit
mytask = makeRegrTask(id='SubsetSelection', data = mydata, target = "A_butzleri_Hsp60")


#set learner/model
learner_name = "regr.lm";
mylearner = makeLearner(learner_name)


#set sampling method for tuning and final performance evaluation
#we use 20/5 for paper. This takes long. So here I'm switching to a faster one.
#this means results are less accurate but code runs faster.
#sampling_choice = makeResampleDesc("RepCV", reps = 20, folds  = 5)
sampling_choice = makeResampleDesc("CV", iters  = 5)
sampling_final = sampling_choice


## Do feature selection for any diagnosis 

#initialize multiple cores for parallel processing using mlr
# Use parallel::detectCores() from parallel to set the right number of cores for your computer
#ncpu=1;
#parallelStartSocket(ncpu, show.info=FALSE)


#The sample space is two large for exhaustive search, I will use a sequential selection
# All the sequential methods will be used to see if the results vary significantly based on the selected model
print(sprintf('****Linear model feature selection for Any Dx with mlr****'))

tstart=proc.time(); #capture current CPU time

select_methods=c("sbs","sfbs","sfs","sffs")

seq_res=list(NULL)
ct=1;
for (select_method in select_methods)
{
ctrl = makeFeatSelControlSequential(method=select_method, same.resampling.instance = TRUE)

print(sprintf('********* Any Dx subset selection with method %s *********',select_method))

featlearn = makeFeatSelWrapper(learner = mylearner, 
                                 resampling = sampling_choice, 
                                 control = ctrl,
                                 show.info = FALSE,
                                 measures = list(rmse,medse) )
  #determine best model with different subsets using CV
  #RMSE is minimized
  sfeats = train(featlearn, task = mytask)
  sfeat_res=getFeatSelResult(sfeats)
  print(sfeat_res)
  seq_res[[ct]]=sfeat_res; #save results for all sequential selection methods
  ct=ct+1;
}

runtime.minutes_SS=(proc.time()-tstart)[[3]]/60 #total time in minutes the optimization took
print(sprintf('optimization took %f minutes',runtime.minutes_SS))
#"optimization took 4.525000 minutes"

parallelStop()

saveRDS(sfeat_res, file = "5 Results/Models/sfeat_res_Any.Rda")




# Lab diagnosis (PCR or Rabid) ####

mydata<-select(SympAct_Lab_Pos, ActivityLevel, CoughYN,  
               ChestCongestion, NasalCongestion, Sneeze, RunnyNose,
               ChillsSweats, Fatigue, SubjectiveFever, 
               Headache, WeaknessYN, MyalgiaYN, SwollenLymphNodes,
               AbPain, ChestPain, Diarrhea, EyePn, Insomnia, 
               ItchyEye, Nausea, EarPn, Pharyngitis, Breathless, 
               ToothPn, Vomit, Wheeze)

#name of outcome variable is activity level
outcome <- mydata$ActivityLevel
predictors <- mydata[,-1]

npred=ncol(predictors) #number of predictors
nobs=nrow(mydata) # number of observations
SST = sum( (outcome - mean(outcome))^2 ) #for R2 computations below

##
print(sprintf('****Linear model feature selection for Lab Dx with mlr****'))
## Do feature selection for lab diagnosis 

## Generate the task, i.e. outcome and predictors to be fit
mytask = makeRegrTask(id='SubsetSelection', data = mydata, target = "ActivityLevel")


#set learner/model
learner_name = "regr.lm";
mylearner = makeLearner(learner_name)


#set sampling method for tuning and final performance evaluation
sampling_choice = makeResampleDesc("RepCV", reps = 20, folds  = 5)
#sampling_choice = makeResampleDesc("CV", iters  = 3)
sampling_final = sampling_choice

#initialize multiple cores for parallel processing using mlr
# Use detectCores() from parallel to set the right number of cores for your computer
ncpu=7;
parallelStartSocket(ncpu, show.info=FALSE)

set.seed(1987) #set random number seed, a Good year


#The sample space is two large for exhaustive search, I will use a sequential selection
# All the sequential methods will be used to see if the results vary significantly based on the selected model
print(sprintf('****linear model feature selection using CV****'))

tstart=proc.time(); #capture current CPU time

select_methods=c("sbs","sfbs","sfs","sffs")

seq_res=list(NULL)
ct=1;
for (select_method in select_methods)
{
  ctrl = makeFeatSelControlSequential(method=select_method, same.resampling.instance = TRUE)
  
  print(sprintf('********* Lab Dx subset selection with method %s *********',select_method))
  
  featlearn = makeFeatSelWrapper(learner = mylearner, 
                                 resampling = sampling_choice, 
                                 control = ctrl,
                                 show.info = FALSE,
                                 measures = list(rmse,medse) )
  #determine best model with different subsets using CV
  #RMSE is minimized
  sfeats = train(featlearn, task = mytask)
  sfeat_res=getFeatSelResult(sfeats)
  print(sfeat_res)
  seq_res[[ct]]=sfeat_res; #save results for all sequential selection methods
  ct=ct+1;
}

runtime.minutes_SS=(proc.time()-tstart)[[3]]/60 #total time in minutes the optimization took
print(sprintf('optimization took %f minutes',runtime.minutes_SS))
#optimization took 4.393333 minutes

parallelStop()


saveRDS(sfeat_res, file = "5 Results/Models/sfeat_res_Lab.Rda")
