#!/usr/bin/Rscript

#FileName: Comparing_Curves.R
#Author: "Emma Fox (e.fox16@imperial.ac.uk)"
#Used to graph the best fit curves for the three scenarios and 2 real data sets on one plot

##IMPORTS
require(ggplot2)
require(tools)

args = commandArgs(trailingOnly = TRUE)

#Read in fit params file
ParamsData<-read.csv(args[2])
#Pull the variables from the table
init<-ParamsData[2,3]
lam<-ParamsData[3,3]
#Create line layer to add to plot
ExpCurve<-stat_function(fun=function(x) init * exp(lam * x), geom="line", aes(colour="Exponential Decay Curve"), size=1)

#Set y axis max
MaxY<-init+0.01
#Graph title
PlotTitle<-paste("LD Decay Curve for", args[3], sep = " ")
#Name for output file
FileName <- paste(basename(file_path_sans_ext(file_path_sans_ext(args[2]))), ".jpg", sep = "")

#Read in a file to create the axis from
AxisData<-read.table(args[1])
Distance <- AxisData[,3]
r2 <- AxisData[,4]
#Create blank graph to plot line on
FitPlot<-ggplot(AxisData, aes(x=Distance, y=r2)) +
  geom_point() + labs(x="Distance",y="r^2")

#Plot final graph
FitPlot<-FitPlot + ExpCurve + ggtitle(PlotTitle)

#Save to jpg
jpeg(FileName)
print(FitPlot)
dev.off()
