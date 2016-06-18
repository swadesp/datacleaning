## Author: Swadesh Pal. ## Created on: 15-06-2016. ## Last edited: 18-06-2016.
#

# check for required packages
if(!require("data.table")) {
  install.packages("data.table")
}
library("data.table")

# read "activity_labels.txt"
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

# read "features.txt"
features <- read.table("./UCI HAR Dataset/features.txt")

# read training dataset
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# read test dataset
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# extract mean and standard deviation features
extract_features <- grepl("mean|std", features[, 2])

# assign feature names to "X_train" and "X_test"
names(X_train) <- features[, 2]
names(X_test) <- features[, 2]

# extract mean and standard deviation features from "X_train" and "X_test"
X_train <- X_train[, extract_features]
X_test <- X_test[, extract_features]

# assign activity_labels to "y_train" and "y_test" activity_ids
y_train[, 1] <- activity_labels[, 2][y_train[, 1]]
y_test[, 1] <- activity_labels[, 2][y_test[, 1]]
names(y_train) <- "Activity_Labels"
names(y_test) <- "Activity_Labels"
names(subject_train) <- "Subject"
names(subject_test) <- "Subject"

# bind training datasets "subject_train", "test_train" and "X_train" to single dataset
training_set <- cbind.data.frame(subject_train, y_train, X_train)

# bind test datasets "subject_test", "test_test" and "X_test" to single dataset
test_set <- cbind.data.frame(subject_test, y_test, X_test)

# bind "training_set" and "test_set" into a single dataset
data_set <- rbind.data.frame(training_set, test_set)

# create "tidy_dataset" with average of each "features" for each "activity_labels" and each "subject"
tidy_dataset <- aggregate(. ~ Activity_Labels + Subject, data_set, FUN = "mean", na.action=na.pass, na.rm=TRUE)
tidy_dataset <- tidy_dataset[, c(2,1,3:ncol(tidy_dataset))]

# write "tidy_dataset" to text file
write.table(tidy_dataset, file = "tidy_data.txt", sep = ",", row.names = FALSE)