#!/usr/bin/Rscript

#Author: "Emma Fox (e.fox16@imperial.ac.uk)"

##IMPORTS
require(ggplot2)
require(gridExtra)
require(grid)
require(RColorBrewer)

##PART 1
#Create data frame for RMSD plot
MinMafDF<-data.frame(NumReads=c(50, 20, 20, 10, 10, 5, 5, 2, 2),
                     DataType=c("Posterior Probability", "Called", "Posterior Probability", 
                                "Called", "Posterior Probability", 
                                "Called", "Posterior Probability",
                                "Called", "Posterior Probability"),
                     SB=c(3.25e-10,-0.000008,0.000012,-0.00160,0.000263,-0.000765,0.001366,-0.001384,0.006256),
                     RMSD=c(2.816e-14,0.002828,0.002828,0.012806,0.013527,0.028089,0.034684,0.046765,0.102936))
MinMafDF$NumReads<-as.factor(MinMafDF$NumReads)

#Function for plotting
PlotRMSD<-function(ResultFrame, GraphName){
  PlotRMSD<-ggplot(data=ResultFrame, aes(x=NumReads, y=RMSD, fill=DataType)) +
    geom_bar(stat="identity", position = position_dodge()) +
    scale_x_discrete(limits = ResultFrame$DataNames) +
    scale_fill_brewer(palette = "Set1") +
    labs(title=GraphName,
         x="Read Depth", y="Root Mean Square Deviation", fill="Genotype Format")
}

PlotSB<-function(ResultFrame, GraphName){
  ggplot(data=ResultFrame, aes(x=NumReads, y=SB, fill=DataType)) + 
    geom_bar(stat="identity", position = position_dodge()) +
    scale_x_discrete(limits = ResultFrame$DataNames) +
    scale_fill_brewer(palette = "Set1") +
    labs(title=GraphName,
         x="Read Depth", y="Standard Bias", fill="Genotype Format")
}

ParamsFile<-read.csv("../Results/Constant/FitTry2.csv")
NumPlots<-length(ParamsFile$Data_Set)/3
Data_Type<-toString(ParamsFile[1,2])



#Create name for plot and file
PlotTitle<-paste("LD decay curve for", "different read depths", sep = " ")

Add_Curve<-function(CurvePos1,StartPlot){
  #Function to add a curve from a data set to an existing plot
  #Create new data fram to store coefficients
  CurveDF<-data.frame("CurveName"=toString(ParamsFile[CurvePos1,1]),"CurveType"=toString(ParamsFile[CurvePos1,5]))
  init<-ParamsFile[CurvePos1+1,4]
  lam<-ParamsFile[CurvePos1+2,4]
  
  #Create curve object
  ExpCurve<-stat_function(fun=function(x) init * exp(lam * x), geom="line", 
                          aes_(colour = toString(CurveDF$CurveName[1]),linetype = toString(CurveDF$CurveType[1])),
                          size=.5)
  NewPlot<- StartPlot + ExpCurve
  return(NewPlot)
}

#Command to plot
RMSD_MinMaf<-PlotRMSD(MinMafDF, " ") + theme(plot.title = element_text(hjust = 0.5), 
                                             legend.justification = c(1, 1), legend.position = c(1, 1),
                                             panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                                             panel.background = element_blank(), axis.line = element_line(colour = "black")) 

SB_MinMaf<-PlotSB(MinMafDF, " ") + theme(plot.title = element_text(hjust = 0.5), 
                                         legend.justification = c(1, 1), legend.position = c(1, 1),
                                         panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                                         panel.background = element_blank(), axis.line = element_line(colour = "black"))
#Create base data frame
BlankDF <- data.frame()
FitPlot<-ggplot(BlankDF) + geom_blank() + xlim(0, 1000000) + ylim(0,0.08)
#Add curves for each file in fit parameter file
for (i in 1:NumPlots){
  DataPos<-(i*3)-2
  FitPlot<-Add_Curve(DataPos,FitPlot)
}  
#Add title and labels
FitPlot<-FitPlot + theme(legend.justification = c(1, 1), legend.position = c(1, 1),
                         panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                         panel.background = element_blank(), axis.line = element_line(colour = "black")) +
  labs(x="Distance (in bases)",y=expression(r^2),colour="Read Depth",linetype="Genotype Format") +
  scale_color_discrete(breaks=c("2","5","10","20","50")) 



##SAVE TO PDF
#Save to pdf
pdf("Thesis_Figure_Constant2.pdf")
#Create a new page for the graphs
grid.newpage()
#set layout
pushViewport(viewport(layout = grid.layout(3, 1)))
#create a function to assign plots to places in the layout
PlotPos <- function(x, y) viewport(layout.pos.row = x, layout.pos.col = y)
#Print each graph in the right position
print(RMSD_MinMaf, vp = PlotPos(1, 1))
print(SB_MinMaf, vp = PlotPos(2, 1))
print(FitPlot, vp = PlotPos(3, 1))
dev.off()

pdf("Constant_A2.pdf")
print(RMSD_MinMaf)
dev.off()

pdf("Constant_B2.pdf")
print(SB_MinMaf)
dev.off()

pdf("Constant_C2.pdf")
print(FitPlot)
dev.off()