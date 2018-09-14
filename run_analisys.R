run_analisys<-function(){
    library(dplyr)
    library(reshape)
    
    tidyData<-loadData()
    filteredData<-filterSTD(tidyData)
    namedActivities<-nameActivities(filteredData)
    groupedAverage<-averageGroups(namedActivities)
}
loadData<-function(){    
    ## This function loads the data of multiple files and organize it on a single data frame
    
    ### ??????   features<-read.csv("UCI HAR Dataset//features.txt", sep= " ", header = FALSE)[2]
    
    #List the names of files on inertial Singnals folder
    inertialSignalsfileList<-dir(paste(getwd(),"/UCI HAR Dataset/train/Inertial Signals",sep=""))
    inertialSignalsVariablenames<-sub("_train.txt", "", inertialSignalsfileList)
    
    
    tidyData<-data.frame()
    
    for (type in c("test","train")){
        print(paste("loading:",type))

        ## Read Base Files
        subjectFile<-paste(getwd(),"/UCI HAR Dataset/",type,"/subject_",type,".txt",sep="")
        yFile<-paste(getwd(),"/UCI HAR Dataset/",type,"/y_",type ,".txt",sep="")
        XFile<-paste(getwd(),"/UCI HAR Dataset/",type,"/X_",type ,".txt",sep="")
        
        df<-data.frame(
            subject=read.csv(subjectFile,header = FALSE),
            y=read.csv(yFile,header = FALSE),
            X=read.fwf(XFile, widths=rep(16,128),header=FALSE)
        )
        
        ## Add grouping variables
        df<-cbind(df,timeSeries=1:nrow(df)) ## timeSeries
        df<-cbind(df,type=rep(type,nrow(df))) ## type (train, test)

        ## Rename columns and melt data
        names(df)[1:2]<-c("subject","activity")
        df<-melt(df,id=c("subject","activity","timeSeries","type"))
        names(df)[5:6]<-c("timeFrame","X")
        
        
        ## Read Inertial Signal Files and attach to data
        for (variable in inertialSignalsVariablenames){
            print(paste("loading variable:",variable))
            fileName<-paste(getwd(),"/UCI HAR Dataset/",type,"/Inertial Signals/",variable,"_",type,".txt",sep="")
            var<-read.fwf(fileName, widths=rep(16,128))
            var<-melt(var)
            names(var)[2]<-variable
            ## Attach new data as column
            df<-cbind(df,var[variable])
        }
                
        
        ## Combine test and train data
        tidyData<-rbind(tidyData,df)
    }
    
    
    ## Adjust time frame index variable to integer
    tidyData$timeFrame<-as.integer(sub("X.V","",tidyData$timeFrame, fixed = TRUE))
    #levels(tidyData$activity)<-activity_labels
    tidyData
}

filterSTD<-function(Data){
    ## Calculate Mean and Dtandard Deviation for each variable
    means<-colMeans(data[,6:15])
    sd<-sapply(data[,6:15],sd)
    ## Calculate upper and lower limits for each variable
    min<-means-sd
    max<-means+sd
    ## Filter data based on limits
    data[data[,6]>=min[1] & data[,6]<=max[1] &
        data[,7]>=min[2] & data[,7]<=max[2] &     
        data[,8]>=min[3] & data[,8]<=max[3] &     
        data[,9]>=min[4] & data[,9]<=max[4] &     
        data[,10]>=min[5] & data[,10]<=max[5] &     
        data[,11]>=min[6] & data[,11]<=max[6] &     
        data[,12]>=min[7] & data[,12]<=max[7] &     
        data[,13]>=min[8] & data[,13]<=max[8] &     
        data[,14]>=min[9] & data[,14]<=max[9] &     
        data[,15]>=min[10] & data[,15]<=max[10]     
        ,]
    
    
}

nameActivities<-function(Data){
    ## Load factor names
    activity_labels<-read.csv("UCI HAR Dataset//activity_labels.txt",sep = " ", header = FALSE)[2]
    
    ## Set activity to factor
    Data$activity<-as.factor(Data$activity)
    
    ## Set activities names on the data
    levels(Data$activity)<-activity_labels[1:6,]
    
    Data
}

averageGroups<-function(data){
    data %>%
    group_by(subject,activity)%>%
    summarize(  X=mean(X),
                body_acc_x=mean(body_acc_x),  
                body_acc_y=mean(body_acc_y),  
                body_acc_z=mean(body_acc_z), 
                body_gyro_x=mean(body_gyro_x),
                body_gyro_y=mean(body_gyro_y),
                body_gyro_z=mean(body_gyro_z),
                total_acc_x=mean(total_acc_x),
                total_acc_y=mean(total_acc_y),
                total_acc_z=mean(total_acc_x)
    )
    
}

downloadData<-function(){
    ##Downlaod Data
    if (!file.exists("dataset.zip")) download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","dataset.zip")
    
    ## Unzip data
    zipF<- "dataset.zip"
    unzip(zipF,exdir=getwd())
}