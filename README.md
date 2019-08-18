# Peer-graded Assignment: Getting and Cleaning Data Course Project
This repository contains my submission for the course assignment as part of the Coursera Data Science Specialization.

Data transformation was made by the *run_analysis.r* file following the steps below:

1. reading data from train and test folders
```{r}
## check if zipfile was already downloaded
filename <- "getdata_projectfiles_UCI HAR Dataset.zip"
if (!file.exists(filename)){
        # Download and unzip
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileURL, filename)
        unzip(filename)
}

## Reading files training and testing sets 
training = read.table("./UCI HAR Dataset/train/X_train.txt")
testing = read.table("./UCI HAR Dataset/test/X_test.txt")

## Reading descriptive files
training_labels = read.table("./UCI HAR Dataset/train/y_train.txt")
testing_labels = read.table("./UCI HAR Dataset/test/y_test.txt")

training_subject = read.table("./UCI HAR Dataset/train/subject_train.txt")
testing_subject = read.table("./UCI HAR Dataset/test/subject_test.txt")

features = read.table("./UCI HAR Dataset/features.txt")
labels = read.table("./UCI HAR Dataset/activity_labels.txt")
```
2. naming train and test data set by features (add column name)
```{r}
## Renaming columns : each column is a feature
names(training) = features$V2
names(testing) = features$V2
```
3. subsetting train and test data set by mean and STD features
```{r}
## Identify the mean and standard deviation measurments column names
mean_cols = as.character(features[grep("mean\\(\\)", features$V2, ignore.case = TRUE), 'V2'])
std_cols = as.character(features[grep("std\\(\\)", features$V2, ignore.case = TRUE), 'V2'])

## Subset training and testing sets to extract only mean and sd columns
cols = c(mean_cols, std_cols)
training = training[,cols]
testing = testing[,cols]
```
4. matching each data set with activity and subject values
```{r}
## Adding activity and subject columns
training$activity = merge(labels,training_labels, by='V1')$V2
training$subject = factor(training_subject$V1)
testing$activity = merge(labels,testing_labels, by='V1')$V2
testing$subject = factor(testing_subject$V1)
```
5. merging train and test data sets into tidy data set
```{r}
## Merge training and testing sets
tidy_data = rbind(training,testing)
```
6. saving tidy data set (including column names)
```{r}
write.table(tidy_data, "Mean_STD_measurments.txt", 
            row.names=FALSE)
```
7. creating a new data set representing the average of each measurment by activity and subject
```{r}
## Create independent tidy data set with 
## the average of each variable for each activity and each subject.
tidy_data_mean = aggregate(. ~ activity + subject, data = tidy_data, 
                           drop=TRUE, mean)
## Save file
write.table(tidy_data_mean, "Mean_STD_measurments_by_activity_subject.txt", 
            row.names=FALSE)
```
