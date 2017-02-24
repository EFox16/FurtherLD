#!/bin/bash
# Author: Emma Fox e.fox16@imperial.ac.uk
# Script: run_DataAnalysis.sh
# Desc: Runs each of the real human data sets through the binning, fitting, and plotting process. 
# Arguments: LWK or TSI depending on the desired file.   

########################################################################
# CREATE RESULTS FOLDER                                                #
########################################################################

#Makes and moves to a results folder to contain the various output files
mkdir ../Results/$1
cd ../Results/$1

########################################################################
# BIN DATA  														   #
########################################################################

#Breaks the data into bins of pairs that are 50*n pairs apart for easier visualization
Rscript ../../Code/Bin_ReadData.R ../../Data/$1.ld

########################################################################
# MODEL FITTING                                                        #
########################################################################

#Fits 5 model curves (an exponential, gamma, linear, and 2 polynomial) to the data. Returns a file of the fit parameters as well as a file of AIC values for comparison.
python ../../Code/Fit_5Models.py $1_Bin.csv

########################################################################
# PLOT FITTED PARAMETERS 											   #
########################################################################

#Takes the output of the binning step and the output of the fitting step to plot the data set and fitted curves
Rscript ../../Code/Graphing_5FittedModels.R $1_Bin.csv $1_Bin_FitParams.csv

#Plots all 5 curves seperately for the report figures
Rscript ../../Code/Graphing_ReportFigures.R $1_Bin.csv $1_Bin_FitParams.csv

########################################################################
# BACK TO CODE FOLDER                                                  #
########################################################################

#Returns to code folder to begin next set
cd ../../Code
