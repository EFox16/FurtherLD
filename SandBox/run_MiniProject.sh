#!/bin/bash
# Author: Emma Fox e.fox16@imperial.ac.uk
# Script: run_MiniProject.sh
# Desc: Runs the bash commands for analysis of both the simulation and real data
# Arguments: NONE 

########################################################################
# CREATE RESULTS FOLDER with subfolder for graphs                      #
########################################################################

#Make directories for the results folder
mkdir ../Results/
#and for all of the fitted graphs
mkdir ../Results/Fitted_Graphs
#Make AIC result folder for all models to access in the shared graph folder
echo "AIC Result List" > ../Results/Fitted_Graphs/BestAIC.txt

########################################################################
# RUN SIMULATION SCENARIOS                                             #
########################################################################
#All populations were run for 1,000,000 base pair sites, with a reference population of 10,000, with samples from 20 diploid individuals, for 1 repetition, with a read coverage of 20 reads, and a sequencing error rate of 0.01. Theta was calculated to be 8000 using the formula:
#Theta = 4 * Ne * mu * N_Sites. 
#Ne=10,000	mu(mutation rate)=2*10^-8	N_Sites=1,000,000

#Runs simulation of a population at a constant size
bash run_Simulation.sh Constant 40 1 800 1000000 20 0.01

#Runs a simulation of a population that expanded from 10,000 individuals to 30,000 individuals, starting 400 generations ago
bash run_Simulation.sh Expand 40 1 800 1000000 20 0.01 "-eN 0 3 -G 47.7"

#Runs a simulation of a population that experienced a bottleneck 800 generations ago and dropped from 10,000 individuals to 2,000 individuals
bash run_Simulation.sh Bottleneck 40 1 800 1000000 20 0.01 "-eN 0 0.2 -eN 0.02 1"

########################################################################
# RUN REAL DATA FITTING                                                #
########################################################################

#Unzip and run analysis on the LWK data file. Analysis includes binning, fitting, and plotting.
gunzip ../Data/LWK.ld.gz
bash run_DataAnalysis.sh LWK

#Unzip and run analysis on the TSI data file. Analysis includes binning, fitting, and plotting.
gunzip ../Data/TSI.ld.gz
bash run_DataAnalysis.sh TSI

########################################################################
# RUN COMPARISON GRAPH                                                 #
########################################################################

#Create a graph comparing the best fit model for each data set
Rscript Comparing_Curves.R

########################################################################
# COMPILE LaTeX REPORT                                                 #
########################################################################
bash CompileLaTeX.sh EmmaFox_Report
