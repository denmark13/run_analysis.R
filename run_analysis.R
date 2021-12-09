library(xlsx)
library(lubridate)
library(tidyverse)
library(reshape2)
library(ggplot2)
library(plotly)
library(shiny)
library(kableExtra)
library(lubridate)
library(readxl)
library(DT)
library(FuturoMilenial)
library(wesanderson)
library(janitor)
library(dplyr)
library(caret)


library(readr)

##  READING .Txt DATASET -------------------------------------------------------------------------------
path= file.path("C://Users//lorad//DENMARK//MyR//getdata_projectfiles_UCI HAR Dataset//dataset.Rdata")
dataFile = "dataset.RData"

setwd(path)
if (!file.exists(dataFile)) {
  temp = read.table("activity_labels.txt", sep = "")
  activityLabels = as.character(temp$V2)
  temp = read.table("features.txt", sep = "")
  attributeNames = temp$V2
  
  Xtrain = read.table("train/X_train.txt", sep = "")
  names(Xtrain) = attributeNames
  Ytrain = read.table("train/y_train.txt", sep = "")
  names(Ytrain) = "Activity"
  Ytrain$Activity = as.factor(Ytrain$Activity)
  levels(Ytrain$Activity) = activityLabels
  trainSubjects = read.table("train/subject_train.txt", sep = "")
  names(trainSubjects) = "subject"
  trainSubjects$subject = as.factor(trainSubjects$subject)
  train = cbind(Xtrain, trainSubjects, Ytrain)
  
  Xtest = read.table("test/X_test.txt", sep = "")
  names(Xtest) = attributeNames
  Ytest = read.table("test/y_test.txt", sep = "")
  names(Ytest) = "Activity"
  Ytest$Activity = as.factor(Ytest$Activity)
  levels(Ytest$Activity) = activityLabels
  testSubjects = read.table("test/subject_test.txt", sep = "")
  names(testSubjects) = "subject"
  testSubjects$subject = as.factor(testSubjects$subject)
  test = cbind(Xtest, testSubjects, Ytest)
  
  save(train, test, file = dataFile)
  rm(train, test, temp, Ytrain, Ytest, Xtrain, Xtest, trainSubjects, testSubjects, 
     activityLabels, attributeNames)
}
load(dataFile)
# setwd(ProjectDirectory)
numPredictors = ncol(train) - 2
## END OF DATA INGRESS ----------------------------------------------------------------------


## DATA SUMMARY -----------------------------------------------------------------------------


train$Partition = "Train"
test$Partition = "Test"
all = rbind(train, test)  # combine sets for visualization
all$Partition = as.factor(all$Partition)
## END OF DATA SUMMARY -----------------------------------------------------------------------------

## DATA TWEK ---------------------------------------------------------------------------------------
df <- all %>%    
  subset(., select = which(!duplicated(names(.)))) %>% 
  select(Activity,subject, matches("std|mean"))


df2<- df %>% 
  group_by(Activity, subject) %>% 
  summarise_if(is.numeric, mean)

