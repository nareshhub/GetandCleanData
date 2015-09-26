library(plyr)
library(data.table)
library(dplyr)
##set the current working directory to the dataset folder
setwd("C://Users//Naresh//Desktop//Courseera//R-course")

item2 <- "UCI HAR Dataset//test//X_test.txt"
item3 <- "UCI HAR Dataset//test//y_test.txt"
item4 <- "UCI HAR Dataset//test//subject_test.txt"
item5 <- "UCI HAR Dataset//activity_labels.txt"
##read the test data files
test_data <- read.table(item2,sep="",stringsAsFactors = F,header=F)
test_activity <- read.table(item3,stringsAsFactors = F,header=F)
test_subject <- read.table(item4,stringsAsFactors = F,header=F)
activity_labels <- read.table(item5,stringsAsFactors = F,header=F)

##set the activity names to the numeric labels
test_activity = factor(test_activity$V1)
lables <- as.vector(activity_labels$V2)
test_activity <- factor(test_activity,levels=c(1:6),labels=lables)
test_activity <- as.vector(test_activity)

##read the train data files
train_data <- read.table("UCI HAR Dataset//train//X_train.txt",sep="",stringsAsFactors = F,header=F)
train_activity <- read.table("UCI HAR Dataset//train//y_train.txt",stringsAsFactors = F,header=F)
train_subject <- read.table("UCI HAR Dataset//train//subject_train.txt",stringsAsFactors = F,header=F)

##set the activity names to the numeric lables
train_activity = factor(train_activity$V1)
train_activity <- factor(train_activity,levels=c(1:6),labels=lables)
train_activity <- as.vector(train_activity)


## get only the mean and std variables
features <- read.table("UCI HAR Dataset//features.txt",stringsAsFactors = F,header=F)
newFeature <- data.frame()
featId = as.vector(features$V1)
featName = as.vector(features$V2)
id = numeric()
name=character()
k=1
for (i in 1:nrow(features)) {
  if (length(grep("mean()",featName[i])) > 0 | length(grep("std()",featName[i])) > 0) {
    if (length(grep("meanFreq()",featName[i])) == 0) {
      id[k] = featId[i]
      name[k] = featName[i]
      k=k+1
    }
  }
}
newFeature=data.frame(id=id,name=name)

##select only the mean and std variables
ids <- as.numeric(newFeature$id)
test_data <- select(test_data,ids)
train_data <- select(train_data,ids)

##remove the special characters to the variable names for the readability
featureName <- as.vector(newFeature$name)
featureName <- gsub("\\(\\)","",featureName)
featureName <- gsub("\\-","",featureName)
featureName <- gsub("m","M",featureName)

names(test_data) <- featureName
names(train_data) <- featureName

##Add the subject and activity labels to the data sets
testData <-cbind(test_subject,test_activity,test_data)  
trainData <-cbind(train_subject,train_activity,train_data)
setnames(trainData, "train_activity", "test_activity")

##combine testData and trainData
finalData <- rbind(testData,trainData)

##set the appropriate names to the columns
setnames(finalData,"V1","subject")
setnames(finalData,"test_activity","activity")

##get the mean of each variable for each subject and each activity
meanData <- ddply(finalData,.(subject,activity),function(x) colMeans(x[,3:68]))
write.table(meanData,file="analysis_output_mean.txt",row.names = F)
