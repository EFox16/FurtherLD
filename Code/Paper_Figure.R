#!/usr/bin/Rscript

#FileName: Plot_CompStats.R
#Author: "Emma Fox (e.fox16@imperial.ac.uk)"
#Combines all data into a data frame of shared points. 
#Calculates a root mean square and and standard deviation comparison for each SNP pair
#which is then summed for all pairs to give the final measure. 

##IMPORTS
require(ggplot2)
require(gridExtra)
require(grid)
require(RColorBrewer)

##PART 1
#Create data frame for RMSD plot
MinMafDF<-data.frame(NumReads=c(50, 20, 20, 10, 10, 5, 5),
                     DataType=c("Genotype Likelihoods", "Called Genotypes", "Genotype Likelihoods", 
                                "Called Genotypes", "Genotype Likelihoods", 
                                "Called Genotypes", "Genotype Likelihoods"),
                     SB=c(64.243,8.95181e6,7.27899e6,1.91698e8,1.53388e8,8.2578e8,7.1185e8),
                     RMSD=c(0,0.002828,0.002449,0.013490,0.011916,0.029120,0.026476))
MinMafDF$NumReads<-as.factor(MinMafDF$NumReads)

#Function for plotting
PlotRMSD<-function(ResultFrame, GraphName){
  PlotRMSD<-ggplot(data=ResultFrame, aes(x=NumReads, y=RMSD, fill=DataType)) +
    geom_bar(stat="identity", position = position_dodge()) +
    scale_x_discrete(limits = ResultFrame$DataNames) +
    scale_fill_brewer(palette = "Set1") +
    labs(title=GraphName,
         x="Number of Reads", y="Root Mean Square Deviation", fill="Data Type")
}

#Command to plot
RMSD_MinMaf<-PlotRMSD(MinMafDF, " ")

##PART 2
#Import base data table
LD_Data <- read.table("../../Data/Test/Results/Test_Call20.ld")
Distance <- LD_Data[,3]/100000
R2 <- LD_Data[,4]
#Plot the initial graph of data points to get the background
FitPlot<-ggplot(LD_Data, aes(x=Distance, y=R2)) + geom_blank() + labs(x="Distance",y="r^2") 
#Add curve of the line for Turkey 
Turkey_Line<-stat_function(fun=function(x) 0.116 * exp(-2.647 * x), geom="line", colour="brown", size=1)
#Add curve for Duck 
Duck_Line<-stat_function(fun=function(x) init * exp(lam * x), geom="line", colour="green", size=1)
#Create Plot
TD_Exp<-FitPlot + Turkey_Line #+ Duck_Line

##SAVE TO PDF
#Save to pdf
pdf("Paper_Figure.pdf")
#Create a new page for the graphs
grid.newpage()
#set layout
pushViewport(viewport(layout = grid.layout(2, 1)))
#create a function to assign plots to places in the layout
PlotPos <- function(x, y) viewport(layout.pos.row = x, layout.pos.col = y)
#Print each graph in the right position
print(RMSD_MinMaf, vp = PlotPos(1, 1))
print(TD_Exp, vp = PlotPos(2, 1))
dev.off()
