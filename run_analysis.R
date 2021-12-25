
# 0. download -------------------------------------------------------------


# check and download the file

filename <- "Dataset.zip"

if(!file.exists(filename)){
    url <-  "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(url, destfile = "Dataset.zip", method = "curl" )
    
}
    
if(!file.exists("UCI HAR Dataset")){
    unzip(filename)
}

# check the list of the files
path <- file.path(getwd(),"UCI HAR Dataset")
files <- list.files(path, recursive = T)
files


# 1. Merges the training and the test sets to create one data set. -----------

# read the data
# according to the requirement only features, train, and test are needed

data_features_test <- read.table(file.path(path, "test/X_test.txt"), header=F)
data_features_train <- read.table(file.path(path, "train/X_train.txt"), header=F)

data_train_subject <- read.table(file.path(path, "train/subject_train.txt"), header=F)
data_train_activity <- read.table(file.path(path, "train/y_train.txt"), header=F)

data_test_subject <- read.table(file.path(path, "test/subject_test.txt"), header=F)
data_test_activity <- read.table(file.path(path, "test/y_test.txt"), header=F)

# merge train and test
data_features <- rbind( data_features_train, data_features_test)
data_subject <- rbind(data_train_subject, data_test_subject)
data_activity <- rbind(data_train_activity, data_test_activity)

data_features_names <- read.table(file.path(path, "features.txt"), header = F)[,2]
names(data_features) <- data_features_names
names(data_subject) <- "subject"
names(data_activity) <- "activity"

data_full <- cbind(data_features, data_subject, data_activity)


# 2. Extracts only the measurements on the mean and standard devia --------
library(dplyr)
data_selected <- data_full %>% 
    select(contains(c("mean()","std()")),subject, activity)


# 3. Uses descriptive activity names to name the activities in the --------
# find the descriptions from features_info.txt 

names(data_selected)<-gsub("Acc", "accelerometer_", names(data_selected))
names(data_selected)<-gsub("Gyro", "gyroscope_", names(data_selected))
names(data_selected)<-gsub("^t", "time_", names(data_selected))

names(data_selected)<-gsub("Mag", "magnitude_", names(data_selected))
names(data_selected)<-gsub("Body", "body_", names(data_selected))

names(data_selected)<-gsub("^f", "frequency_", names(data_selected))

