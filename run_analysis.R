# Peer-graded Assignment: Getting and Cleaning Data Course Project
# The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. 
# The goal is to prepare tidy data that can be used for later analysis. 
# You will be required to submit: 1) a tidy data set as described below, 
# 2) a link to a Github repository with your script for performing the analysis, 
# and 3) a code book that describes the variables, the data, and any transformations or work that you performed 
# to clean up the data called CodeBook.md. 
# You should also include a README.md in the repo with your scripts. 
# This repo explains how all of the scripts work and how they are connected.

# One of the most exciting areas in all of data science right now is wearable computing - see for example this article . 
# Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. 
# The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. 
# A full description is available at the site where the data was obtained:
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
# Here are the data for the project:
# "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"  

# You should create one R script called run_analysis.R that does the following. 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# 1. Merge the training and the test sets to create one data set:
# test data
testsubject <- read.table("/Users/maryamghaedi/data/UCI\ HAR\ Dataset/test/subject_test.txt")# 2947    1
testX <- read.table("/Users/maryamghaedi/data/UCI\ HAR\ Dataset/test/X_test.txt")# 2947  561
testy <- read.table("/Users/maryamghaedi/data/UCI\ HAR\ Dataset/test/y_test.txt")# 2947    1

# train data
trainsubject <- read.table("/Users/maryamghaedi/data/UCI\ HAR\ Dataset/train/subject_train.txt")# 7352    1
trainX <- read.table("/Users/maryamghaedi/data/UCI\ HAR\ Dataset/train/X_train.txt")# 7352  561
trainy <- read.table("/Users/maryamghaedi/data/UCI\ HAR\ Dataset/train/y_train.txt")# 7352    1

# merge data
sdata <- rbind(testsubject, trainsubject)# 10299     1
xdata <- rbind(testX, trainX)# 10299   561
ydata <- rbind(testy, trainy)# 10299     1

#3. load feature & activity info
# feature info
feature <- read.table("/Users/maryamghaedi/data/UCI\ HAR\ Dataset/features.txt")
class(feature[,2])#factor
as.character(feature[,2])

# activity labels
activitylabel <- read.table("/Users/maryamghaedi/data/UCI\ HAR\ Dataset/activity_labels.txt")
class(activitylabel[,2])#factor
as.character(activitylabel[,2])

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# extract feature cols & names named 'mean, std'
selectedCols <- grep("mean|std", as.character(feature[,2]))
selectedCols
selectedColNames <- feature[selectedCols, 2]
selectedColNames
selectedColNames <- sub("-mean", "Mean", selectedColNames)
selectedColNames <- sub("-std", "Std", selectedColNames)
selectedColNames
selectedColNames <- gsub("[-()]", "", selectedColNames)
selectedColNames

#4. extract data by cols & using descriptive name
xdata <- xdata[selectedCols]
allData <- cbind(sdata, ydata, xdata)
colnames(allData) <- c("Subject", "Activity", selectedColNames)

allData$Activity
allData$Activity <- factor(allData$Activity, levels = activitylabel[,1], labels = activitylabel[,2])
allData$Subject
allData$Subject <- as.factor(allData$Subject)

#5. generate tidy data set with the average of each variable for each activity and each subject.
library(reshape2)
head(allData)
meltedData <- melt(allData, id = c("Subject", "Activity"))
meltedData
tidyData <- dcast(meltedData, Subject + Activity ~ variable, mean)
dim(tidyData)
write.table(tidyData, "./tidy_dataset.txt", row.names = FALSE, quote = FALSE)


