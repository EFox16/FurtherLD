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

#Put measures in data frame
MinMafDF<-data.frame(NumReads=c(50, 20, 20, 10, 10, 5, 5),
                     DataType=c("Genotype Likelihoods", "Called Genotypes", "Genotype Likelihoods", 
                                "Called Genotypes", "Genotype Likelihoods", 
                                "Called Genotypes", "Genotype Likelihoods"),
                     SB=c(64.243,8.95181e6,7.27899e6,1.91698e8,1.53388e8,8.2578e8,7.1185e8),
                     RMSD=c(0,0.002828,0.002449,0.013490,0.011916,0.029120,0.026476))
MinMafDF$NumReads<-as.factor(MinMafDF$NumReads)

PV1DF<-data.frame(NumReads=c(50, 20, 20, 10, 10, 5, 5),
                     DataType=c("Genotype Likelihoods", "Called Genotypes", "Genotype Likelihoods", 
                                "Called Genotypes", "Genotype Likelihoods", 
                                "Called Genotypes", "Genotype Likelihoods"),
                     SB=c(-12.0437,1.12786e7,9.18985e6,2.11603e8,1.72894e8,9.5144e8,8.20193e8),
                     RMSD=c(2.01640e-7,0.003316,0.003000,0.014560,0.013076,0.031400,0.028372))
PV1DF$NumReads<-as.factor(PV1DF$NumReads)

PV2DF<-data.frame(NumReads=c(50, 20, 20, 10, 10, 5, 5),
                     DataType=c("Genotype Likelihoods", "Called Genotypes", "Genotype Likelihoods", 
                                "Called Genotypes", "Genotype Likelihoods", 
                                "Called Genotypes", "Genotype Likelihoods"),
                     SB=c(-10.7276,1.09696e7,8.8722e6,2.0658e8,1.68348e8,9.16982e8,7.89493e8),
                     RMSD=c(2.11698e-7,0.003162,0.003000,0.014282,0.012806,0.030364,0.027477))
PV2DF$NumReads<-as.factor(PV2DF$NumReads)
#Plot the data
PlotSB<-function(ResultFrame, GraphName){
  ggplot(data=ResultFrame, aes(x=NumReads, y=SB, fill=DataType)) + 
    geom_bar(stat="identity", position = position_dodge()) +
    scale_x_discrete(limits = ResultFrame$DataNames) +
    scale_fill_brewer(palette = "Set1") +
    labs(title=GraphName,
         x="Number of Reads", y="Standard Bias", fill="Type of Data")
}

PlotRMSD<-function(ResultFrame, GraphName){
  PlotRMSD<-ggplot(data=ResultFrame, aes(x=NumReads, y=RMSD, fill=DataType)) +
    geom_bar(stat="identity", position = position_dodge()) +
    scale_x_discrete(limits = ResultFrame$DataNames) +
    scale_fill_brewer(palette = "Set1") +
    labs(title=GraphName,
         x="Number of Reads", y="Root Mean Square Deviation", fill="Type of Data")
}

SB_MinMaf<-PlotSB(MinMafDF, "SB (MinMaf Filtered)")
SB_PV1<-PlotSB(PV1DF, "SB (PV1 Filtered)") + guides(fill=FALSE)
SB_PV2<-PlotSB(PV2DF, "SB (PV2 Filtered)") + guides(fill=FALSE)

RMSD_MinMaf<-PlotRMSD(MinMafDF, "RMSD (MinMaf Filtered)")
RMSD_PV1<-PlotRMSD(PV1DF, "RMSD (PV1 Filtered)") + guides(fill=FALSE)
RMSD_PV2<-PlotRMSD(PV2DF, "RMSD (PV2 Filtered)") + guides(fill=FALSE)

#Save to pdf
pdf("SB.pdf")
#Create a new page for the graphs
grid.newpage()
#set layout
pushViewport(viewport(layout = grid.layout(2, 2)))
#create a function to assign plots to places in the layout
PlotPos <- function(x, y) viewport(layout.pos.row = x, layout.pos.col = y)
#Print each graph in the right position
print(SB_MinMaf, vp = PlotPos(1, 1:2))
print(SB_PV1, vp = PlotPos(2, 1))
print(SB_PV2, vp = PlotPos(2, 2))
dev.off()

pdf("RMSD.pdf")
#Create a new page for the graphs
grid.newpage()
#set layout
pushViewport(viewport(layout = grid.layout(2, 2)))
#create a function to assign plots to places in the layout
PlotPos <- function(x, y) viewport(layout.pos.row = x, layout.pos.col = y)
#Print each graph in the right position
print(RMSD_MinMaf, vp = PlotPos(1, 1:2))
print(RMSD_PV1, vp = PlotPos(2, 1))
print(RMSD_PV2, vp = PlotPos(2, 2))
dev.off()
