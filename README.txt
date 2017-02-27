Repository for further LD explorations

CODE

DifferentDepth_Simulations.sh - 
Input simulation parameters and data for sets of 2, 5, 10, 20, and 50 reads are generated.

Bin_ReadData.R - 
Seperates the read data into bins (currently, have to input each file seperately, could be modified to just take set name input)

Fit_Models.py - 
Fits models to the binned files (also might be modified to take set name input)

run_Sim.sh - 
Runs all generating, binning, and fitting steps for the read data from a single simulation. 
*If running this script, make sure there are a BestAIC.txt and FitParams.csv for the output to be directed to.

run_Sets.sh -
Creates the necessary files for the pipeline. Can add sets of simulations conditions that can be passed to Run_Sim.sh

Plot_FitCurves.R - 
*In progress
Plots cubic polynomial function for each read data set.
(Is currently in the format to take old input file format and has not yet generated a legend)

RESULTS

*make sure repository contains and folder named Results



