#!/usr/bin/Rscript

#FileName: Graphing_3BestModels.R
#Author: "Emma Fox (e.fox16@imperial.ac.uk)"
#Used to graph the resulting parameters from the three best fitting decay models to the data. 
#Makes the graphs easier to visualize for the report. 
#Takes a data file of distances and linkage strength as input 1
#and a csv of the fit parameters as input 2. 

##IMPORTS
require(ggplot2)
require(tools)
require(gridExtra)
require(grid)

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
aicEXP<-round(Model_Data[1,3], digits=0)
init<-Model_Data[2,3]
lam<-Model_Data[3,3]
aicGAM<-round(Model_Data[4,3], digits = 0)
k<-Model_Data[5,3]
t<-Model_Data[6,3]
aicLIN<-round(Model_Data[7,3], digits = 0)
a1<-Model_Data[8,3]
b1<-Model_Data[9,3]
aicPOLY2<-round(Model_Data[10,3], digits = 0)
a2<-Model_Data[11,3]
b2<-Model_Data[12,3]
c2<-Model_Data[13,3]
aicPOLY3<-round(Model_Data[14,3], digits = 0)
a3<-Model_Data[15,3]
b3<-Model_Data[16,3]
c3<-Model_Data[17,3]
d3<-Model_Data[18,3]

#Set position of text
if (FileName=="Bottleneck_Bin_FitParams"){
  h<-0.8  
} else if (FileName=="LWK_Bin_FitParams"){
  h<-0.25  
} else if (FileName=="TSI_Bin_FitParams"){
  h<-0.35
} else if (FileName=="Expand_Bin_FitParams"){
  h<-0.25
} else {
  h<-0.5
}

#Plot the curves
#Plot the initial graph of data points
FitPlot<-ggplot(LD_Data, aes(x=Distance, y=R2)) + geom_point() + labs(x="Distance (in 100 kilo-bases)",y="r^2") 
#Add each of the 5 curves to their own plot, color code by equation, add a graph title, and AIC value
EXPPlot<-FitPlot + stat_function(fun=function(x) init * exp(lam * x), geom="line", colour="red", size=1) + 
  ggtitle("c) Exponential Decay")  + geom_text(data = NULL, x = 0.6, y = h, label = paste("AIC =", aicEXP, sep=" "))
GAMPlot<-FitPlot + stat_function(fun=function(x) exp(x * k) * x^t, geom="line", colour="yellow", size=1) + 
  ggtitle("e) Gamma") + geom_text(data = NULL, x = 0.6, y = h, label = paste("AIC =", aicGAM, sep=" "))
LINPlot<-FitPlot + stat_function(fun=function(x) a1 + b1*x, geom="line", colour="green", size=1) + 
  ggtitle("d) Linear") + geom_text(data = NULL, x = 0.6, y = h, label = paste("AIC =", aicLIN, sep=" "))
POLY2Plot<-FitPlot + stat_function(fun=function(x) a2 + b2*x + c2*x^2, geom="line", colour="blue", size=1) + 
  ggtitle("b) Quadratic") + geom_text(data = NULL, x = 0.6, y = h, label = paste("AIC =", aicPOLY2, sep=" "))
POLY3Plot<-FitPlot + stat_function(fun=function(x) a3 + b3*x + c3*x^2 + d3*x^3, geom="line", colour="purple", size=1) + 
  ggtitle("a) Cubic") + geom_text(data = NULL, x = 0.6, y = h, label = paste("AIC =", aicPOLY3, sep=" "))

#Save to jpg
pdf(file=paste(Path,"/",FileName,"_ReportFigure.pdf", sep = ""))
#Create a new page for the graphs
grid.newpage()
#set layout
pushViewport(viewport(layout = grid.layout(2, 3)))
#create a function to assign plots to places in the layout
PlotPos <- function(x, y) viewport(layout.pos.row = x, layout.pos.col = y)
#Print each graph in the right position
print(POLY3Plot, vp = PlotPos(1, 1))
print(POLY2Plot, vp = PlotPos(1, 2))
print(EXPPlot, vp = PlotPos(1, 3))
print(LINPlot, vp = PlotPos(2, 1))
print(GAMPlot, vp = PlotPos(2, 2))
dev.off()

#Alternative Layout
# print(POLY3Plot, vp = PlotPos(1, 1:2)) 
# print(POLY2Plot, vp = PlotPos(1, 3))
# print(EXPPlot, vp = PlotPos(2, 1))
# print(LINPlot, vp = PlotPos(2, 2))
# print(GAMPlot, vp = PlotPos(2, 3))
