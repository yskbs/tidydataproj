library(data.table)
library(dplyr)
path <- getwd()

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, file.path(path, "downloaded.zip"))
outDir <- file.path(path, "data")
unzip(zipfile = "downloaded.zip", exdir = outDir)

## check unzipped folder and files
(list.files(outDir))
(files <- list.files("UCI HAR Dataset"))

## read activityLabels and measurements in need
activityLabels <-fread(
    file.path(path, "UCI HAR Dataset/activity_labels.txt"),
    col.names = c("index", "activities")
  )
features <- fread(
  file.path(path, "UCI HAR Dataset/features.txt"),
  col.names = c("index", "featureNames")
)
head(features)
featuresneeded <- grep("(mean|std)", features[, featureNames])
(measurements <- features[featuresneeded, featureNames])
## remove () and - from measurements, and lowercase them
measurements <- gsub('[()| -]', '', measurements)
measurements <- tolower(measurements)

## read train data
train <-
  fread(
    file.path(path, "UCI HAR Dataset/train/X_train.txt"),
    select = featuresneeded,
    col.names = measurements
  )

trainActivities <-
  fread(file.path(path, "UCI HAR Dataset/train/Y_train.txt"),
        col.names = c("activity"))
trainSubjects <-
  fread(file.path(path, "UCI HAR Dataset/train/subject_train.txt"),
    col.names = c("subjectnum")
  )
train <- cbind(trainSubjects, trainActivities,train)

## read test data
test <-
  fread(file.path(path, "UCI HAR Dataset/test/X_test.txt"),
    select = featuresneeded,
    col.names = measurements
  )

testActivities <-
  fread(file.path(path, "UCI HAR Dataset/test/Y_test.txt")
        ,
        col.names = c("activity"))
testSubjects <-
  fread(file.path(path, "UCI HAR Dataset/test/subject_test.txt"),
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
