---
title: "CodeBook"
author: "Yashvant Singh"
date: "Sunday, October 26, 2014"
output: html_document
---

This codebook is a result of Coursera Assignment of the course: Getting and Cleaning Data. It describes all steps followed to get desired result.

Input Data: Course assignment provides link to download the data. Input data contains two main files (test data and training data) and few other supplementary files (subject and activity).

Assignment requires me to:
- Merge the training and the test sets to create one data set.
- Extract only the measurements on the mean and standard deviation for each measurement. 
- Use descriptive activity names to name the activities in the data set
- Appropriately label the data set with descriptive variable names. 
- From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.

CodeBook:
- Load required libraries (stringr, data.table)
- Download and unzip files
- Load test and training data
- Load feature data and extract columns whose text contains either "mean" or "std"
- Append subject id columns to the test and training data
- Extract needed columns from training and test data
- Merge two datasets to get one final dataset. This only contains necessary descriptive columns.
- Join the result dataset to the activity dataset (built from reading activity file)
- convert the data frame to data table for easier aggregate functions
- create tidy data set and save output to a text file
