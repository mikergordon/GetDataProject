library(dplyr)

#load data
dtTest <- read.table("UCI HAR Dataset/test/X_test.txt")
dtTestLabels <- read.table("UCI HAR Dataset/test/y_test.txt")
dtTestSubject <- read.table("UCI HAR Dataset/test/subject_test.txt")

dtTrain <- read.table("UCI HAR Dataset/train/X_train.txt")
dtTrainLabels <- read.table("UCI HAR Dataset/train/y_train.txt")
dtTrainSubject <- read.table("UCI HAR Dataset/train/subject_train.txt")

dtFeatures <- read.table("UCI HAR Dataset/features.txt")
dtActivities <- read.table("UCI HAR Dataset/activity_labels.txt")

#merge data sets
dtMerged <- rbind(dtTest, dtTrain)
dtMergedLabels <- rbind(dtTestLabels, dtTrainLabels)
dtMergedSubject <- rbind(dtTestSubject, dtTrainSubject)

#name columns of merged data set
names(dtMerged) <- dtFeatures[, 2]

#rename activities
dtMergedLabels[, 1] <- dtActivities[dtMergedLabels[, 1], 2]
names(dtMergedLabels) <- "activity"

#rename subject
names(dtMergedSubject) <- "subject"

#only look for mean and std
colnames(dtFeatures) <- c("num", "name")
dtFeaturesSub <- dtFeatures[grep("mean|std", dtFeatures$name), ]

#subset columns to just mean and std
dtMergedSub <- dtMerged[, dtFeaturesSub[, 1]]

#merge data, activities and subjects into one master data table
dtMaster <- cbind(dtMergedSub, dtMergedLabels, dtMergedSubject)

#calculate averages of all measurements by subject by activity
l <- length(dtMaster) - 2
dtSummary <- ddply(dtMaster, .(subject, activity), function(x) colMeans(x[, 1:l]))

#write to table
write.table(dtSummary, "UCI HAR Dataset/summary.txt", row.name=FALSE)