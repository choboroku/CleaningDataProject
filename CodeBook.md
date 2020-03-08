

# Original Variables and Features Selection

The original source contains a **README.txt** file with some additional details
regarding to thi dataset. From the description in **features_info.txt**, there are 17 variables:

1. tBodyAcc-XYZ       
2. tGravityAcc-XYZ    
3. tBodyAccJerk-XYZ   
4. tBodyGyro-XYZ      
5. tBodyGyroJerk-XYZ  
6. tBodyAccMag
7. tGravityAccMag     
8. tBodyAccJerkMag    
9. tBodyGyroMag       
10. tBodyGyroJerkMag   
11. fBodyAcc-XYZ       
12. fBodyAccJerk-XYZ   
13. fBodyGyro-XYZ      
14. fBodyAccMag        
15. fBodyAccJerkMag    
16. fBodyGyroMag       
17. fBodyGyroJerkMag  

Each variable has its own mean and standard deviation (std). Variables with XYZ
tag have 3 means and 3 std. 1 mean and 1 std for each coordinate X, Y, and Z,
respectively. So, the number of pairs (mean, std) for each variable is as follows:

3 tBodyAcc-XYZ      
3 tGravityAcc-XYZ   
3 tBodyAccJerk-XYZ  
3 tBodyGyro-XYZ     
3 tBodyGyroJerk-XYZ 
1 tBodyAccMag       
1 tGravityAccMag    
1 tBodyAccJerkMag   
1 tBodyGyroMag      
1 tBodyGyroJerkMag  
3 fBodyAcc-XYZ      
3 fBodyAccJerk-XYZ  
3 fBodyGyro-XYZ     
1 fBodyAccMag       
1 fBodyAccJerkMag   
1 fBodyGyroMag      
1 fBodyGyroJerkMag  

That makes 24 (3\*8) pairs of means and std for variables with -XYZ tags, and 9 (1\*9) pairs of means and stds for variables
for the remaining variables.  This makes a total of 33 (24+9) means and 33 stds. This can be easily verified using these
R commands:

```
# Read the labels:
labels<-read.table("features.txt")

# look at the labels
length(grep("mean[()]", labels$V2)) #  33
length(grep("std()", labels$V2))    #  33
```

# How We Clean the Data
Exploring a little bit the dataset, there are two folders of interest mentioned in **features_info.txt**:

```
test/:
'Inertial Signals'
subject_test.txt
X_test.txt
y_test.txt

train/:
'Inertial Signals'
subject_train.txt
X_train.txt
y_train.txt
```

The files **X_test.txt** and **X_train.txt** contains the data of the variables defined above. Both files have the
same number of columns, and their names are clearly defined in **features.txt**.  The files **subject_test.txt**
and **y_train.txt** in each folder contains the individuals ID and their activities they performed during the
measurement.  Thus, the final goal is to merge the test and train datasets such that a table with an ordered data 
in the following order: Subject, Activity, mean1, std1, mean2, std2, ..., meanN, stdN.

To make it so, the file **features.txt** will be critical here.  Thus, using R a possible approach would be as follows:

1. Read the file **features.txt** and put content into an object called *features*.

   - ```features<-read.table("features.txt")```

2. In each folder (test and train):
    
    - Read file **subject_{test,train}.txt** and post content into an object called *subject.{test,train}*.
     
    - Change the colum name as "Subject".
      
    - Read file **y_{test,train}.txt** and post content into an object called *activities.{test,train}*.
    
    - Change the colum name as "Activity".
    
    - Read file **x_{test,train}.txt** and post content into an object called *{test,train}*
    
    - Change the colums names using columns names in the object *features*.
    
    - Once all the steps above are done, create a dataframe. 1 for test and 1 for train (test.dataset, train.dataset).
    
      ```subject.train <- read.table("train/subject_train.txt", header=FALSE)```
      
      ```names(subject.train)<-"Subject"```
      
      ```activities.train <- read.table("train/y_train.txt")```
      
      ```names(activities.train) <- "Activity"```
      
      ```train <-read.table("train/X_train.txt")```
      
      ```names(train) <- features$V2```
      
      ```train.dataset <- data.frame(subject.train, activities.train, train)```

