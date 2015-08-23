## Getting and Cleaning Data project 
## by Keith Bowers 
## August 2015


## Approach is to create a tidy data set by compiling the training and testing data sets 
## into two complete tidy data sets then combining to make one completed tiday dat set.

#load packages
library(dplyr)
library(tidyr)

#Part A - merge the training and the test sets to create one data set 
# load training and test .txt files into dataframes 
# then combine training and test files into one file
        #load and combine X data
        xtrain <- read.table("X_train.txt")
        xtest <- read.table("X_test.txt")
        xdata <- rbind(xtrain, xtest)
        
        #load and combine subject data
        subtrain <- read.table("subject_train.txt")
        subtest  <- read.table("subject_test.txt")
        subject <- rbind(subtrain, subtest)
        
        #load and combine activity numbers
        actrain <- read.table( "Y_train.txt")
        actest  <- read.table( "Y_test.txt")
        activity <- rbind(actrain, actest)
                #convert to simple vector for later analysis
                activity <- activity[ ,1]
            
        #load activity labels index
        actlabels <- read.table("activity_labels.txt")
                #convert to simple vector for later analysis 
                actlabels <- actlabels[ ,2]
       
        #load column names 
        features <- read.table("features.txt")
                #convert to simple vector for later analysis
                features <- features[ ,2]        

# Part B - Appropriately label the data set with descriptive variable names

        # add column names
        colnames(xdata) <- features 
         

# Part C - Extract only the measurements on the mean and 
# standard deviation for each measurement. Select columns with "mean" or "std" in name
        
        # create column index for subsetting 
        colnameindex <- grep("mean()|std()", features, value=FALSE )

        #select columns with with mean() or std()
        xdata <- xdata[ ,(colnameindex)]


# Part D - Use descriptive activity names to name the activites in the data set

        #Create list of activity names (e.g., "walking") from activity code numbers
        # (e.g., 1,3,4)
        activitynames <- actlabels[activity]

        #create column of activity names in main data frame
        xdata <- cbind(activitynames, xdata)    

# Part E - Add column of subject names to the main data set

        #create column of subject numbers in main data frame
        xdata <- cbind(subject, xdata)

        #add descriptive column name for subject
        colnames(xdata)[1] <- "subject"
        

# Part F - create a second, independent and tidy data set with 
# the average of each variable for each activity and each subject

        #group using dplyr
        xdata <-group_by(xdata, subject, activitynames)

        # create new datatable of means
        meandata <- summarise_each(xdata, funs(mean))

# part G - create file from tidy data set of average values

        write.table
