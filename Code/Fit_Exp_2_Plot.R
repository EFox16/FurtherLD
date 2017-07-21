#!/usr/bin/Rscript

#FileName: Fit_Exp_Plot.R
#Author: "Emma Fox (e.fox16@imperial.ac.uk)"
#Companion to Fit_Exp.py. Plots a graph of each of the files analysed with a 
#scatteplot from the data files and coefficients from the fit parameter csv.

##IMPORTS
require(ggplot2)
require(tools)

##Functions
args = commandArgs(trailingOnly = TRUE)

Plot_Graph<-function(Square1Pos){
  DataFile_Name<-toString(ParamsFile[Square1Pos,1])
  Data_Type<-toString(ParamsFile[Square1Pos,2])
  
  #Take the file name and parse to give the base name which will be used to title and name the flot file
  BaseName<-basename(file_path_sans_ext(file_path_sans_ext(DataFile_Name)))
  PlotName<-paste(BaseName,".jpg", sep = "")
  PlotTitle<-paste("LD Decay Curve for", BaseName, sep = " ")
  
  cat(paste("\n","Loading scatterplot data from ",DataFile_Name,sep=""))  
  #Import the data file and get the distance data and chosen LD measure
  AxisData<-read.table(DataFile_Name)
  Distance<-AxisData[,3]
  if (Data_Type == "r2Pear"){
    LD<-AxisData[,4]
  } else if (Data_Type == "D"){
    LD<-AxisData[,5]
  } else if (Data_Type == "DPrime"){
    LD<-AxisData[,6]
  } else if (Data_Type == "r2GLS"){
    LD<-AxisData[,7]
  }

  #Store the base scatterplot
  if (args[2] == "with_data_points"){
    FitPlot<-ggplot(AxisData, aes(x=Distance, y=LD)) + geom_point() + labs(x="Distance (in bases)",y=Data_Type)
  } else if (args[2] == "no_data_points"){
    FitPlot<-ggplot(AxisData, aes(x=Distance, y=LD)) + geom_blank() + labs(x="Distance (in bases)",y=Data_Type)
  }
  
  cat("\nLoading the equation of the fit exponential curve")
  #Use the fit params file to get the coefficients for the exponential decay function
  init<-ParamsFile[Square1Pos+1,4]
  lam<-ParamsFile[Square1Pos+2,4]
  #Store the exponential curve object in ggplot style
  ExpCurve<-stat_function(fun=function(x) init * exp(lam * x), geom="line", aes(colour="Exponential Decay Curve"), size=1)
  
  cat(paste("\n","Printing graph to ",PlotName,"\n",sep = ""))
  #Combine the base plot, fit curve, and title to get the final graph
  FitPlot<-FitPlot + ExpCurve + ggtitle(PlotTitle) + theme(legend.position="none")
  #save the graph as a jpeg
  jpeg(PlotName)
  print(FitPlot)
  dev.off()
}

##PLOTTING FOR THE DATA FILES##
ParamsFile<-read.csv(args[1])
NumPlots<-length(ParamsFile$Data_Set)/3

#This loop runs through each of the data files passed from python
for (i in 1:NumPlots){
  DataPos<-(i*3)-2
  Plot_Graph(DataPos)
}