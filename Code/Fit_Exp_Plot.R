#!/usr/bin/Rscript

#FileName: Fit_Exp_Plot.R
#Author: "Emma Fox (e.fox16@imperial.ac.uk)"
#Used to graph the best fit curves for the three scenarios and 2 real data sets on one plot

##IMPORTS
require(ggplot2)
require(tools)

args = commandArgs(trailingOnly = TRUE)

Plot_Graph<-function(ParamsFile,DataFile,InitPos,LamPos){
  BaseName<-basename(file_path_sans_ext(file_path_sans_ext(DataFile)))
  FileName<-paste(BaseName,".jpg", sep = "")
  PlotTitle<-paste("LD Decay Curve for", BaseName, sep = " ")
  
  cat(paste("\n","Loading scatterplot data from ",DataFile,sep=""))  
  AxisData<-read.table(DataFile)
  Distance<-AxisData[,3]
  r2<-AxisData[,4]
  FitPlot<-ggplot(AxisData, aes(x=Distance, y=r2)) + geom_point() + labs(x="Distance",y=Y_AxisName)
  
  cat("\nLoading the equation of the fit exponential curve")
  ParamsData<-read.csv(ParamsFile)
  init<-ParamsData[InitPos,4]
  lam<-ParamsData[LamPos,4]
  ExpCurve<-stat_function(fun=function(x) init * exp(lam * x), geom="line", aes(colour="Exponential Decay Curve"), size=1)
  
  cat(paste("\n","Printing graph to ",FileName,"\n",sep = ""))
  FitPlot<-FitPlot + ExpCurve + ggtitle(PlotTitle) + theme(legend.position="none")
  jpeg(FileName)
  print(FitPlot)
  dev.off()
}

#Read in fit params file
ParamsData<-args[1]
Y_AxisName<-args[2]

for (i in 1:(length(args)-2)){
  InitPos<-(-1)+(i*3)
  LamPos<-0+(i*3)
  Plot_Graph(ParamsData,args[i+2],InitPos,LamPos)
}