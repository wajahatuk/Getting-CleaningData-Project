setwd("~/UCI HAR Dataset")
library("data.table")

activity_labels <- read.table("activity_labels.txt")[,2]
features <- read.table("features.txt")[,2]

##Extracts only the measurements on the mean and standard deviation for each measurement.
extract_features <- grepl("mean|std", features)

## Loading and processing of X_test and Y_test
subject_test <- read.table("test/subject_test.txt")
x_test = read.table("test/X_test.txt")
y_test = read.table("test/Y_test.txt")

##changing the columns names as defined in "feature.txt"
names(x_test) = features

x_test = x_test[,extract_features]

y_test[,2] = activity_labels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

##merging data column wise
test_data <- cbind(as.data.table(subject_test), y_test, x_test)

## Loading and processing of X_train and Y_train
subject_train <- read.table("train/subject_train.txt")
x_train = read.table("train/X_train.txt")
y_train = read.table("train/Y_train.txt")

##changing the columns names as defined in "feature.txt"
names(x_train) = features

x_train = x_train[,extract_features]

y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

##merging data column wise
train_data <- cbind(as.data.table(subject_train), y_train, x_train)


##Merges the training and the test sets to create one data set

data <- rbind(test_data, train_data)

##From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

id_labels   <- c("subject", "Activity_ID", "Activity_Label")
data_labels <- setdiff(colnames(data), id_labels)
melt_data     <-  melt(data, id = id_labels, measure.vars = data_labels)

# Apply mean function to dataset using dcast function
tidy_data   <- dcast(melt_data, subject + Activity_Label ~ variable, mean)

write.table(tidy_data, file = "./tidy_data.txt", row.name=FALSE)


