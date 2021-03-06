# Fit_Exp

## `LD decay` 
You can also fit an exponential distribution to estimate the rate of LD decay. We provide the script `scripts\Fit_Exp.py` but, for this type of analysis, `--rnd_sample` option should be used since `ngsLD` will be much faster and you don't really need all comparisons. The script utilizes the python package lmfit (Newville et al., 2016) to run a non-linear least-squares minimisation to fit the model to the data. The coefficients of the exponential decay equation and the Akaike Information Criterion (AIC) for each data set are printed to the output file. This script will take files generated by running the ngsLD command. In this format, the first two columns are positions of the SNPs, the third column in the distance between the SNPs, and the following 4 columns are the various measures of LD calculated.


## Exponential Decay Equation:
	LD = LD0 * e^(lambda * x)


## Input Tags:
* `--input_type STRING`:FILE or FOLDER
* `--input_name STRING`:name of FILE or FOLDER to analyse
* `--data_type STRING`:which measue of LD to analyse. options:r2Pear,r2GLS,D,DPrime. (the two measures of r2 are pearson calculations from expected genotypes and calculations from genotype likelihoods, respectively)
* `--rnd_sample FLOAT`: OPTIONAL argument. Will take a subsample of the available data to use for fitting. Useful for very large files that would otherwise take too long to run. 
* `--plot`: OPTIONAL argument. will use an additional r script to generate a plot of each data set with the fit curve overlaid. 


## Usage:
	% python Fit_Exp.py --input_type FOLDER --input_name /ngsLD/data/folder/ --data_type r2GLS --rnd_sample 0.25 --plot

## Notes:
The python script (Fit_Exp.py) calls the R script (Fit_Exp_Plot.R) automatically. In order for the plotting step to run, ensure both scripts are saved within the same directory. 
