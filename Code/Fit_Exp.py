#!/usr/bin/python

"""Fits an exponential decay function to a data set. FILE NAME INPUT REQUIRED"""

___author__ = "Emma Fox (e.fox16@imperial.ac.uk)"
__version__ = "0.0.1"

########################################################################
# IMPORTS                                                              #
########################################################################

import sys
from lmfit import minimize, Minimizer, Parameters, Parameter, report_fit, fit_report
import numpy as np
import os
import csv

########################################################################
# LOAD DATA                                                            #
########################################################################

#Opens the binned ld file
ldFile = open(sys.argv[1])

#Loads the distance between the pairs as well as the different linkage statistics into numpy nd arrays
BPDist,r2Pear,D,DPrime,r2GLS=np.loadtxt(ldFile, usecols=(2,3,4,5,6), unpack=True)

#Sets the x to zero and the response data to the r^2 value
x=BPDist
data=r2Pear

########################################################################
# MAKE GUESS FOR INITIAL PARAMS                                        #
########################################################################
#Fit a linear model. Use the slope of the model as a starting point for exponential 'slope'
def GUESS(paramsGUESS, x, data):
	"""Linear function"""
	a = paramsGUESS['a']
	b = paramsGUESS['b']
	model = a + b*x
	return model - data

#Create parameter set
paramsGUESS = Parameters()
paramsGUESS.add('a', value=1)
paramsGUESS.add('b', value=-1)

#Run fitting function and save results dictionary
ResultGUESS=minimize(GUESS, paramsGUESS, args=(x,), kws={'data':data})


########################################################################
# EXPONENTIAL FUNCTION                                                 #
########################################################################

def EXP(paramsEXP, x, data):
	"""Models exponential decay"""
	init = paramsEXP['init']
	lam = paramsEXP['lam']
	model = init * np.exp(lam * x)
	return model - data

#Create parameter set with initial guess for slope
paramsEXP = Parameters()
paramsEXP.add('init', value=1)
paramsEXP.add('lam', value=ResultGUESS.params.valuesdict()["b"])


########################################################################
# RUN FITS & SAVE RESULTS                                              #
########################################################################

#Run fitting function
ResultEXP=minimize(EXP, paramsEXP, args=(x,), kws={'data':data})

#Creates resulting file name by stripping extension from input file and adding _FitParams to the end
FileName, Exten = os.path.splitext(sys.argv[1])
ResultName = '%s.FitParams.csv' % FileName

#Opens results file and inputs the equation data
with open(ResultName, 'a') as csvfile:
	ResultFile = csv.writer(csvfile, delimiter=',', quotechar='|')
	#Puts headings on the csv file
	ResultFile.writerow(["Data_Set", "Parameter", "Value"])
	ResultFile.writerow([SetName, "AIC", ResultEXP.aic])
	ResultFile.writerow([SetName, "init", ResultEXP.params.valuesdict()['init']])
	ResultFile.writerow([SetName, "lam", ResultEXP.params.valuesdict()['lam']])
	
