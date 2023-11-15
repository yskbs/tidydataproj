path <- getwd()

filename <- "Coursera_Data.zip"

# Checking if archieve already exists.
if (!file.exists(filename)){
  url<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(url, filename, method="curl")
  outDir <- file.path(path, "data")
  unzip(zipfile = "downloaded.zip", exdir = outDir)
}  

setwd(file.path(path,"data/UCI HAR Dataset"))
## read activityLabels and measurements in need
list.files(getwd())

activityLabels <-fread("activity_labels.txt",col.names = c("index","activities"))
features <- fread("features.txt",col.names = c("index", "featureNames"))
head(features)
featuresneeded <- grep("(mean|std)", features[, featureNames])
(measurements <- features[featuresneeded, featureNames])
## remove () from measurements
measurements <- gsub("[()]", "" , measurements)


measurements <- gsub("^t", "Time",measurements)
measurements <- gsub("^f", "Frequency",measurements)
measurements <- gsub("Acc", "Accelerometer",measurements)
measurements <- gsub("arCoeff", "Autorregresioncoefficients",measurements)
measurements <- gsub("mad", "Medianabsolutedeviation ",measurements)
measurements <- gsub("sma", "Signalmagnitudearea",measurements)
measurements <- gsub("Gyro", "Gyroscope",measurements)
measurements <- gsub("sma", "Signalmagnitudearea",measurements)
## read train data
train <-fread("train/X_train.txt",
    select = featuresneeded,
    col.names = measurements
  )

trainActivities <-fread("train/Y_train.txt",
        col.names = c("activity"))
trainSubjects <-
  fread("train/subject_train.txt",
    col.names = c("subjectnum")
  )
train <- cbind(trainSubjects, trainActivities,train)

## read test data
test <-  fread("test/X_test.txt",
    select = featuresneeded,
    col.names = measurements
  )

testActivities <- fread("test/Y_test.txt",
        col.names = c("activity"))
testSubjects <- fread("test/subject_test.txt",
        col.names = c("subjectnum"))
test <- cbind(testSubjects, testActivities,test)

## merge train and test
combined <- rbind(train, test)


combined[["activity"]] <- factor(combined[, activity],levels = activityLabels[["index"]],
                                 labels = activityLabels[["activities"]])
                                 
combined[["subjectnum"]] <- as.factor(combined[, subjectnum])


## to create an independent tidy data set combined3 with the average of each variable for each activity and each subject.
combined2 <- melt(data = combined, id = c("subjectnum", "activity"))
combined3 <- dcast(data = combined2, subjectnum + activity ~ variable, fun.aggregate = mean)

## "tidyDataMeans.csv" contains data average by subject and activity, "tidyData.csv" has the data not averaged
## fwrite(x = combined3, file = "tidyDataMeans.csv")
## fwrite(x = combined, file = "tidyData.csv")
write.table(x = combined3, file = "tidyDataMeans.txt",row.name=FALSE)