3. Merge dataframes and sort the output by Subject and Activity.

    - ```tidy.dataset <- rbind(train.dataset, test.dataset)```

4. Extract measurements that have mean and standard deviation.

    - ```tidy.dataset.reduced <- tidy.dataset[ c(1,2, grep("mean[.]|std[.]", names(tidy.dataset)))]```

5. Uses descriptive activity names from **activity_labels.txt** to name the activities in the data set

    - ```activities.labels <- read.table("activity_labels.txt")```                                                                  
    - ```tidy.dataset.reduced$Activity <- as.factor(tidy.dataset.reduced$Activity)```
    - ```levels(tidy.dataset.reduced$Activity) <- c(levels(activities.labels$V2))```   

6. After the merge, we clean the column names to make them more readable.

   - ```names(tidy.dataset.reduced) <- gsub("mean.[.]", "mean", names(tidy.dataset.reduced))```
   - ```names(tidy.dataset.reduced) <- gsub("std.[.]", "std", names(tidy.dataset.reduced))```

7. From the dataset created in item 6, we generated a dataset with the average only.

   - ```select <- c(1,2, grep("mean", names(tidy.dataset.reduced)))``` 
   - ```tidy.dataset.reduced2 <- tidy.dataset.reduced[select]```

8. Save the data into a text file for record.

   - ```write.table(tidy.dataset.reduced2, "tidy.mean.only.txt", row.name=FALSE)```  

# Columns Names in Data from item 7

 [1] "Subject"                             
 [2] "Activity"                            
 [3] "tBodyAcc.mean.X"                     
 [4] "tBodyAcc.mean.Y"                     
 [5] "tBodyAcc.mean.Z"                     
 [6] "tGravityAcc.mean.X"                  
 [7] "tGravityAcc.mean.Y"                  
 [8] "tGravityAcc.mean.Z"                  
 [9] "tBodyAccJerk.mean.X"                 
[10] "tBodyAccJerk.mean.Y"                 
[11] "tBodyAccJerk.mean.Z"                 
[12] "tBodyGyro.mean.X"                    
[13] "tBodyGyro.mean.Y"                    
[14] "tBodyGyro.mean.Z"                    
[15] "tBodyGyroJerk.mean.X"                
[16] "tBodyGyroJerk.mean.Y"                
[17] "tBodyGyroJerk.mean.Z"                
[18] "tBodyAccMag.mean"                    
[19] "tGravityAccMag.mean"                 
[20] "tBodyAccJerkMag.mean"                
[21] "tBodyGyroMag.mean"                   
[22] "tBodyGyroJerkMag.mean"               
[23] "fBodyAcc.mean.X"                     
[24] "fBodyAcc.mean.Y"                     
[25] "fBodyAcc.mean.Z"                     
[26] "fBodyAccJerk.mean.X"                 
[27] "fBodyAccJerk.mean.Y"                 
[28] "fBodyAccJerk.mean.Z"                 
[29] "fBodyGyro.mean.X"                    
[30] "fBodyGyro.mean.Y"                    
[31] "fBodyGyro.mean.Z"                    
[32] "fBodyAccMag.mean"                    
[33] "fBodyBodyAccJerkMag.mean"            
[34] "fBodyBodyGyroMag.mean"               
[35] "fBodyBodyGyroJerkMag.mean"           
[36] "angle.tBodyAccMean.gravity."         
[37] "angle.tBodyAccJerkMean..gravityMean."
[38] "angle.tBodyGyroMean.gravityMean."    
[39] "angle.tBodyGyroJerkMean.gravityMean."
[40] "angle.X.gravityMean."                
[41] "angle.Y.gravityMean."                
[42] "angle.Z.gravityMean."     

