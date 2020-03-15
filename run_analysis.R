
####################################################################
# Clean Environment:
####################################################################
rm(list=ls())

####################################################################
# Download dataset:

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
filename <- "UCI_HAR_Dataset.zip"  # String obtained from above 
download.file(fileURL, filename, method="curl")
unzip(filename)

####################################################################
# 1.-Merges the training and the test sets to create one data set.
####################################################################

# Read Features:
features<-read.table("UCI HAR Dataset/features.txt") 

# For Train Dataset:
subject.train <- read.table("UCI HAR Dataset/train/subject_train.txt", header=FALSE)                                                                  
names(subject.train)<-"Subject"                                                                                                       
activities.train <- read.table("UCI HAR Dataset/train/y_train.txt")                                                                                   
names(activities.train) <- "Activity"                   
train <-read.table("UCI HAR Dataset/train/X_train.txt")
names(train) <- features$V2
train.dataset <- data.frame(subject.train, activities.train, train)

# For Test Dataset:                                                                                                                  
subject.test <- read.table("UCI HAR Dataset/test/subject_test.txt", header=FALSE) 
names(subject.test)<-"Subject"
activities.test <- read.table("UCI HAR Dataset/test/y_test.txt") 
names(activities.test) <- "Activity"                                                                                                 
test <-read.table("UCI HAR Dataset/test/X_test.txt")
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

subjects.index <- levels(factor(tidy.dataset.reduced$Subject))
activities.index <- levels(factor(tidy.dataset.reduced$Activity))

# Redefine Variables Names to make them easy to read: 
new.names <- paste("average", names(tidy.dataset.reduced)[3:ncol(tidy.dataset.reduced)], sep="-")
new.names <- gsub("-t", "-Time", new.names)
new.names <- gsub("Acc", "Accelerometer", new.names)
new.names <- gsub("Gyro", "Gyroscope", new.names)
new.names <- gsub("Mag", "Magnitude", new.names)
new.names <- gsub("-f", "-Frequency", new.names)
new.names <- gsub("BodyBody", "Body", new.names)

# Defining an empty dataframe:
tidy.data = tidy.dataset.reduced[FALSE,]

for (i in c(subjects.index)){
   for (j in c(activities.index)){

        # Getting the Subject and Activity:
        info <- tidy.dataset.reduced[tidy.dataset.reduced$Subject==i 
				  & tidy.dataset.reduced$Activity==j,][1,1:2]

        # Compute Average for each variable:
        data<-apply(tidy.dataset.reduced[tidy.dataset.reduced$Subject==i
            & tidy.dataset.reduced$Activity==j, 3:ncol(tidy.dataset.reduced)], 2, mean, na.rm=TRUE)    

	# Putting all together:
        tidy.data <- rbind(tidy.data, data.frame(info, t(as.data.frame(data))))

   }
}

# Update the column names:
new.names <-c("Subject", "Activity", new.names)
names(tidy.data) <- new.names

# Saving the data into a file
write.table(tidy.data, "tidy.mean.only.txt", row.name=FALSE)

