#!/usr/bin/Rscript

#FileName: Plot_10ReadDataSets.R
#Author: "Emma Fox (e.fox16@imperial.ac.uk)"
#Plots curves fitted to data from 2, 5, 10, 20, and 50 reads

##IMPORTS
require(ggplot2)
require(RColorBrewer)

args = commandArgs(trailingOnly = TRUE)

#Base plot using data from input file 2
AxisData<-read.table(args[2])
Distance <- AxisData[,3]/100000
r2 <- AxisData[,4]
FitPlot<-ggplot(AxisData, aes(x=Distance, y=r2)) + ylim(0, 0.2) +
  geom_blank() + labs(x="Distance (in 100 kilo-bases)",y="r^2")

#Import fit params file and assign values to variables
ParamsData<-read.csv(args[1])
StartNum<-12
SetDiff<-15

#2 Reads Data Set
a2<-ParamsData[StartNum,4]
b2<-ParamsData[StartNum+1,4]
c2<-ParamsData[StartNum+2,4]
d2<-ParamsData[StartNum+3,4]
#Create line layer to add to plot
Line2R<-stat_function(fun=function(x) a2 + (b2)*x + (c2)*x^2 + (d2)*x^3, geom="line", aes(colour="2 Reads", linetype="Likelihood"), size=1)

#2 Reads Called Genotype Data Set
a2CALL<-ParamsData[StartNum+SetDiff,4]
b2CALL<-ParamsData[StartNum+SetDiff+1,4]
c2CALL<-ParamsData[StartNum+SetDiff+2,4]
d2CALL<-ParamsData[StartNum+SetDiff+3,4]
#Create line layer to add to plot
Line2RCall<-stat_function(fun=function(x) a2CALL + (b2CALL)*x + (c2CALL)*x^2 + (d2CALL)*x^3, geom="line", aes(colour="2 Reads", linetype="Called"), size=1)

#5 Reads Data Set
a5<-ParamsData[StartNum+(SetDiff*2),4]
b5<-ParamsData[StartNum+(SetDiff*2)+1,4]
c5<-ParamsData[StartNum+(SetDiff*2)+2,4]
d5<-ParamsData[StartNum+(SetDiff*2)+3,4]
#Create line layer to add to plot
Line5R<-stat_function(fun=function(x) a5 + (b5)*x + (c5)*x^2 + (d5)*x^3, geom="line", aes(colour="5 Reads", linetype="Likelihood"), size=1)

#5 Reads Called Genotype Data Set
a5CALL<-ParamsData[StartNum+(SetDiff*3),4]
b5CALL<-ParamsData[StartNum+(SetDiff*3)+1,4]
c5CALL<-ParamsData[StartNum+(SetDiff*3)+2,4]
d5CALL<-ParamsData[StartNum+(SetDiff*3)+3,4]
#Create line layer to add to plot
Line5RCall<-stat_function(fun=function(x) a5CALL + (b5CALL)*x + (c5CALL)*x^2 + (d5CALL)*x^3, geom="line", aes(colour="5 Reads", linetype="Called"), size=1)

#10 Reads Data Set
a10<-ParamsData[StartNum+(SetDiff*4),4]
b10<-ParamsData[StartNum+(SetDiff*4)+1,4]
c10<-ParamsData[StartNum+(SetDiff*4)+2,4]
d10<-ParamsData[StartNum+(SetDiff*4)+3,4]
#Create line layer to add to plot
Line10R<-stat_function(fun=function(x) a10 + (b10)*x + (c10)*x^2 + (d10)*x^3, geom="line", aes(colour="10 Reads", linetype="Likelihood"), size=1)

#10 Reads Called Genotype Data Set
a10CALL<-ParamsData[StartNum+(SetDiff*5),4]
b10CALL<-ParamsData[StartNum+(SetDiff*5)+1,4]
c10CALL<-ParamsData[StartNum+(SetDiff*5)+2,4]
d10CALL<-ParamsData[StartNum+(SetDiff*5)+3,4]
#Create line layer to add to plot
Line10RCall<-stat_function(fun=function(x) a10CALL + (b10CALL)*x + (c10CALL)*x^2 + (d10CALL)*x^3, geom="line", aes(colour="10 Reads", linetype="Called"), size=1)
  
#20 Reads Data Set
a20<-ParamsData[StartNum+(SetDiff*6),4]
b20<-ParamsData[StartNum+(SetDiff*6)+1,4]
c20<-ParamsData[StartNum+(SetDiff*6)+2,4]
d20<-ParamsData[StartNum+(SetDiff*6)+3,4]
#Create line layer to add to plot
Line20R<-stat_function(fun=function(x) a20 + (b20)*x + (c20)*x^2 + (d20)*x^3, geom="line", aes(colour="20 Reads", linetype="Likelihood"), size=1)

#20 Reads Called Genotype Data Set
a20CALL<-ParamsData[StartNum+(SetDiff*7),4]
b20CALL<-ParamsData[StartNum+(SetDiff*7)+1,4]
c20CALL<-ParamsData[StartNum+(SetDiff*7)+2,4]
d20CALL<-ParamsData[StartNum+(SetDiff*7)+3,4]
#Create line layer to add to plot
Line20RCall<-stat_function(fun=function(x) a20CALL + (b20CALL)*x + (c20CALL)*x^2 + (d20CALL)*x^3, geom="line", aes(colour="20 Reads", linetype="Called"), size=1)

#50 Reads Data Set
a50<-ParamsData[StartNum+(SetDiff*8),4]
b50<-ParamsData[StartNum+(SetDiff*8)+1,4]
c50<-ParamsData[StartNum+(SetDiff*8)+2,4]
d50<-ParamsData[StartNum+(SetDiff*8)+3,4]
#Create line layer to add to plot
Line50R<-stat_function(fun=function(x) a50 + (b50)*x + (c50)*x^2 + (d50)*x^3, geom="line", aes(colour="50 Reads", linetype="Likelihood"), size=1)

#50 Reads Called Genotype Data Set
a50CALL<-ParamsData[StartNum+(SetDiff*9),4]
b50CALL<-ParamsData[StartNum+(SetDiff*9)+1,4]
c50CALL<-ParamsData[StartNum+(SetDiff*9)+2,4]
d50CALL<-ParamsData[StartNum+(SetDiff*9)+3,4]
#Create line layer to add to plot
Line50RCall<-stat_function(fun=function(x) a50CALL + (b50CALL)*x + (c50CALL)*x^2 + (d50CALL)*x^3, geom="line", aes(colour="50 Reads", linetype="Called"), size=1)

#Create ggplot layer to code for color palette and legend
ColorPal<-scale_color_brewer(palette = "Spectral", name = "Number of Reads", breaks=c("2 Reads", "5 Reads", "10 Reads", "20 Reads", "50 Reads"))

#Plot the curves on a single graph
ReadPlot<-FitPlot + Line2R + Line5R + Line10R + Line20R + Line50R + ColorPal + ggtitle("LD Decay Using Genotype Likelihoods")
CallPlot<-FitPlot + Line2RCall + Line5RCall + Line10RCall + Line20RCall + Line50R + ColorPal + ggtitle("LD Decay Using Called Genotypes")

jpeg("GenoLike_ShortCubic_ComparisonPlot.jpg")
print(ReadPlot)
dev.off()

jpeg("GenoCall_ShortCubic_ComparisonPlot.jpg")
print(CallPlot)
dev.off()


