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

#Plot a graph using the data file and fit parameters file
Plot_Graph<-function(ParamsFile,DataFile,DataType,InitPos,LamPos){
  #Take the file name and parse to give the base name which will be used to title and name the flot file
  BaseName<-basename(file_path_sans_ext(file_path_sans_ext(DataFile)))
  FileName<-paste(BaseName,".jpg", sep = "")
  PlotTitle<-paste("LD Decay Curve for", BaseName, sep = " ")
  
  cat(paste("\n","Loading scatterplot data from ",DataFile,sep=""))  
  #Import the data file and get the distance data and chosen LD measure
  AxisData<-read.table(DataFile)
  Distance<-AxisData[,3]
  if (DataType == "r2Pear"){
    LD<-AxisData[,4]
  } else if (DataType == "D"){
    LD<-AxisData[,5]
  } else if (DataType == "DPrime"){
    LD<-AxisData[,6]
  } else if (DataType == "r2GLS"){
    LD<-AxisData[,7]
  }
  #Store the base scatterplot
  FitPlot<-ggplot(AxisData, aes(x=Distance, y=LD)) + geom_point() + labs(x="Distance (in bases)",y=DataType)
  
  cat("\nLoading the equation of the fit exponential curve")
  #Use the fit params file to get the coefficients for the exponential decay function
  ParamsData<-read.csv(ParamsFile)
  init<-ParamsData[InitPos,4]
  lam<-ParamsData[LamPos,4]
  #Store the exponential curve object in ggplot style
  ExpCurve<-stat_function(fun=function(x) init * exp(lam * x), geom="line", aes(colour="Exponential Decay Curve"), size=1)
  
  cat(paste("\n","Printing graph to ",FileName,"\n",sep = ""))
  #Combine the base plot, fit curve, and title to get the final graph
  FitPlot<-FitPlot + ExpCurve + ggtitle(PlotTitle) + theme(legend.position="none")
  #save the graph as a jpeg
  jpeg(FileName)
  print(FitPlot)
  dev.off()
}

#Read in fit params file
ParamsData<-args[1]
#Read in chosen LD data type
DataType<-args[2]

#This loop runs through each of the data files passed from python
for (i in 1:(length(args)-2)){
  #Get the position of the expoenntial decay equations for each file
  InitPos<-(-1)+(i*3)
  LamPos<-0+(i*3)
  #Run the plotting function
  Plot_Graph(ParamsData,args[i+2],DataType,InitPos,LamPos)
}