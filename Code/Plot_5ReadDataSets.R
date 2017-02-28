#!/usr/bin/Rscript

#FileName: Plot_5ReadDataSets.R
#Author: "Emma Fox (e.fox16@imperial.ac.uk)"
#Plots curves fitted to data from 2, 5, 10, 20, and 50 reads

##IMPORTS
require(ggplot2)
require(tools)
require(RColorBrewer)

args = commandArgs(trailingOnly = TRUE)

#Base plot using data from input file 2
AxisData<-read.table(args[2])
Distance <- AxisData[,3]/100000
r2 <- AxisData[,4]
FitPlot<-ggplot(AxisData, aes(x=Distance, y=r2)) + ylim(0, 0.125) +
  geom_blank() + labs(x="Distance (in 100 kilo-bases)",y="r^2")

#Import fit params file and assign values to variables
ParamsData<-read.csv(args[1])

#2 Reads Data Set
a2<-ParamsData[15,4]
b2<-ParamsData[16,4]
c2<-ParamsData[17,4]
d2<-ParamsData[18,4]

#5 Reads Data Set
a5<-ParamsData[33,4]
b5<-ParamsData[34,4]
c5<-ParamsData[35,4]
d5<-ParamsData[36,4]

#10 Reads Data Set
a10<-ParamsData[51,4]
b10<-ParamsData[52,4]
c10<-ParamsData[53,4]
d10<-ParamsData[54,4]

#20 Reads Data Set
a20<-ParamsData[69,4]
b20<-ParamsData[70,4]
c20<-ParamsData[71,4]
d20<-ParamsData[72,4]

#50 Reads Data Set
a50<-ParamsData[87,4]
b50<-ParamsData[88,4]
c50<-ParamsData[89,4]
d50<-ParamsData[90,4]

#Plot the curves on a single graph
FitPlot<-FitPlot + stat_function(fun=function(x) a2 + (b2)*x + (c2)*x^2 + (d2)*x^3, geom="line", aes(colour="2 Reads"), size=1)
FitPlot<-FitPlot + stat_function(fun=function(x) a5 + (b5)*x + (c5)*x^2 + (d5)*x^3, geom="line", aes(colour="5 Reads"), size=1)
FitPlot<-FitPlot + stat_function(fun=function(x) a10 + (b10)*x + (c10)*x^2 + (d10)*x^3, geom="line", aes(colour="10 Reads"), size=1)
FitPlot<-FitPlot + stat_function(fun=function(x) a20 + (b20)*x + (c20)*x^2 + (d20)*x^3, geom="line", aes(colour="20 Reads"), size=1)
FitPlot<-FitPlot + stat_function(fun=function(x) a50 + (b50)*x + (c50)*x^2 + (d50)*x^3, geom="line", aes(colour="50 Reads"), size=1)
FitPlot<-FitPlot + scale_color_brewer(palette = "RdYlBu", name = "Number of Reads", breaks=c("2 Reads", "5 Reads", "10 Reads", "20 Reads", "50 Reads"))

pdf("Comparison_ModelPlot.pdf")
print(FitPlot)
dev.off()


