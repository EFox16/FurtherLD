#!/usr/bin/Rscript

#FileName: Calculating_ComparisonStatistics.R
#Author: "Emma Fox (e.fox16@imperial.ac.uk)"
#Combines all data into a data frame of shared points. 
#Calculates a root mean square and and standard deviation comparison for each SNP pair
#which is then summed for all pairs to give the final measure. 

##IMPORTS
require(ggplot2)
require(gridExtra)
require(grid)
require(RColorBrewer)

args = commandArgs(trailingOnly = TRUE)
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
    if (!is.nan(dataColumn[[i]])){
      SqDiff<-(refColumn[[i]]-dataColumn[[i]])^2
      SumSqDiff<-SumSqDiff+SqDiff
    }
  }
  RMSD<-sqrt(SumSqDiff/length(refColumn))
  return(RMSD)
}

#Calculates the standard bias between two data sets for a specific measure
calc_SB<-function(refColumn,dataColumn){
  SumDiff<-0
  for (i in 1:length(refColumn)){
    if (refColumn[[i]]>0 && !is.nan(dataColumn[[i]])){
      Diff<-(dataColumn[[i]]-refColumn[[i]])/refColumn[[i]]
      SumDiff<-SumDiff+Diff
    }
  }
  return(SumDiff)
}

##HYPOTHETICAL RUN
#Load "True" Data from 50.ld
FullDF<-read.table(args[1])
FullDF<-subset(FullDF, select = c("V1","V2","V3","V4"))
names(FullDF)<-c("V1"="Position1", "V2"="Position2", "V3"="Distance", "V4"="r2Pear")

#List of files to use in loop
FileList<-c(args[2], args[3], args[4], args[5], args[6], args[7], args[8]) 

#Empty vectors for loop
RMSDVect<-numeric()
SBVect<-numeric()

for (LDFile in FileList){
  FullDF<-add_DataColumn(FullDF, LDFile)
}

for (i in 5:11){
  RMSD<-calc_RMSD(FullDF$r2Pear, FullDF[,i])
  RMSDVect<-c(RMSDVect, RMSD)
  
  SB<-calc_SB(FullDF$r2Pear, FullDF[,i])
  SBVect<-c(SBVect, SB)
}

# length(which(FullDF$r2Pear==0))
# ^counts number of zeros. is a bit high. 109061

##PLOT
PlotData<-data.frame(NumReads=c(50, 20, 20, 10, 10, 5, 5),
                     DataType=c("Genotype Likelihoods", "Called Genotypes", "Genotype Likelihoods", 
                                "Called Genotypes", "Genotype Likelihoods", 
                                "Called Genotypes", "Genotype Likelihoods"),
                     SB=SBVect,
                     RMSD=RMSDVect)
PlotData$NumReads<-as.factor(PlotData$NumReads)


##MAKE PLOTS
PlotSB<-ggplot(data=PlotData, aes(x=NumReads, y=SB, fill=DataType)) +
  geom_bar(stat="identity", position = position_dodge()) +
  scale_x_discrete(limits = PlotData$DataNames) +
  scale_fill_brewer(palette = "Set1") +
  labs(title="Standard bias of r^2 estimation for various read depths",
       x="Number of Reads", y="Standard Bias", fill="Type of Data")
PlotRMSD<-ggplot(data=PlotData, aes(x=NumReads, y=RMSD, fill=DataType)) +
  geom_bar(stat="identity", position = position_dodge()) +
  scale_x_discrete(limits = PlotData$DataNames) +
  scale_fill_brewer(palette = "Set1") +
  labs(title="Root mean square deviation of r^2 estimation for various read depths",
       x="Number of Reads", y="Root Mean Square Deviation", fill="Type of Data")

pdf("SB_RMSD_Plots.pdf")
#Create a new page for the graphs
grid.newpage()
#set layout
pushViewport(viewport(layout = grid.layout(2, 1)))
#create a function to assign plots to places in the layout
PlotPos <- function(x, y) viewport(layout.pos.row = x, layout.pos.col = y)
#Print each graph in the right position
print(PlotSB, vp = PlotPos(1, 1))
print(PlotRMSD, vp = PlotPos(2, 1))
dev.off()