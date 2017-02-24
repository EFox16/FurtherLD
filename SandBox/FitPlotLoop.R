#!/usr/bin/Rscript

#FileName: Comparing_Curves.R
#Author: "Emma Fox (e.fox16@imperial.ac.uk)"
#Used to graph the best fit curves for the three scenarios and 2 real data sets on one plot

##IMPORTS
require(ggplot2)
require(tools)
require(RColorBrewer)

args = commandArgs(trailingOnly = TRUE)
#Read in a file to create the axis from

add_line<-function(Base,DataSet, LineNum){
  
  FitData<-read.csv(DataSet)
  a<-FitData[15,3]
  b<-FitData[16,3]
  c<-FitData[17,3]
  d<-FitData[18,3]
  
  Base<-Base + stat_function(fun=function(x) a + b*x + c*x^2 + d*x^3, geom="line", aes(colour = SetName), size=.5) 
  
  
  return(Base)
}


AxisData<-read.table("Try_50.Bin.csv")
Distance <- AxisData[,3]/100000
r2 <- AxisData[,4]
BasePlot<-ggplot(AxisData, aes(x=Distance, y=r2)) + ylim(0, 0.125) +
  geom_blank() + labs(x="Distance (in 100 kilo-bases)",y="r^2") 

FileList<-c("Try_2.Bin.FitParams.csv", "Try_5.Bin.FitParams.csv", "Try_10.Bin.FitParams.csv", "Try_20.Bin.FitParams.csv", "Try_50.Bin.FitParams.csv")

for (i in 1:(length(FileList))){
  BasePlot<-add_line(BasePlot, FileList[i])
}

#Maybe do brewer colour coding at the end?

FitPlot<-BasePlot + scale_colour_brewer(palette = "Set1") + labs(colour = "Reads")

pdf("Comparison_ModelPlot.pdf")
print(FitPlot)
dev.off()

