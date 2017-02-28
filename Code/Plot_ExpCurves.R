#!/usr/bin/Rscript

#FileName: Plot_ExpCurves.R
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
FitPlot<-ggplot(AxisData, aes(x=Distance, y=r2)) + ylim(0, 0.08) +
  geom_blank() + labs(x="Distance (in 100 kilo-bases)",y="r^2")

#Import fit params file and assign values to variables
ParamsData<-read.csv(args[1])

#2 Reads Data Set
init2<-ParamsData[2,4]
lam2<-ParamsData[3,4]
#Create line layer to add to plot
Line2R<-stat_function(fun=function(x) init2 * exp(lam2 * x), geom="line", aes(colour="2 Reads", linetype="Likelihood"), size=1)

#2 Reads Called Genotype Data Set
init2CALL<-ParamsData[20,4]
lam2CALL<-ParamsData[21,4]
#Create line layer to add to plot
Line2RCall<-stat_function(fun=function(x) init2CALL * exp(lam2CALL * x), geom="line", aes(colour="2 Reads", linetype="Called"), size=1)

#5 Reads Data Set
init5<-ParamsData[38,4]
lam5<-ParamsData[39,4]
#Create line layer to add to plot
Line5R<-stat_function(fun=function(x) init5 * exp(lam5 * x), geom="line", aes(colour="5 Reads", linetype="Likelihood"), size=1)

#5 Reads Called Genotype Data Set
init5CALL<-ParamsData[56,4]
lam5CALL<-ParamsData[57,4]
#Create line layer to add to plot
Line5RCall<-stat_function(fun=function(x) init5CALL * exp(lam5CALL * x), geom="line", aes(colour="5 Reads", linetype="Called"), size=1)

#10 Reads Data Set
init10<-ParamsData[74,4]
lam10<-ParamsData[75,4]
#Create line layer to add to plot
Line10R<-stat_function(fun=function(x) init10 * exp(lam10 * x), geom="line", aes(colour="10 Reads", linetype="Likelihood"), size=1)

#10 Reads Called Genotype Data Set
init10CALL<-ParamsData[92,4]
lam10CALL<-ParamsData[93,4]
#Create line layer to add to plot
Line10RCall<-stat_function(fun=function(x) init10CALL * exp(lam10CALL * x), geom="line", aes(colour="10 Reads", linetype="Called"), size=1)

#20 Reads Data Set
init20<-ParamsData[110,4]
lam20<-ParamsData[111,4]
#Create line layer to add to plot
Line20R<-stat_function(fun=function(x) init20 * exp(lam20 * x), geom="line", aes(colour="20 Reads", linetype="Likelihood"), size=1)

#20 Reads Called Genotype Data Set
init20CALL<-ParamsData[128,4]
lam20CALL<-ParamsData[129,4]
#Create line layer to add to plot
Line20RCall<-stat_function(fun=function(x) init20CALL * exp(lam20CALL * x), geom="line", aes(colour="20 Reads", linetype="Called"), size=1)

#50 Reads Data Set
init50<-ParamsData[146,4]
lam50<-ParamsData[147,4]
#Create line layer to add to plot
Line50R<-stat_function(fun=function(x) init50 * exp(lam50 * x), geom="line", aes(colour="50 Reads", linetype="Likelihood"), size=1)

#50 Reads Called Genotype Data Set
init50CALL<-ParamsData[164,4]
lam50CALL<-ParamsData[165,4]
#Create line layer to add to plot
Line50RCall<-stat_function(fun=function(x) init50CALL * exp(lam50CALL * x), geom="line", aes(colour="50 Reads", linetype="Called"), size=1)

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


