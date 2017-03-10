#!/usr/bin/python

"""Checking the exponential and gamma fitting functions are working properly"""

___author__ = "Emma Fox (e.fox16@imperial.ac.uk)"
__version__ = "0.0.1"


##CREATE PARAM RESULT FILE IF NOT ALREADY EXISTING## run in TERMINAL
#echo -e "DataSet,Actual_init, Actual_lam, Fit_init, Fit_lam" > IdealParams.csv

##IMPORTS
import sys
from lmfit import minimize, Minimizer, Parameters, Parameter, report_fit, fit_report
import numpy as np
import matplotlib.pyplot as plt
import pylab
import csv

########################################################################
# DEFINE FUNCTIONS                                                     #
########################################################################
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
paramsEXP.add('lam', value=1)

##DATA

SetNames=[]
xList=[]
dataList=[]
AInitList=[]
ALamList=[]

########################################################################
# CREATE DATA SETS                                                     #
########################################################################

#~ #Plot data
#~ plt.plot(x6, data6, 'ro', label="Original Data")
#~ plt.show()

#SET 0 is normal exponential decay with a little noise
x0 = np.linspace(0, 3, 50)
data0 = 20*np.exp(-1.5*x0) + np.random.normal(size=len(x0), scale=0.1)
ActualInit0=20
ActualLam0=-1.5
#Add to List
SetNames.append("Ideal1")
xList.append(x0)
dataList.append(data0)
AInitList.append(ActualInit0)
ALamList.append(ActualLam0)



#SET 1 is normal exponential decay with more noise
x1 = np.linspace(0, 3, 50)
data1 = 20*np.exp(-1.5*x1) + np.random.normal(size=len(x1), scale=1.5)
ActualInit1=20
ActualLam1=-1.5
#Add to List
SetNames.append("Ideal2")
xList.append(x1)
dataList.append(data1)
AInitList.append(ActualInit1)
ALamList.append(ActualLam1)



#SET 2 is normal exponential decay with a lot of noise
x2 = np.linspace(0, 3, 50)
data2 = 20*np.exp(-1.5*x2) + np.random.normal(size=len(x2), scale=3)
ActualInit2=20
ActualLam2=-1.5
#Add to List
SetNames.append("Ideal3")
xList.append(x2)
dataList.append(data2)
AInitList.append(ActualInit2)
ALamList.append(ActualLam2)



########################################################################
# SAVING DATA SETS                                                     #
########################################################################

for i in range(0, len(SetNames)):
	dataSetName="%s_Data.csv" % (SetNames[i])
	np.savetxt(dataSetName, zip(xList[i], dataList[i]), delimiter=',', header="x,data", comments="")

########################################################################
# FIT MODELS AND SAVE PARAMS                                           #
########################################################################

##SAVE PARAMS
with open("IdealParams.csv", 'a') as csvfile:
	ResultFile = csv.writer(csvfile, delimiter=',', quotechar='|')
	for i in range(0, len(SetNames)):
		resultEXP = minimize(EXP, paramsEXP, args=(xList[i],), kws={'data':dataList[i]})
		ResultFile.writerow([SetNames[i], AInitList[i], ALamList[i], resultEXP.params.valuesdict()["init"], resultEXP.params.valuesdict()["lam"]])


