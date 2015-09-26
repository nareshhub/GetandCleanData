##SCRIPT WORK

###Initially set the current working directory to the "run_analysis.R" file path ,where the "UCI HAR Dataset" resides.

###Read the test data and train data set files from the relevant path. Set the activity names to the activity labels 
###in the relevant labels text file (y_train.txt,y_test.txt)

###Extract only the measurements on the mean and std from the features text file (features.txt) using regular expression technique (grep)
### and select only the specific columns from the test and train data sets using (select) from (dplyr)

###Remove the special characters  (using gsub) from the variables in the feature vector for better readability.

###Bind the subject and activity labels to the train and test data sets by column wise (cbind)

###Bind the test and train data sets by row wise (rbind)

###Finally get the mean of each variable for each activity and each subject using (ddply) from (plyr) package.

###Use source("run_analysis.R") to get the desired output called tidy data.