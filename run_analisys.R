run_analisys<-function(){
    require(dplyr)
    require(reshape)
    
    tidyData<-loadData()
    namedActivities<-nameActivities(tidyData)
    filteredData<-filterSTD(namedActivities)
    groupedAverage<-averageGroups(filteredData)
    namedActivities
}
loadData<-function(){    
    ## This function loads the data of multiple files and organize it on a single data frame
    
    #List the names of files on inertial Singnals folder
    inertialSignalsfileList<-dir(paste(getwd(),"/UCI HAR Dataset/train/Inertial Signals",sep=""))
    inertialSignalsVariablenames<-sub("_train.txt", "", inertialSignalsfileList)
    
    ## Initialize dataframe
    tidyData<-data.frame()
    
    ## Loop thru test anda train datasetes
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
        df<-cbind(df,type=rep(type,nrow(df))) ## type (train, test)
        df<-cbind(df,session=1:nrow(df)) ## Session

        ## Rename columns
        names(df)[1:2]<-c("subject","activity")
        
        ## Transofrm coluns (128 observations of a session) into lines
        df<-melt(df,id=c("subject","activity","session","type"))
        names(df)[5:6]<-c("timeFrame","X")
        
        
        ## Read Inertial Signal Files and attach to data
        for (variable in inertialSignalsVariablenames){
            print(paste("loading variable:",variable))
            fileName<-paste(getwd(),"/UCI HAR Dataset/",type,"/Inertial Signals/",variable,"_",type,".txt",sep="")
            var<-read.fwf(fileName, widths=rep(16,128))
            ## column to lines -same logic as above
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
    
    tidyData
}

nameActivities<-function(Data){
    ## This function sets the names of the activities based on description file
    
    ## Load factor names
    activity_labels<-read.csv("UCI HAR Dataset//activity_labels.txt",sep = " ", header = FALSE)[2]
    
    ## Set activity to factor
    Data$activity<-as.factor(Data$activity)
    
    ## Set activities names on the data to names on the file read above
    levels(Data$activity)<-activity_labels[1:6,]
    
    Data
}

filterSTD<-function(Data){
    ## filter data on meand and Standard Deviation
    
    ## Calculate Mean and Dtandard Deviation for each variable
    means<-colMeans(Data[,6:15])
    sd<-sapply(Data[,6:15],sd)
    ## Calculate upper and lower limits for each variable
    min<-means-sd
    max<-means+sd
    
    ## Filter data based on limits
    Data[Data[,6]>=min[1] & Data[,6]<=max[1] &
        Data[,7]>=min[2] & Data[,7]<=max[2] &     
        Data[,8]>=min[3] & Data[,8]<=max[3] &     
        Data[,9]>=min[4] & Data[,9]<=max[4] &     
        Data[,10]>=min[5] & Data[,10]<=max[5] &     
        Data[,11]>=min[6] & Data[,11]<=max[6] &     
        Data[,12]>=min[7] & Data[,12]<=max[7] &     
        Data[,13]>=min[8] & Data[,13]<=max[8] &     
        Data[,14]>=min[9] & Data[,14]<=max[9] &     
        Data[,15]>=min[10] & Data[,15]<=max[10]     
        ,]
    
    
}

averageGroups<-function(data){
    ## Calculates the average of each variables for each subject and activity pair
    summary<-data %>%
    ## group baesd on subject and activity
    group_by(subject,activity)%>% 
    ## calculate the average of each variable for each group
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
    ## Export averages to file
    write.table(summary,"summary.txt",row.names = FALSE)
    
    summary
}

downloadData<-function(){
    ##Downlaod Data
    if (!file.exists("dataset.zip")) download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","dataset.zip")
    
    ## Unzip data
    zipF<- "dataset.zip"
    unzip(zipF,exdir=getwd())
}
#by Gustavo Peconick