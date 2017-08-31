#!/usr/bin/Rscript

#FileName: Thesis_Figure_Guppy.R
#Author: "Emma Fox (e.fox16@imperial.ac.uk)"

##IMPORTS
require(ggplot2)
require(gridExtra)
require(grid)
require(RColorBrewer)

##Functions
DF1000<-read.csv("../Results/Guppy/Guppy1000.csv")
FitPlot<-ggplot(DF1000) + geom_blank() + xlim(0, 1000000) + ylim(0,0.75)
ARPlot<-FitPlot + stat_function(fun=function(x) DF1000[2,4] * exp(DF1000[3,4] * x), geom="line", colour="blue", aes(linetype = "High"),size=1) + 
                  stat_function(fun=function(x) DF1000[5,4] * exp(DF1000[6,4] * x), geom="line", colour="blue", aes(linetype = "Low"),size=1) +
                  theme(legend.justification = c(1, 1), legend.position = c(1, 1),
                  panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                  panel.background = element_blank(), axis.line = element_line(colour = "black")) +
                  labs(x="Distance (in bases)",y=expression(r^2),linetype="Predation Level")  + theme(legend.text=element_text(size=20)) 
MAPlot<-FitPlot + stat_function(fun=function(x) DF1000[8,4] * exp(DF1000[9,4] * x), geom="line", colour="orange", aes(linetype = "High"),size=1) + 
                  stat_function(fun=function(x) DF1000[11,4] * exp(DF1000[12,4] * x), geom="line", colour="orange", aes(linetype = "Low"),size=1) +
                  theme(legend.justification = c(1, 1), legend.position = c(1, 1),
                  panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                  panel.background = element_blank(), axis.line = element_line(colour = "black")) +
                  labs(x="Distance (in bases)",y=expression(r^2),linetype="Predation Level") + theme(legend.text=element_text(size=20))
QUPlot<-FitPlot + stat_function(fun=function(x) DF1000[14,4] * exp(DF1000[15,4] * x), geom="line", colour="red", aes(linetype = "High"),size=1) + 
                  stat_function(fun=function(x) DF1000[17,4] * exp(DF1000[18,4] * x), geom="line", colour="red", aes(linetype = "Low"),size=1) +
                  theme(legend.justification = c(1, 1), legend.position = c(1, 1),
                  panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                  panel.background = element_blank(), axis.line = element_line(colour = "black")) +
                  labs(x="Distance (in bases)",y=expression(r^2),linetype="Predation Level") + theme(legend.text=element_text(size=20))  
YAPlot<-FitPlot + stat_function(fun=function(x) DF1000[20,4] * exp(DF1000[21,4] * x), geom="line", colour="green", aes(linetype = "High"),size=1) + 
                  stat_function(fun=function(x) DF1000[23,4] * exp(DF1000[24,4] * x), geom="line", colour="green", aes(linetype = "Low"),size=1) +
                  theme(legend.justification = c(1, 1), legend.position = c(1, 1),
                  panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                  panel.background = element_blank(), axis.line = element_line(colour = "black")) +
                  labs(x="Distance (in bases)",y=expression(r^2),linetype="Predation Level") + theme(legend.text=element_text(size=20))  

DF200<-read.csv("../Results/Guppy/Guppy200.csv")
FitPlot<-ggplot(DF200) + geom_blank() + xlim(0, 200000) + ylim(0,0.75)
ARPlot2<-FitPlot + stat_function(fun=function(x) DF200[2,4] * exp(DF200[3,4] * x), geom="line", colour="blue", aes(linetype = "High"),size=1) + 
  stat_function(fun=function(x) DF200[5,4] * exp(DF200[6,4] * x), geom="line", colour="blue", aes(linetype = "Low"),size=1) +
  theme(legend.justification = c(1, 1), legend.position = c(1, 1),
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black")) +
  labs(x="Distance (in bases)",y=expression(r^2),linetype="Predation Level") + theme(legend.text=element_text(size=20)) 
MAPlot2<-FitPlot + stat_function(fun=function(x) DF200[8,4] * exp(DF200[9,4] * x), geom="line", colour="orange", aes(linetype = "High"),size=1) + 
  stat_function(fun=function(x) DF200[11,4] * exp(DF200[12,4] * x), geom="line", colour="orange", aes(linetype = "Low"),size=1) +
  theme(legend.justification = c(1, 1), legend.position = c(1, 1),
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black")) +
  labs(x="Distance (in bases)",y=expression(r^2),linetype="Predation Level") + theme(legend.text=element_text(size=20))  
QUPlot2<-FitPlot + stat_function(fun=function(x) DF200[14,4] * exp(DF200[15,4] * x), geom="line", colour="red", aes(linetype = "High"),size=1) + 
  stat_function(fun=function(x) DF200[17,4] * exp(DF200[18,4] * x), geom="line", colour="red", aes(linetype = "Low"),size=1) +
  theme(legend.justification = c(1, 1), legend.position = c(1, 1),
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black")) +
  labs(x="Distance (in bases)",y=expression(r^2),linetype="Predation Level") + theme(legend.text=element_text(size=20))  
YAPlot2<-FitPlot + stat_function(fun=function(x) DF200[20,4] * exp(DF200[21,4] * x), geom="line", colour="green", aes(linetype = "High"),size=1) + 
  stat_function(fun=function(x) DF200[23,4] * exp(DF200[24,4] * x), geom="line", colour="green", aes(linetype = "Low"),size=1) +
  theme(legend.justification = c(1, 1), legend.position = c(1, 1),
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black")) +
  labs(x="Distance (in bases)",y=expression(r^2),linetype="Predation Level") + theme(legend.text=element_text(size=20)) 

##SAVE TO PDF
#Save to pdf
pdf("Thesis_Figure_Guppy_1000.pdf")
#Create a new page for the graphs
grid.newpage()
#set layout
pushViewport(viewport(layout = grid.layout(2, 2)))
#create a function to assign plots to places in the layout
PlotPos <- function(x, y) viewport(layout.pos.row = x, layout.pos.col = y)
#Print each graph in the right position
print(ARPlot, vp = PlotPos(1, 1))
print(MAPlot, vp = PlotPos(1, 2))
print(QUPlot, vp = PlotPos(2, 1))
print(YAPlot, vp = PlotPos(2, 2))
dev.off()

#Save to pdf
pdf("Thesis_Figure_Guppy_200.pdf")
#Create a new page for the graphs
grid.newpage()
#set layout
pushViewport(viewport(layout = grid.layout(2, 2)))
#create a function to assign plots to places in the layout
PlotPos <- function(x, y) viewport(layout.pos.row = x, layout.pos.col = y)
#Print each graph in the right position
print(ARPlot2, vp = PlotPos(1, 1))
print(MAPlot2, vp = PlotPos(1, 2))
print(QUPlot2, vp = PlotPos(2, 1))
print(YAPlot2, vp = PlotPos(2, 2))
dev.off()

pdf("ARPlot.pdf")
print(ARPlot)
dev.off()

pdf("MAPlot.pdf")
print(MAPlot)
dev.off()

pdf("QUPlot.pdf")
print(QUPlot)
dev.off()

pdf("YAPlot.pdf")
print(YAPlot)
dev.off()

pdf("ARPlot2.pdf")
print(ARPlot2)
dev.off()

pdf("MAPlot2.pdf")
print(MAPlot2)
dev.off()

pdf("QUPlot2.pdf")
print(QUPlot2)
dev.off()

pdf("YAPlot2.pdf")
print(YAPlot2)
dev.off()
