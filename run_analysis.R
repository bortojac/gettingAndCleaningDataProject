# this is a script for Project 4 of getting and cleaning data

# Libraries
library(magrittr)
library(dplyr)
library(lubridate)
library(stringr)
library(data.table)
library(tidyr)

#setwd
setwd("/Users/bortojac/Documents/Coursera/dataScienceSpecialization/gettingAndCleaningData/project4/")

# read in the datasets

# activity mapping
activityMap <- read.delim("UCI_HAR_Dataset/activity_labels.txt", sep = " ", header = FALSE)
names(activityMap) <- c("activityID", "activity")

# subject files
subjectTest <- read.table("UCI_HAR_Dataset/test/subject_test.txt")
subjectTrain <- read.table("UCI_HAR_Dataset/train/subject_train.txt")

# activity files
activityTest <- read.table("UCI_HAR_Dataset/test/y_test.txt")
activityTrain <- read.table("UCI_HAR_Dataset/train/y_train.txt")

# feature files
features <- read.table("UCI_HAR_Dataset/features.txt")

# data files
testDat <- read.table("UCI_HAR_Dataset/test/X_test.txt")
trainDat <- read.table("UCI_HAR_Dataset/train/X_train.txt")


# combine the train and test datasets
dat <- rbind(testDat, trainDat)
names(dat) <- features$V2
subjectDat <- rbind(subjectTest, subjectTrain)
names(subjectDat) <- c("subject")
activityDat <- rbind(activityTest, activityTrain)
names(activityDat) <- c("activityID")

# extract only mean and std dev variables
meanAndStd <- c(grep("mean\\(\\)|std\\(\\)", names(dat), value = TRUE))
dat <- dat[, meanAndStd]
names(dat)

# combine the columns into one dataset, and join on descriptive activity names
combinedDat <- cbind(subjectDat,activityDat,dat) %>% 
   left_join(activityMap, by = "activityID")

tallDat <- gather(combinedDat, featureName, var, -subject, -activityID, -activity) %>% 
   mutate(featureDomain = substring(featureName, 1,1),
          featureDomain = ifelse(featureDomain == "t", "Time", "Frequency"),
          featureAcceleration = ifelse(grepl("Body", featureName), "Body", "Gravity"),
          featureInstrument = ifelse(grepl("Gyro", featureName), "Gyroscope", "Accelerometer"),
          featureJerk = ifelse(grepl("Jerk", featureName) == TRUE, "Jerk", NA),
          featureMagnitude = ifelse(grepl("Mag", featureName) == TRUE, "Magnitude", NA),
          featureAxis = str_sub(featureName,-1),
          featureVariable = ifelse(grepl("mean", featureName), "Mean", "Standard Deviation")
          ) %>% 
   select(-activityID) %>% 
   group_by(activity, subject, featureAcceleration,
            featureInstrument, featureJerk, featureMagnitude,
            featureAxis, featureVariable) %>% 
   summarise(average = mean(var, na.rm = TRUE)) %>% 
   ungroup()