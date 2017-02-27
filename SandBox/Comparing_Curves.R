#!/usr/bin/Rscript

#FileName: Comparing_Curves.R
#Author: "Emma Fox (e.fox16@imperial.ac.uk)"
#Used to graph the best fit curves for the three scenarios and 2 real data sets on one plot

##IMPORTS
require(ggplot2)
require(tools)

args = commandArgs(trailingOnly = TRUE)
#Read in a file to create the axis from
AxisData<-read.table(args[6])
Distance <- AxisData[,3]/100000
r2 <- AxisData[,4]
FitPlot<-ggplot(AxisData, aes(x=Distance, y=R2)) + geom_blank() + labs(x="Distance (in 100 kilo-bases)",y="r^2")
Names<-c("2 Reads", "5 Reads", "10 Reads", "20 Reads", "50 Reads")

#Function that adds a new line to a graph
add_line<-function(Base,DataSet){
  #Name the set
  SetName<-basename(file_path_sans_ext(DataSet))
  SetName<-file_path_sans_ext(SetName)
  SetName<-file_path_sans_ext(SetName)
  SetName<-toString(SetName)
  
  #Read in the data
  FitData<-read.csv(DataSet)
  a<-FitData[15,3]
  b<-FitData[16,3]
  c<-FitData[17,3]
  d<-FitData[18,3]
  
  #Plot the function
  Base<-Base + stat_function(fun=function(x) a + b*x + c*x^2 + d*x^3, geom="line", colour=, aes(colour = SetName), size=.5) 
  
  #Return the graph
  return(Base)
}


AxisData<-read.table(args[6])
Distance <- AxisData[,3]/100000
r2 <- AxisData[,4]
FitPlot<-ggplot(AxisData, aes(x=Distance, y=r2)) + ylim(0, 0.125) +
  geom_blank() + labs(x="Distance (in 100 kilo-bases)",y="r^2") +
  scale_colour_brewer(palette = "Set1") + labs(colour = "Reads")

#File list for testing
#FileList<-c("Try_2.Bin.FitParams.csv", "Try_5.Bin.FitParams.csv", "Try_10.Bin.FitParams.csv", "Try_20.Bin.FitParams.csv", "Try_50.Bin.FitParams.csv")

for (i in 1:(length(args)-1)){
  FitPlot<-add_line(FitPlot, args[i])
}

#Save the plot
# pdf("Comparison_ModelPlot.pdf")
# print(FitPlot)
# dev.off()

