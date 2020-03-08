
####################################################################
# Clean Environment:
####################################################################
rm(list=ls())

####################################################################
# 1.-Merges the training and the test sets to create one data set.
####################################################################

# Read Features:
features<-read.table("features.txt") 

# For Train Dataset:
subject.train <- read.table("train/subject_train.txt", header=FALSE)                                                                  
names(subject.train)<-"Subject"                                                                                                       
activities.train <- read.table("train/y_train.txt")                                                                                   
names(activities.train) <- "Activity"                   
train <-read.table("train/X_train.txt")
names(train) <- features$V2
train.dataset <- data.frame(subject.train, activities.train, train)

# For Test Dataset:                                                                                                                  
subject.test <- read.table("test/subject_test.txt", header=FALSE) 
names(subject.test)<-"Subject"
activities.test <- read.table("test/y_test.txt") 
names(activities.test) <- "Activity"                                                                                                 
test <-read.table("test/X_test.txt")
names(test) <- features$V2 
test.dataset <- data.frame(subject.test, activities.test, test)      

# Merging Train and Test Datasets:
tidy.dataset <- rbind(train.dataset, test.dataset)
# Sort the data by Subject and Activity: 
tidy.dataset <- tidy.dataset[order(tidy.dataset$Subject, tidy.dataset$Activity),]

####################################################################
# 2- Extracts only the measurements with mean and standard deviation
#    (std):
####################################################################

# We will extract only the variables that have pairs of mean and std:
tidy.dataset.reduced <- tidy.dataset[ c(1,2, grep("mean[.]|std[.]", names(tidy.dataset)))]    

####################################################################
# 3.- Uses descriptive activity names to name the activities in the data set
####################################################################

# Activities Labels:                                                                                                                  
activities.labels <- read.table("activity_labels.txt")             
tidy.dataset.reduced$Activity <- as.factor(tidy.dataset.reduced$Activity)  
levels(tidy.dataset.reduced$Activity) <- c(levels(activities.labels$V2))       

####################################################################
# 4.-Appropriately labels the data set with descriptive variable names.
####################################################################

# We observe the columns for mean and std as mean... and std... 
# Let's make it more readable:
names(tidy.dataset.reduced) <- gsub("mean.[.]", "mean", names(tidy.dataset.reduced))
names(tidy.dataset.reduced) <- gsub("std.[.]", "std", names(tidy.dataset.reduced))

####################################################################
# 5.-From the data set in step 4, creates a second, independent tidy data set
# with the average of each variable for each activity and each subject
####################################################################

select <- c(1,2, grep("mean", names(tidy.dataset.reduced)))
tidy.dataset.reduced2 <- tidy.dataset.reduced[select]

# Saving the data into a file
write.table(tidy.dataset.reduced2, "tidy.mean.only.txt", row.name=FALSE)

