#!/usr/bin/python

"""Fits an exponential, gamma, and polynomial function to a data set. FILE NAME INPUT REQUIRED"""

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
x=BPDist/100000
data=r2Pear

#Creates empty lists to add functions and parameters to
FunctionList=[]
ParamsList=[]

########################################################################
# EXPONENTIAL FUNCTION                                                 #
########################################################################

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

#Add function and parameter set to respective lists
FunctionList.append(EXP)
ParamsList.append(paramsEXP)

########################################################################
# GAMMA FUNCTION                                                       #
########################################################################

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

#Add function and parameter set to respective lists
FunctionList.append(GAM)
ParamsList.append(paramsGAM)

########################################################################
# POLYNOMIAL FUNCTIONS                                                 #
########################################################################

def POLY1(paramsPOLY1, x, data):
	"""Linear function"""
	a = paramsPOLY1['a']
	b = paramsPOLY1['b']
	model = a + b*x
	return model - data

#Create parameter set
paramsPOLY1 = Parameters()
paramsPOLY1.add('a', value=1)
paramsPOLY1.add('b', value=1)

#Add function and parameter set to respective lists
FunctionList.append(POLY1)
ParamsList.append(paramsPOLY1)

def POLY2(paramsPOLY2, x, data):
	"""Polynomial function with 3 variables and order 2"""
	a = paramsPOLY2['a']
	b = paramsPOLY2['b']
	c = paramsPOLY2['c']
	model = a + b*x + c*x**2
	return model - data

#Create parameter set
paramsPOLY2 = Parameters()
paramsPOLY2.add('a', value=1)
paramsPOLY2.add('b', value=1)
paramsPOLY2.add('c', value=1)

#Add function and parameter set to respective lists
FunctionList.append(POLY2)
ParamsList.append(paramsPOLY2)

def POLY3(paramsPOLY3, x, data):
	"""Polynomial function with 4 variables and order 3"""
	a = paramsPOLY3['a']
	b = paramsPOLY3['b']
	c = paramsPOLY3['c']
	d = paramsPOLY3['d']
	model = a + b*x + c*x**2 + d*x**3
	return model - data

#Create parameter set
paramsPOLY3 = Parameters()
paramsPOLY3.add('a', value=1)
paramsPOLY3.add('b', value=1)
paramsPOLY3.add('c', value=1)
paramsPOLY3.add('d', value=1)

#Add function and parameter set to respective lists
FunctionList.append(POLY3)
ParamsList.append(paramsPOLY3)

########################################################################
# RUN FITS & SAVE RESULTS                                              #
########################################################################

#Creates a list of the names of the functions and parameters
ModelNameList=['EXP', 'GAM', 'POLY1', 'POLY2', 'POLY3']
LetterList=[['init', 'lam'], ['k', 't'], ['a', 'b'], ['a', 'b', 'c'],['a', 'b', 'c', 'd']]

#Starts a counter used in the loop
counter=0

#Starts result lists for loop output
aicList=[]
resultList=[]

#Creates resulting file name by stripping extension from input file and adding _FitParams to the end
FileName, Exten = os.path.splitext(sys.argv[1])
ResultName = '%s_FitParams.csv' % FileName

#Opens results file
with open(ResultName, 'wb') as csvfile:
	ResultFile = csv.writer(csvfile, delimiter=',', quotechar='|')
	#Puts headings on the csv file
	ResultFile.writerow(["Model", "Parameter", "Value"])
	
	#range 0 to 5 is the number of models
	for i in range(0,5):
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

#Finds best value in AIC list
aicMin=min(aicList)
#Saves value and name of best AIC value for data set
ModelIntro='\n The best AIC value for %s is %d' % (FileName,aicMin)
for i in range(0,5):
	if aicList[i]==aicMin:
		BestModel='\n The model with the best aic value is from Model %s' % ModelNameList[i]

#Writes the above information to a joint file
with open('../Fitted_Graphs/BestAIC.txt', 'a') as f:
    f.write(ModelIntro)
    f.write(BestModel)


