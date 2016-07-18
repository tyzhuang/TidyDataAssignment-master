runAnalysis<-function(){
  
#Load Activity Labels
actv_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]
#Load Features
features <- read.table("./UCI HAR Dataset/features.txt")[,2]
#Load Train
xTrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
yTrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
subTrain<-read.table("./UCI HAR Dataset/train/subject_train.txt")
#Load test
xTest <- read.table("./UCI HAR Dataset/test/X_test.txt")
yTest <- read.table("./UCI HAR Dataset/test/y_test.txt")
subTest<-read.table("./UCI HAR Dataset/test/subject_test.txt")

#EXtract Features
extract_features <- grepl("mean|std", features)

#set Test column name
names(xTest)=features
yTest[,2] = actv_labels[yTest[,1]]
names(yTest) = c("Activity_ID", "Activity_Label")
names(subTest) = "subject"
xTest = xTest[,extract_features]

#Bind Test Data
testData <- cbind(as.data.table(subTest), yTest, xTest)


#set Train column name
names(xTrain)=features
yTrain[,2] = actv_labels[yTrain[,1]]
names(yTrain) = c("Activity_ID", "Activity_Label")
names(subTrain) = "subject"
xTrain = xTrain[,extract_features]

#Bind Train Data
trainData <- cbind(as.data.table(subTrain), yTrain, xTrain)

# Merge test and train data
mergeData = rbind(testData, trainData)
labels   = c("subject", "Activity_ID", "Activity_Label")
dataLabels = setdiff(colnames(mergeData), labels)
meltData      = melt(mergeData, id = labels, measure.vars = dataLabels)

#Apply Mean
cleanData   = dcast(meltData, subject + Activity_Label ~ variable, mean)

#Output File
write.table(cleanData, file = "./UCI HAR Dataset/cleanData.txt",row.name=FALSE)
}