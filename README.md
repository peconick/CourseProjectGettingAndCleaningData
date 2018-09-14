# Course Project - Getting And Cleaning Data
This program was feveloped as a Course pProject of Data Science Specialization
(Getting and Cleaning Data Module) by Johns Hoppkins University (via Coursera)


To read the full project description read "Project Description.pdf on the base
folder

The code is writen in R, all the dependencies are dowloaded at first run of the
program

## Download data files

To download the data files run the function *dowloadData()*
the files will be downloaded and unziped to your working directory

Alternatively access the link on the "Project Description.pdf"

## run_analisys
This is the main function of the program.
It performs calls to each function described bellow (in that same order) 
generating a tidy data set form multiple base files

## loadData
Reads each of the files and build a tidy data set

## nameActivities()
Makes chage to the activity variable so that is more readable, changing integer
idexes to  *labels*

## filterSTD()
Filters the dataset selecting only samples on mean and Standard Deviation for
each variable

## averageGroups()
Calculate the average for each variable for each acitivity type of each subject
