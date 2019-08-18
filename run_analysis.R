### ------------------ Getting and Cleaning Data  ------------------- ###
### ------------------ Course project  ------------------- ###
# By UcepH

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

## Renaming columns : each column is a feature
names(training) = features$V2
names(testing) = features$V2

## Identify the mean and standard deviation measurments column names
mean_cols = as.character(features[grep("mean\\(\\)", features$V2, ignore.case = TRUE), 'V2'])
std_cols = as.character(features[grep("std\\(\\)", features$V2, ignore.case = TRUE), 'V2'])

## Subset training and testing sets to extract only mean and sd columns
cols = c(mean_cols, std_cols)
training = training[,cols]
testing = testing[,cols]

## making columns names more readable
cols = gsub("-",".",cols)
cols = gsub("\\(","",cols)
cols = gsub("\\)","",cols)
cols = tolower(cols)
names(training) = cols
names(testing) = cols

## Adding activity and subject columns
training$activity = merge(labels,training_labels, by='V1')$V2
training$subject = factor(training_subject$V1)
testing$activity = merge(labels,testing_labels, by='V1')$V2
testing$subject = factor(testing_subject$V1)

## Merge training and testing sets
tidy_data = rbind(training,testing)

## Save file
write.table(tidy_data, "Mean_STD_measurments.txt", 
            row.names=FALSE)

## Create independent tidy data set with 
## the average of each variable for each activity and each subject.
tidy_data_mean = aggregate(. ~ activity + subject, data = tidy_data, 
                           drop=TRUE, mean)

## Save file
write.table(tidy_data_mean, "Mean_STD_measurments_by_activity_subject.txt", 
            row.names=FALSE)
