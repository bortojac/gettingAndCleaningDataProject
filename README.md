## This is the week 4 project for Getting and Cleaning Data
scripts | description
------------- | -------------
run_analysis.R  | collect and tidy data. This script combines the train and test data, and joins on a more descriptive name for each activity. Further, it gives the variables more descriptive names, as well as calculates the average by subject and activity.
createCodebook.Rmd | this file creates the codebook and also describes dataset, variables, and manipulation of data in run_analysis.R. The Codebook is a direct addition to the codebook provided with the data. My addition is a description of the variables created in run-analysis.r and can be found towards the end of the Codebook.
README.md | this file creates the README.

## Project Instructions
1. Merges the training and the test sets to create one data set.
    * The test and train sets are combined with rbind.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
    * I use grepl and regular expressions to get only the variable names that contain "mean" and "std". I then subset the merged dataset from the combined dataset mentioned above.
3. Uses descriptive activity names to name the activities in the data set
    * I use left_join from dplyr to bring descriptive activity names into the dataset. I join by the activity ID number provided by the original data files.
4. Appropriately labels the data set with descriptive variable names.
    * I have named each variable a more meaningful name via a for loop and general expressions. See run_analysis.R
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
    * This is done in run_analysis.R with dplyr's group_by and summarise_all. 