#!/usr/bin/Rscript

#FileName: Create_WindowSet.R
#Author: "Emma Fox (e.fox16@imperial.ac.uk)"

##IMPORTS
require(reshape2)
require(tools)

#Format to accept input
args = commandArgs(trailingOnly = TRUE)

#Load the data set as a table
LD_Data<-read.table(args[1])

#Save the filename and path
FileName <- basename(file_path_sans_ext(args[1]))

#Subset the data
WindowDF<-subset(LD_Data, V3 <= 250000)

#Save new DF
write.table(WindowDF, file=paste(FileName,"_Window.csv", sep = ""), col.names = F, row.names = F)
