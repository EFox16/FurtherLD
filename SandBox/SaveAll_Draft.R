#!/usr/bin/Rscript

#FileName: Fit_Exp_Plot.R
#Author: "Emma Fox (e.fox16@imperial.ac.uk)"
#Companion to Fit_Exp.py. Plots a graph of each of the files analysed with a 
#scatteplot from the data files and coefficients from the fit parameter csv.

##IMPORTS
require(ggplot2)
require(tools)
require(RColorBrewer)

##Functions
args = commandArgs(trailingOnly = TRUE)

ParamsFile<-read.csv("../../MacLD/ALL.ld_r2GLS.FitParams.csv")
NumPlots<-length(ParamsFile$Data_Set)/3

#DataFile_Name<-toString(ParamsFile[1,1])
Data_Type<-toString(ParamsFile[1,2])

#Take the file name and parse to give the base name which will be used to title and name the flot file
BaseName<-basename(file_path_sans_ext(file_path_sans_ext("../../MacLD/ALL.ld_r2GLS.FitParams.csv")))
PlotName<-paste(BaseName,".jpg", sep = "")
PlotTitle<-paste("LD Decay Curve for", BaseName, sep = " ")

#cat(paste("\n","Loading scatterplot data from ",DataFile_Name,sep=""))  
#Import the data file and get the distance data and chosen LD measure
AxisData<-read.table(toString(ParamsFile[1,1]))
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

Add_Curve<-function(CurvePos1,StartPlot){
  CurveDF<-data.frame("CurveName"=toString(ParamsFile[CurvePos1,1]))
  init<-ParamsFile[CurvePos1+1,4]
  lam<-ParamsFile[CurvePos1+2,4]
  
  ExpCurve<-stat_function(fun=function(x) init * exp(lam * x), geom="line", aes_(colour = toString(CurveDF$CurveName[1])), size=.5)
  NewPlot<- StartPlot + ExpCurve
  return(NewPlot)
}

FitPlot<-ggplot(AxisData, aes(x=Distance, y=LD)) + geom_blank() 

for (i in 1:NumPlots){
  DataPos<-(i*3)-2
  FitPlot<-Add_Curve(DataPos,FitPlot)
}

FitPlot + labs(x="Distance (in bases)",y=Data_Type,colour="Data Set") 
FitPlot
