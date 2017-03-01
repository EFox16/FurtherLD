#!/usr/bin/python

"""Checking the exponential and gamma fitting functions are working properly"""

___author__ = "Emma Fox (e.fox16@imperial.ac.uk)"
__version__ = "0.0.1"


##IMPORTS
import sys
from lmfit import minimize, Minimizer, Parameters, Parameter, report_fit, fit_report
import numpy as np
import matplotlib.pyplot as plt
import pylab
import csv

#DATA
x = np.linspace(0, 3, 50)
data = 20*np.exp(-1.5*x) + np.random.normal(size=len(x), scale=0.1)

#Plot data
plt.plot(x, data, 'ro', label="Original Data")
#plt.show()

#Save data file
np.savetxt("IdealData1.csv", zip(x, data), delimiter=',', header="x,data", comments="")


#Creates empty lists to add functions and parameters to
FunctionList=[]
ParamsList=[]

##DEFINE FUNCTIONS
#Exponential
def EXP(paramsEXP, x, data):
	"""Models exponential decay"""
	init = paramsEXP['init']
	lam = paramsEXP['lam']
	model = init * np.exp(lam * x)
	return model - data

#Create parameter set
paramsEXP = Parameters()
paramsEXP.add('init', value=1)
paramsEXP.add('lam', value=2)

FunctionList.append(EXP)
ParamsList.append(paramsEXP)

#Gamma
def GAM(paramsGAM, x, data):
	"""A gamma curve of decay"""
	k = paramsGAM['k']
	t = paramsGAM['t']
	model = np.exp(x * k) * x**t 
	return model - data

#Create parameter set
paramsGAM = Parameters()
paramsGAM.add('k', value=1)
paramsGAM.add('t', value=1)

FunctionList.append(GAM)
ParamsList.append(paramsGAM)

#Gamma with shift
def GAMSh(paramsGAMSh, x, data):
	"""A gamma curve of decay with a constant to potentially shift to the right"""
	k = paramsGAMSh['k']
	t = paramsGAMSh['t']
	c = paramsGAMSh['c']
	model = np.exp(x * k) * x**t + c 
	return model - data

#Create parameter set
paramsGAMSh = Parameters()
paramsGAMSh.add('k', value=1)
paramsGAMSh.add('t', value=1)
paramsGAMSh.add('c', value=1)

FunctionList.append(GAMSh)
ParamsList.append(paramsGAMSh)

########################################################################
# RUN FITS & SAVE RESULTS                                              #
########################################################################

#Creates a list of the names of the functions and parameters
ModelNameList=['EXP', 'GAM', 'GAMSh']
LetterList=[['init', 'lam'], ['k', 't'], ['k', 't', 'c']]

#Starts a counter used in the loop
counter=0

#Starts result lists for loop output
aicList=[]
resultList=[]

#Creates resulting file name by stripping extension from input file and adding _FitParams to the end
ResultName="IdealParams1.csv"

#Opens results file
with open(ResultName, 'wb') as csvfile:
	ResultFile = csv.writer(csvfile, delimiter=',', quotechar='|')
	#Puts headings on the csv file
	ResultFile.writerow(["Model", "Parameter", "Value"])
	
	#range 0 to 5 is the number of models
	for i in range(0,3):
		#set the name of the model being run
		ModelName=ModelNameList[i]
		#run the minimize function and save the result
		result=(minimize(FunctionList[i], ParamsList[i], args=(x,), kws={'data':data}))
		#save the result object in case we want to examine it later
		resultList.append(result)
		#save the aic values to a list
		aicList.append(result.aic)
		#save aic value to a row in the list
		ResultFile.writerow([ModelName, "AIC", result.aic])
		#this loop saves the value of each parameter. It used the counter to reference a list in the LetterList of lists. It then loops from the beginning of that list to the end and prints that letter, it's value, and the model it's from in the new csv file. 
		for i in range(0,len(LetterList[counter])):
			Letter=LetterList[counter][i]
			NewVar=result.params.valuesdict()[Letter]
			ResultFile.writerow([ModelName, Letter, NewVar])
		counter=counter + 1

	
