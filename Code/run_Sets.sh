#!/bin/bash
# Author: Emma Fox e.fox16@imperial.ac.uk
# Script: run_SimSet.sh
# Desc: Can put simulations to run in this script. It formats the directory and runs the simulations using Run_Full.sh
# Arguments: none 

########################################################################
# CREATE FILES TO ADD RESULTS TO                                       #
########################################################################

#~ #Create a csv folder to ouput the parameters to
#~ echo -e "Read_Set,Model,Parameter,Value" >> ../Results/FitParams.csv
#~ #Make AIC result folder for all models to access and input best models
#~ echo "AIC Result List" > ../Results/BestAIC.txt


########################################################################
# SIMULATIONS TO RUN                                                   #
########################################################################
bash run_Sim.sh Constant 40 1 800 1000000 0.01
