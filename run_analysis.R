## This program fulfills assignment of the class "Getting and Cleaning Data"

## load required libraries
library(data.table)
library(stringr)

## Download zip file and unzip it 
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destFile <- "GalaxyS.zip"

##download file 
download.file(fileUrl, destfile = destFile)

if (file.exists(destFile))
{
    ## unzip file in the same folder
    unzip(destFile)
    ##read test file from the directory
    test <- read.table(".//UCI HAR Dataset//test//X_test.txt", header=FALSE)
    ##read training file from the directory
    train <- read.table(".//UCI HAR Dataset//train//X_train.txt", header=FALSE)
    
    ##read features from the file
    features <- read.table(".//UCI HAR Dataset//features.txt", stringsAsFactors=FALSE)
    ## get all feature names that contain the word mean
    feature_mean <- features[(str_detect(string=features$V2, pattern="mean")), ]
    ## get all feature names that contain the word std
    feature_std <- features[(str_detect(string=features$V2, pattern="std")), ]
    ## merge two lists to create one unique list containing all feature names we are interested
    features_needed <- rbind(feature_mean, feature_std)
    ## append two more columns that would be added to test and training data
    desc_col <- c(features_needed$V2, "subject_id", "activity_name")
    
    ## extract only needed columns from the training data
    train2 <- train[, features_needed$V1]
    ## read activity names
    train_activity <- read.table(".//UCI HAR Dataset//train//y_train.txt", header=FALSE, col.names="activity_id", , stringsAsFactors=FALSE)
    ## add activity name column in the training data
    train2 <- cbind(train2, train_activity)
    ## read subject ids
    train_subject <- read.table(".//UCI HAR Dataset//train//subject_train.txt", header=FALSE, col.names="subject_id", stringsAsFactors=FALSE)
    ## add subject id column to the training data
    train2 <- cbind(train2, train_subject)
    
    ## Extracts only the measurements on the mean and standard deviation for each measurement. 
    
    ## extract only needed columns from the test data
    test2 <- test[, features_needed$V1]
    ## read activity names
    test_activity <- read.table(".//UCI HAR Dataset//test//y_test.txt", header=FALSE, col.names="activity_id", stringsAsFactors=FALSE)
    ## add activity name column to the test data
    test2 <- cbind(test2, test_activity)
    ## read corresponding subject ids
    test_subject <- read.table(".//UCI HAR Dataset//test//subject_test.txt", header=FALSE, col.names="subject_id", stringsAsFactors=FALSE)
    ## add subject id column in the test data
    test2 <- cbind(test2, test_subject)
    
    ## Merges the training and the test sets to create one data set.
    data <- rbind(test2, train2)
    
    ## clean up to free up memory
    rm(test)
    rm(train)
    rm(test2)
    rm(train2)
    
    rm(test_activity)
    rm(train_activity)
    rm(test_subject)
    rm(train_subject)
    
    rm(feature_mean)
    rm(feature_std)
    rm(features)
    ##rm(features_needed)
    
    ## read activities name in order to join tables
    activities <- read.table(".//UCI HAR Dataset//activity_labels.txt", col.names=c("activity_id", "Activity_Name"), stringsAsFactors=FALSE)
    
    ## Uses descriptive activity names to name the activities in the data set
    data2 <- merge(data, activities, by = "activity_id")
    data2 <- data2[, 2:ncol(data2)]
    
    ## Appropriately labels the data set with descriptive variable names. 
    colnames(data2) <- desc_col
    
    ## more clean up
    rm(data)
    rm(activities)
    
    ## convert data frame into a data table for easier group/aggregate operations
    dt <- data.table(data2)
    
    ## create tidy dataset
    tidy_data <- dt[, lapply(.SD, mean), by=c("activity_name", "subject_id")] ##, .SDcols=features_needed$V2
    
    ## save tidy dataset to a local file
    write.table(tidy_data, file="output.txt", sep="\t", row.name=FALSE)
}
