#!/usr/bin/Rscript

#FileName: Bin_ReadData.R
#Author: "Emma Fox (e.fox16@imperial.ac.uk)"
#Used to split data into bins and calculate the average

##IMPORTS
require(reshape2)
require(tools)

#Format to accept input
args = commandArgs(trailingOnly = TRUE)

#Load the data set as a table
LD_Data<-read.table(args[1])

#Save the filename and path
FileName <- basename(file_path_sans_ext(args[1]))
Path<-dirname(args[2])

#Creates a vector of bin start and end points
SplitVect<-seq(from = 0, to = 100000, by = 50)

#Breaks up column 3 into the bins specified and calculates the average of column 4 (r^2) for each bin
ListAvg<-aggregate(LD_Data$V4, 
          list(cut(LD_Data$V3, breaks=SplitVect, right=FALSE)),
          mean)
#Save the list of averages as a vector
BinAvg<-as.vector(ListAvg$x)
#Create a list of the midpoint of distance for each bin to use as the new x data
BinMid<-seq(from = 25, by = 50, length.out = length(BinAvg))

#Create a series of blank columns to save into the csv. This is done so both .ld file and _Bin.csv files
#are in the same format and can be analysed by the same scripts
Col1<-rep(0, length.out = (length(BinAvg)))
Col2<-rep(0, length.out = (length(BinAvg)))
Col5<-rep(0, length.out = (length(BinAvg)))
Col6<-rep(0, length.out = (length(BinAvg)))
Col7<-rep(0, length.out = (length(BinAvg)))

#Compile the data into a data frame and output as a table 
OutPut<-data.frame(Col1, Col2, BinMid, BinAvg, Col5, Col6, Col7)
write.table(OutPut, file=paste(FileName,"_Bin.csv", sep = ""), col.names = F, row.names = F)
