library(dplyr)
file <- download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
                      destfile = "UCI.zip", method = "curl")
if(!file.exists("UCI.zip")) {
        unzip(UCI.zip)
}

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n", "functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_data <- cbind(Subject, X, Y)

Tidydata <- Merged_data %>% select(subject, code, contains("mean"), contains("std"))

Tidydata$code <- activities[Tidydata$code, 2]

names(Tidydata)[2] = "activity"
names(Tidydata) <- gsub("Acc", "Accelerometer", names(Tidydata))
names(Tidydata) <- gsub("Gyro", "Gyroscope", names(Tidydata))
names(Tidydata) <- gsub("BodyBody", "Body", names(Tidydata))
names(Tidydata) <- gsub("Mag", "Magnitude", names(Tidydata))
names(Tidydata) <- gsub("^t", "Time", names(Tidydata))
names(Tidydata) <- gsub("^f", "Frequency", names(Tidydata))
names(Tidydata) <- gsub("tBody", "TimeBody", names(Tidydata))
names(Tidydata) <- gsub("-mean()", "mean", names(Tidydata), ignore.case = TRUE)
names(Tidydata) <- gsub("-std()", "STD", names(Tidydata), ignore.case = TRUE)
names(Tidydata) <- gsub("-freq()", "Frequency", names(Tidydata), ignore.case = TRUE)
names(Tidydata) <- gsub("angle", "Angle", names(Tidydata))
names(Tidydata) <- gsub("gravity", "Gravity", names(Tidydata))

Finaldata <- Tidydata %>% group_by(subject, activity) %>% 
        summarise_all(funs(mean))

write.table(Finaldata, "Finaldata.txt", row.names = FALSE)


