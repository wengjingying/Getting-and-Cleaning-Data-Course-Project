## go to the UCI HAR Dataset directory
if(file.exists("UCI HAR Dataset")){setwd("./UCI HAR Dataset")}

## read data
Subject_train <- read.table("./train/subject_train.txt")
X_train <- read.table("./train/x_train.txt")
Y_train <- read.table("./train/y_train.txt")
Subject_test <- read.table("./test/subject_test.txt")
X_test <- read.table("./test/x_test.txt")
Y_test <- read.table("./test/y_test.txt")
activity_labels <- read.table("activity_labels.txt")
features <- read.table("features.txt")

## create column name
colN <- features[ ,2]
##give Test/Train data a column name
colnames(X_test) <- colN 
colnames(X_train) <- colN 

## name the activities in the Y data
f <- rbind(Y_test, Y_train)
Activities <- factor(f$V1)
levels(Activities) <- activity_labels[ ,2]

## Merges the training and the test sets to create one data set.
mergedData_1 <- rbind(X_test,X_train)

## name activities in mergedData
mergedData_2 <- cbind(Activities, mergedData_1)

## merge subject_id with meredData
subject_id <- rbind(Subject_test,Subject_train)
subject <- subject_id$V1
mergedData <- cbind(subject, mergedData_2)

##Extracts only the measurements on the mean and standard deviation for each measurement. 
index<-grepl("mean|std",names(mergedData))
Data_extract01 <- mergedData[, index]
Data_extract02 <- cbind(Activities,Data_extract01)
Data_extract <- cbind(subject,Data_extract02)

##labels the data set with descriptive variable names
colnames(Data_extract) <- gsub("-","_",names(Data_extract))
colnames(Data_extract) <- gsub("\\(\\)","",names(Data_extract))
colnames(Data_extract) <- gsub("tBody","time_Body_",names(Data_extract))
colnames(Data_extract) <- gsub("fBody","frequency_Body_",names(Data_extract))

##  creates a second, independent tidy data set with the average of each variable for each activity and each subject.
result<-aggregate(Data_extract,by=list(subject,Activities),mean)
result<-result[,c(1:2,5:ncol(result))]
names(result)[1]="subject"
names(result)[2]="Activities"
write.table(result,file="result.txt",row.name=FALSE)