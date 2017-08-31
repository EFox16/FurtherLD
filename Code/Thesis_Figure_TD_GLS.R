#!/usr/bin/Rscript

#FileName: Thesis_Figure_TD_GLS.R
#Author: "Emma Fox (e.fox16@imperial.ac.uk)"

##IMPORTS
require(ggplot2)
require(gridExtra)
require(grid)
require(RColorBrewer)

##Data Prune
TurkeyDF<-read.csv("../Results/TD/T_GLS_100_Boot.csv")
TurkeyInit<-subset(TurkeyDF, Parameter == "init")
TurkeyInit<-TurkeyInit[order(TurkeyInit$Value),]
TurkeyLam<-subset(TurkeyDF, Parameter == "lam")
TurkeyLam<-TurkeyLam[order(TurkeyLam$Value),]
TurkeyCurve<-read.csv("../Results/TD/Turkey_GLS.csv")
TurkeyInit$CurveVal <- rep(TurkeyCurve[2,4],nrow(TurkeyInit))
TurkeyLam$CurveVal <- rep(TurkeyCurve[3,4],nrow(TurkeyLam))

DuckDF<-read.csv("../Results/TD/D_GLS_100_Boot.csv")
DuckInit<-subset(DuckDF, Parameter == "init")
DuckInit<-DuckInit[order(DuckInit$Value),]
DuckLam<-subset(DuckDF, Parameter == "lam")
DuckLam<-DuckLam[order(DuckLam$Value),]
DuckCurve<-read.csv("../Results/TD/Duck_GLS.csv")
DuckInit$CurveVal <- rep(DuckCurve[2,4],nrow(DuckInit))
DuckLam$CurveVal <- rep(DuckCurve[3,4],nrow(DuckLam))

##Plot
TurkeyCurve<-stat_function(fun=function(x) TurkeyInit[1,5] * exp(TurkeyLam[1,5] * x), geom="line", 
                           aes(colour = "Turkey"),
                           size=.5)
DuckCurve<-stat_function(fun=function(x) DuckInit[1,5] * exp(DuckLam[1,5] * x), geom="line", 
                         aes(colour = "Duck"),
                         size=.5)
BaseDF<-data.frame(
  x=seq(1,10000000,by=1000),
  y=seq(0,0.25)
)
BoundsDF<-data.frame(
  x=BaseDF$x,
  Tmin=TurkeyInit[95,4] * exp(TurkeyLam[95,4] * BaseDF$x),
  Tmax=TurkeyInit[6,4] * exp(TurkeyLam[6,4] * BaseDF$x),
  Dmin=DuckInit[95,4] * exp(DuckLam[95,4] * BaseDF$x),
  Dmax=DuckInit[6,4] * exp(DuckLam[6,4] * BaseDF$x)
)
FullDF<-merge(BaseDF,BoundsDF,by.x = 'x')

TD_Plot<-ggplot(FullDF, aes(x=x,y=y)) + geom_blank() + xlim(0, 1000000) + ylim(0,0.25) +
  geom_ribbon(aes(x=x,ymin=Tmin,ymax=Tmax),fill="brown",alpha=0.1) + TurkeyCurve +
  geom_ribbon(aes(x=x,ymin=Dmin,ymax=Dmax),fill="green",alpha=0.25) + DuckCurve +
  theme(legend.justification = c(1, 1), legend.position = c(1, 1),
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black")) +
  labs(x="Distance (in bases)",y=expression(r^2),colour="Species") +
  scale_colour_manual("Species", values = c("Turkey" ="brown","Duck" = "green"))

pdf("Turkey_Duck_GLS.pdf")
print(TD_Plot)
dev.off()