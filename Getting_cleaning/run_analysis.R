#Read and merge X test and train data into a single dataset using rbind.
a<-read.table("X_test.txt")
b<-read.table("X_train.txt")
c<-rbind(a,b)
#read features and set up a second row of this table as a variable names
#earlier merged data, c
e<-read.table("features.txt")
f<-t(e$V2)
colnames(c)<-f
#select variable having "means" and "std" in names from the newly formed dataset
means<-c[,grepl("mean", colnames(c), ignore.case = FALSE)]
stdev<-c[,grepl("std", colnames(c), ignore.case = FALSE)]
#merge the means with stdev
X_full<-cbind(means,stdev)
#read tables for subject testa nd train data and merge them
g<-read.table("subject_train.txt")
h<-read.table("subject_test.txt")
i<-rbind(g,h)
#do the same for y labels data
k<-read.table("y_train.txt")
l<-read.table("y_test.txt")
m<-rbind(k,l)
#read activity labels data and merge it with y labels data by using key - first column "V1"
n<-read.table("activity_labels.txt")
o<-merge(n,m, by.m="V1", by.n="V1")
#leave only labels with acitivy descriptions
p<-subset(o,select=V2)
# column-bind earlier dataset with mean and stdev with the acivity descriptions
dd<-cbind(X_full,p)
# column-bind this dtaset, dd, with the subject table
data_full<-cbind(dd,i)
#rename column names for subjects, which is V1 to "subject" and V2 to "activity
colnames(data_full)[which(names(data_full)=="V1")]<-"subject"
colnames(data_full)[which(names(data_full)=="V2")]<-"activity"
#convert data frame into data table using data.table pacckage
data<-data.table(data_full)
# aggreagte data by means for a combination of a subject and activity
tidy<-data[,lapply(.SD, mean),by=list(activity,subject)]
#save the outcome into Dataset file
q<-write.table(tidy, file= "DataSet.txt", row.name=FALSE)