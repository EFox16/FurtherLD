#!/usr/bin/Rscript

#FileName: Fit_Exp_3_Plot.R
#Author: "Emma Fox (e.fox16@imperial.ac.uk)"
#Companion to Fit_Exp.py.

##IMPORTS
require(ggplot2)
require(tools)
require(optparse)

##SPECIFY ARGUMENTS
option_list<-list(
  make_option(c("--params_file"), default=NULL,
              help = "Name of the file containing fit parameters for each file"),
  make_option(c("--plot_type"), default="AllTogether", type="character",
              help="Select which plots to generate: AllTogether, Indiv_withData, Indiv_noData")
)
opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

#If the plot_type option isn't one of the specified choices, exit the script and print help
if (opt$plot_type!="AllTogether"){
  if(opt$plot_type!="Indiv_withData"){
    if(opt$plot_type!="Indiv_noData"){
      print_help(opt_parser)
      stop("Must use either AllTogether, Indiv_withData, or Indiv_noData for plot_type", call.=FALSE)
    }
  }
}
#If no input file is provided, exit the script and print help
if (is.null(opt$params_file)){
  print_help(opt_parser)
  stop("Must supply input file.\n", call.=FALSE)
}

##SHARED STEPS##
#Load csv and information about plots
ParamsFile<-read.csv(opt$params_file)
NumPlots<-length(ParamsFile$Data_Set)/3
Data_Type<-toString(ParamsFile[1,2])


################################################################################################
##  ALL IN ONE                                                                                ##
################################################################################################
if (opt$plot_type=="AllTogether"){
  #Create name for plot and file
  BaseName<-basename(file_path_sans_ext(file_path_sans_ext(opt$params_file)))
  PlotName<-paste(BaseName,".pdf", sep = "")
  PlotTitle<-paste("LD Decay Curve for", BaseName, sep = " ")
  
  Add_Curve<-function(CurvePos1,StartPlot){
    #Function to add a curve from a data set to an existing plot
    #Create new data fram to store coefficients
    CurveDF<-data.frame("CurveName"=toString(ParamsFile[CurvePos1,1]))
    init<-ParamsFile[CurvePos1+1,4]
    lam<-ParamsFile[CurvePos1+2,4]
    
    #Create curve object
    ExpCurve<-stat_function(fun=function(x) init * exp(lam * x), geom="line", aes_(colour = toString(CurveDF$CurveName[1])), size=.5)
    NewPlot<- StartPlot + ExpCurve
    return(NewPlot)
  }
  
  #Create base data frame
  BlankDF <- data.frame()
  FitPlot<-ggplot(BlankDF) + geom_blank() + xlim(0, 100000) + ylim(0, 1)
  
  #Add curves for each file in fit parameter file
  for (i in 1:NumPlots){
    DataPos<-(i*3)-2
    FitPlot<-Add_Curve(DataPos,FitPlot)
  }
  
  #Add title and labels
  FitPlot<-FitPlot + ggtitle(PlotTitle) + theme(plot.title = element_text(hjust = 0.5)) +
    labs(x="Distance (in bases)",y=Data_Type,colour="Data Set")             
  #Save plot
  pdf(PlotName)
  print(FitPlot)
  dev.off()
}

################################################################################################
##  INDIVIDUAL WITHOUT DATA                                                                   ##
################################################################################################
if (opt$plot_type=="Indiv_noData"){
  Plot_Graph_Blank<-function(Square1Pos){
    #Function to plot a single graph for a single file
    
    #Take the file name and parse to give the base name which will be used to title and name the plot file
    DataFile_Name<-toString(ParamsFile[Square1Pos,1])
    Data_Type<-toString(ParamsFile[Square1Pos,2])
    BaseName<-basename(file_path_sans_ext(file_path_sans_ext(DataFile_Name)))
    PlotName<-paste(BaseName,".pdf", sep = "")
    PlotTitle<-paste("LD Decay Curve for", BaseName, sep = " ")
  
    #Create blank plot to plot on
    BlankDF <- data.frame()
    FitPlot<-ggplot(BlankDF) + geom_blank() + xlim(0, 100000) + ylim(0, 1) + labs(x="Distance (in bases)",y=Data_Type)
    
    #Store coefficients
    init<-ParamsFile[Square1Pos+1,4]
    lam<-ParamsFile[Square1Pos+2,4]
    #Store the exponential curve object in ggplot style
    ExpCurve<-stat_function(fun=function(x) init * exp(lam * x), geom="line", aes(colour="Exponential Decay Curve"), size=1)
    
    cat(paste("\n","Printing graph to ",PlotName,"\n",sep = ""))
    #Combine the base plot, fit curve, and title to get the final graph
    FitPlot<-FitPlot + ExpCurve + ggtitle(PlotTitle) + theme(plot.title = element_text(hjust = 0.5), legend.position="none")
    #save the graph as a jpeg
    pdf(PlotName)
    print(FitPlot)
    dev.off()
  }  
  
  #Run the function for each of the data sets in the params file
  for (i in 1:NumPlots){
    DataPos<-(i*3)-2
    Plot_Graph_Blank(DataPos)
  } 
}

################################################################################################
##  INDIVIDUAL WITH DATA                                                                      ##
################################################################################################
if (opt$plot_type=="Indiv_withData"){
  Plot_Graph_Point<-function(Square1Pos){
    #Function to plot a single graph for a single file with the data plotted as well
    #Take the file name and parse to give the base name which will be used to title and name the flot file
    DataFile_Name<-toString(ParamsFile[Square1Pos,1])
    Data_Type<-toString(ParamsFile[Square1Pos,2])
    BaseName<-basename(file_path_sans_ext(file_path_sans_ext(DataFile_Name)))
    PlotName<-paste(BaseName,".jpg", sep = "")
    PlotTitle<-paste("LD Decay Curve for", BaseName, sep = " ")
    
    #Load the data set to plot the data points
    BlankDF <- data.frame()
    AxisData<-read.table(toString(ParamsFile[Square1Pos,1]))
    Distance<-AxisData[,3]
    if (Data_Type == "r2Pear"){
      LD<-AxisData[,4]
    } else if (Data_Type == "D"){
      LD<-AxisData[,5]
    } else if (Data_Type == "DPrime"){
      LD<-AxisData[,6]
    } else if (Data_Type == "r2GLS"){
      LD<-AxisData[,7]
    }
    #Create base plot
    FitPlot<-ggplot(AxisData, aes(Distance,LD)) + geom_point() + ylim(0, 1) + labs(x="Distance (in bases)",y=Data_Type)
    
    #Store curve coefficients
    init<-ParamsFile[Square1Pos+1,4]
    lam<-ParamsFile[Square1Pos+2,4]
    #Store the exponential curve object in ggplot style
    ExpCurve<-stat_function(fun=function(x) init * exp(lam * x), geom="line", aes(colour="Exponential Decay Curve"), size=1)
    
    cat(paste("\n","Printing graph to ",PlotName,"\n",sep = ""))
    #Combine the base plot, fit curve, and title to get the final graph
    FitPlot<-FitPlot + ExpCurve + ggtitle(PlotTitle) + theme(plot.title = element_text(hjust = 0.5), legend.position="none")
    #save the graph as a jpeg
    jpeg(PlotName)
    print(FitPlot)
    dev.off()
  }  
  #Run function for each data set in params file 
  for (i in 1:NumPlots){
    DataPos<-(i*3)-2
    Plot_Graph_Point(DataPos)
  } 
}