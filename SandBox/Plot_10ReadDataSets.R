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
FitPlot<-ggplot(AxisData, aes(x=Distance, y=r2)) + ylim(0, 0.125) +
  geom_blank() + labs(x="Distance (in 100 kilo-bases)",y="r^2")

#Import fit params file and assign values to variables
ParamsData<-read.csv(args[1])

#2 Reads Data Set
a2<-ParamsData[15,4]
b2<-ParamsData[16,4]
c2<-ParamsData[17,4]
d2<-ParamsData[18,4]
#Create line layer to add to plot
Line2R<-stat_function(fun=function(x) a2 + (b2)*x + (c2)*x^2 + (d2)*x^3, geom="line", aes(colour="2 Reads", linetype="Likelihood"), size=1)

#2 Reads Called Genotype Data Set
a2CALL<-ParamsData[33,4]
b2CALL<-ParamsData[34,4]
c2CALL<-ParamsData[35,4]
d2CALL<-ParamsData[36,4]
#Create line layer to add to plot
Line2RCall<-stat_function(fun=function(x) a2CALL + (b2CALL)*x + (c2CALL)*x^2 + (d2CALL)*x^3, geom="line", aes(colour="2 Reads", linetype="Called"), size=1)

#5 Reads Data Set
a5<-ParamsData[51,4]
b5<-ParamsData[52,4]
c5<-ParamsData[53,4]
d5<-ParamsData[54,4]
#Create line layer to add to plot
Line5R<-stat_function(fun=function(x) a5 + (b5)*x + (c5)*x^2 + (d5)*x^3, geom="line", aes(colour="5 Reads", linetype="Likelihood"), size=1)

#5 Reads Called Genotype Data Set
a5CALL<-ParamsData[69,4]
b5CALL<-ParamsData[70,4]
c5CALL<-ParamsData[71,4]
d5CALL<-ParamsData[72,4]
#Create line layer to add to plot
Line5RCall<-stat_function(fun=function(x) a5CALL + (b5CALL)*x + (c5CALL)*x^2 + (d5CALL)*x^3, geom="line", aes(colour="5 Reads", linetype="Called"), size=1)

#10 Reads Data Set
a10<-ParamsData[87,4]
b10<-ParamsData[88,4]
c10<-ParamsData[89,4]
d10<-ParamsData[90,4]
#Create line layer to add to plot
Line10R<-stat_function(fun=function(x) a10 + (b10)*x + (c10)*x^2 + (d10)*x^3, geom="line", aes(colour="10 Reads", linetype="Likelihood"), size=1)

#10 Reads Called Genotype Data Set
a10CALL<-ParamsData[105,4]
b10CALL<-ParamsData[106,4]
c10CALL<-ParamsData[107,4]
d10CALL<-ParamsData[108,4]
#Create line layer to add to plot
Line10RCall<-stat_function(fun=function(x) a10CALL + (b10CALL)*x + (c10CALL)*x^2 + (d10CALL)*x^3, geom="line", aes(colour="10 Reads", linetype="Called"), size=1)
  
#20 Reads Data Set
a20<-ParamsData[123,4]
b20<-ParamsData[124,4]
c20<-ParamsData[125,4]
d20<-ParamsData[126,4]
#Create line layer to add to plot
Line20R<-stat_function(fun=function(x) a20 + (b20)*x + (c20)*x^2 + (d20)*x^3, geom="line", aes(colour="20 Reads", linetype="Likelihood"), size=1)

#20 Reads Called Genotype Data Set
a20CALL<-ParamsData[141,4]
b20CALL<-ParamsData[142,4]
c20CALL<-ParamsData[143,4]
d20CALL<-ParamsData[144,4]
#Create line layer to add to plot
Line20RCall<-stat_function(fun=function(x) a20CALL + (b20CALL)*x + (c20CALL)*x^2 + (d20CALL)*x^3, geom="line", aes(colour="20 Reads", linetype="Called"), size=1)

#50 Reads Data Set
a50<-ParamsData[159,4]
b50<-ParamsData[160,4]
c50<-ParamsData[161,4]
d50<-ParamsData[162,4]
#Create line layer to add to plot
Line50R<-stat_function(fun=function(x) a50 + (b50)*x + (c50)*x^2 + (d50)*x^3, geom="line", aes(colour="50 Reads", linetype="Likelihood"), size=1)

#50 Reads Called Genotype Data Set
a50CALL<-ParamsData[177,4]
b50CALL<-ParamsData[178,4]
c50CALL<-ParamsData[179,4]
d50CALL<-ParamsData[180,4]
#Create line layer to add to plot
Line50RCall<-stat_function(fun=function(x) a50CALL + (b50CALL)*x + (c50CALL)*x^2 + (d50CALL)*x^3, geom="line", aes(colour="50 Reads", linetype="Called"), size=1)

#Create ggplot layer to code for color palette and legend
ColorPal<-scale_color_brewer(palette = "Spectral", name = "Number of Reads", breaks=c("2 Reads", "5 Reads", "10 Reads", "20 Reads", "50 Reads"))

#Plot the curves on a single graph
ReadPlot<-FitPlot + Line2R + Line5R + Line10R + Line20R + Line50R + ColorPal + ggtitle("LD Decay Using Genotype Likelihoods")
CallPlot<-FitPlot + Line2RCall + Line5RCall + Line10RCall + Line20RCall + Line50R + ColorPal + ggtitle("LD Decay Using Called Genotypes")

jpeg("GenoLike_ComparisonPlot.jpg")
print(ReadPlot)
dev.off()

jpeg("GenoCall_ComparisonPlot.jpg")
print(CallPlot)
dev.off()


