Repository for further LD explorations

CODE

run_Sim.sh - 
Input simulation parameters and data for sets of 2, 5, 10, 20, and 50 reads and with a minmaf threshold, p value of 0.05 threshold, or p value of 0.01 threshold are generated.

HPC_Index.sh-
Can be modified to scan a .ld data file and write the rows that match specified columns in a reference file to a new folder. 

Calculating_ComparisonStatistics.R-
Input 'true' reads file first then the 50GL and then the 20, 10, and 5 read files in the order called then read files. Will return SB and RMSD graphs

Fit_Exp.py-
Takes a single file input and outputs a file containing the fit parameters ad AIC value for an exponential decay curve fitting the data. 

Plot_Exp.R-
Takes a data file and fit parameter file inputs and returns a graph of the curve on the data.

runHPC_StartFiles.sh-
Will generate the files needed to run a simulation on the HPC cluster

runHPC_Sim.sh-
Draft pipeline for running a simulation on the HPC cluster.


RESULTS

*make sure repository contains and folder named Results



SANDBOX
runPVAL_sim.sh-
Fills out the constant data set with simulations using PVAL cutoffs.

Fit_Models_GuessInit.py - 
Fits models to the .ld files using a linear model to make some initial parameter guesses. (might be modified to take set name input)
*If running this script, make sure there are a BestAIC.txt and FitParams.csv for the output to be directed to.

Plot_ExpCurves.R - 
Plots exponential function for each read data set. (Takes single fit params file, need to change formatting back for seperate)

Create_WindowSet.R-
Used to isolate a window of the data. Ben suggested using only the first 250,000 and checking the cubic fitting with that data.

Fit_Models.py-
Fits models without having an initial guess

naming_withShellScript.sh-
Used to practice naming formats using input.

Plot_10ReadDataSets.R-
Plots the cubic curves for all 10 data sets.

Plot_FitCurves.R-
Uses a for loop to plot the lines on the graph. 
(Is currently in the format to take old input file format and has not yet generated a legend)

Fitting_TestScripts
ExpFit_HypotheticalData.py-
Generates hypothetical data in a similar format to the genome data we use with varying amounts of noise and fits exponential curves to it.

Initial_Guess.py-
For testing the use of the linear model slope as a guess for the exponential equation lamda value.

Testing_ExpFit.py-
Generates ideal exponential curve data with varying amounts of noise and fits exponential curves to it.

TestParams.csv-
Results from the two exponential data fitting scripts. 

Trying_WithNewData
FitParams.csv-
Fit params for pearson r^2 values

FitParams_R2Comp.csv-
Compares the fit params for pearson r^2 and GLS r^2 values for 50,20,and 10 reads

GenoCall_ComparisonPlot.jpg-
Compares the pearson r^2 exponential decay fit params for the called genotype data

GenoLike_ComparisonPlot.jpg-
Compares the pearson r^2 exponential decay fit params for the genotype likelihood data

GLSComp.py-
Calculates fit params for the r^2 GLs data. 

Plot_ExpCurves.R-
Plots the exponential curves for the .jpg s in the folder. 
