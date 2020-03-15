
# Codebook

The original source contains a **README.txt** file with some additional details
regarding to this dataset. From the description in **features_info.txt**, there are 17 variables:

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

Please refer to the **features_info.txt** file to get more additional information about
how these variables were computed.

Each variable above has its own mean and standard deviation (std). Variables with XYZ
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
for the remaining variables.  This makes a total of 33 (24+9) means and 33 stds. In this dataset, 30 volunteers participated
in the study. Each volunteer performed activities (6 in total: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS,
SITTING, STANDING, LAYING)) described in the file """activity_labels.txt""".  Each pair (subject, activity) contains
several records, where each record reports a value for the variables above. The dataset is divided into two
categories : test and train. The test set contains 30% of the volunteers
while the trainign sets has 70% of the volunteers.

Running the script run_analysis.R, a dataset that contains the mean and standard deviation of the variables defined above is 
generated. Using that dataset,  the script generates a tidy dataset called ***tidy.mean.only.txt***.  That dataset
contains the averages of the means and the standard deviations of the variables in the original dataset, for each
each pair of (subject, activity). 

The steps of the script are as follows:

1. Generate a dataset based on the training and the test sets.

2. From the dataset in 1., obtain only the measurements that are mean and standard
deviation for each measurement.

3. From the assignment, rename the activity names in a more descriptive way. 

4. Using that dataset above, generate a second dataset with the average of each variable
for each subject and each activity.

