# Merges the training and the test sets to create one data set.
features<-read.table("./UCI HAR Dataset/features.txt")
activiti_labels<-read.table("./UCI HAR Dataset/activity_labels.txt")

X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
X_dataset <- merge(X_test, X_train, all=T)
rm(X_test, X_train)

y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names="Y")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names="Y")
y_vector<-as.factor(c(y_test$Y, y_train$Y))
rm(y_test, y_train)

subject_test<-read.table("./UCI HAR Dataset/test//subject_test.txt")
subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt")
subject<-as.factor(c(subject_test$V1,subject_train$V1))
rm(subject_test,subject_train)

# Extracts only the measurements on the mean and standard deviation for each measurement. 
sel_cols<-grep(".*[M|m]ean.*|.*[S|s]td.*", features[,2])
dataset<-X_dataset[,sel_cols]

# Uses descriptive activity names to name the activities in the data set
y_factor <- as.factor(y_vector)
levels(y_factor)<-activiti_labels$V2
  
# Appropriately labels the data set with descriptive variable names. 
colnames(dataset)<-features[sel_cols,2]

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidy_dataset<-by(dataset,list(y_factor, subject) , mean)
write.table(tidy_dataset,file = "tidy_dataset.txt", row.name=F)