#!/usr/bin/Rscript

#FileName: Calculating_ComparisonStatistics.R
#Author: "Emma Fox (e.fox16@imperial.ac.uk)"
#Combines all data into a data frame of shared points. 
#Calculates a root mean square and and standard deviation comparison for each SNP pair
#which is then summed for all pairs to give the final measure. 

##IMPORTS

##FUNCTIONS
#add in data columns to an existing data frame
#takes dataframe name and .ld filename
add_DataColumn<-function(BaseFrame, FileName){
  #Get set name by using a regular expression to extract the value between _ and .ld
  SetName<-gsub("^[^_]*_([^.]+).*", "\\1", FileName)
  ColName1<-paste(SetName,"_r2Pear", sep = "")
  
  print(paste("Loading",SetName, sep=" "))
  
  #Import new table
  NewDF<-read.table(FileName)
  #Keep desired columns
  NewDF<-subset(NewDF, select = c("V1","V2","V3","V4"))
  #Rename Columns
  names(NewDF)<-c("V1"="Position1", "V2"="Position2", "V3"="Distance", "V4"=ColName1)
  
  #Merge temporary data frame with base frame

  MergeDF<-merge(BaseFrame, NewDF, by=c("Position1", "Position2", "Distance"))
  
  return(MergeDF)
}

#Calculates the root mean square deviation between two data sets for a specific measure
calc_RMSD<-function(refColumn,dataColumn){
  SumSqDiff<-0
  for (i in 1:length(refColumn)){
    SqDiff<-(refColumn[[i]]-dataColumn[[i]])^2
    SumSqDiff<-SumSqDiff+SqDiff
  }
  RMSD<-sqrt(SumSqDiff/length(refColumn))
  return(RMSD)
}

#Calculates the standard bias between two data sets for a specific measure
calc_SB<-function(refColumn,dataColumn){
  SumDiff<-0
  for (i in 1:length(refColumn)){
    if (refColumn[[i]]>0){
      Diff<-(dataColumn[[i]]-refColumn[[i]])/refColumn[[i]]
      SumDiff<-SumDiff+Diff
    }
  }
  return(SumDiff)
}

##HYPOTHETICAL RUN
#Load "True" Data from 50.ld
FullDF<-read.table("Constant_Reads50.ld")
FullDF<-subset(FullDF, select = c("V1","V2","V3","V4"))
names(FullDF)<-c("V1"="Position1", "V2"="Position2", "V3"="Distance", "V4"="r2Pear")

#List of files to use in loop
FileList<-c("Constant_Call50.ld", "Constant_Reads20.ld", "Constant_Call20.ld", "Constant_Reads10.ld", 
            "Constant_Call10.ld", "Constant_Reads5.ld", "Constant_Call5.ld", 
            "Constant_Reads2.ld", "Constant_Call2.ld")


#Empty vectors for loop
RMSDVect<-numeric()
SBVect<-numeric()

for (LDFile in FileList){
  NewDF<-add_DataColumn(FullDF, LDFile)
  
  RMSD<-calc_RMSD(NewDF$r2Pear, NewDF[,5])
  RMSDVect<-c(RMSDVect, RMSD)
  
  SB<-calc_SB(NewDF$r2Pear, NewDF[,5])
  SBVect<-c(SBVect, SB)
}

