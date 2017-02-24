#!/usr/bin/Rscript

#FileName: Graphing_5FittedModels.R
#Author: "Emma Fox (e.fox16@imperial.ac.uk)"
#Used to graph the resulting parameters from fitting 5 decay models to the data. 
#Takes a data file of distances and linkage strength as input 1
#and a csv of the fit parameters as input 2. 

##IMPORTS
require(ggplot2)
require(tools)

#Format script to accept args
args = commandArgs(trailingOnly = TRUE)

#Format output file name as the name of the second input file, without extension, as well as changing the path to the graphing output folder
FileName <- basename(file_path_sans_ext(args[2]))
Path<-"../Fitted_Graphs"

# Import data on distance (scaled to Kilo-base-pairs rather than base pairs) and linkage
LD_Data <- read.table(args[1])
Distance <- LD_Data[,3]/100000
R2 <- LD_Data[,4]

# Import parameters from the fit curves for each of the models from the 2nd input file. 
Model_Data <- read.csv(args[2])
init<-Model_Data[2,3]
lam<-Model_Data[3,3]
k<-Model_Data[5,3]
t<-Model_Data[6,3]
a1<-Model_Data[8,3]
b1<-Model_Data[9,3]
a2<-Model_Data[11,3]
b2<-Model_Data[12,3]
c2<-Model_Data[13,3]
a3<-Model_Data[15,3]
b3<-Model_Data[16,3]
c3<-Model_Data[17,3]
d3<-Model_Data[18,3]


#Plot the curves
#Plot the initial graph of data points
FitPlot<-ggplot(LD_Data, aes(x=Distance, y=R2)) + geom_point() + labs(x="Distance (in 100 kilo-bases)",y="r^2")
#Add each of the 5 curves and color code by equation
FitPlot<-FitPlot + try(stat_function(fun=function(x) init * exp(lam * x), geom="line", aes(colour="EXP"), size=1), silent = T)
FitPlot<-FitPlot + try(stat_function(fun=function(x) exp(x * k) * x^t, geom="line", aes(colour="GAM"), size=1), silent = T) 
FitPlot<-FitPlot + try(stat_function(fun=function(x) a1 + b1*x, geom="line", aes(colour="POLY1"), size=1), silent = T)
FitPlot<-FitPlot + try(stat_function(fun=function(x) a2 + b2*x + c2*x^2, geom="line", aes(colour="POLY2"), size=1), silent = T)
FitPlot<-FitPlot + try(stat_function(fun=function(x) a3 + b3*x + c3*x^2 + d3*x^3, geom="line", aes(colour="POLY3"), size=1), silent = T)

#Save to jpg
jpeg(file=paste(Path,"/",FileName,"_ModelPlot.jpg", sep = ""))
print(FitPlot)
dev.off()