#!/usr/bin/python

"""Checking the exponential fitting functions are working properly for the type of data we're using'"""

___author__ = "Emma Fox (e.fox16@imperial.ac.uk)"
__version__ = "0.0.1"


##CREATE PARAM RESULT FILE IF NOT ALREADY EXISTING## run in TERMINAL
#echo -e "DataSet,Actual_init, Actual_lam, Fit_init, Fit_lam" > TestParams.csv

##IMPORTS
import sys
from lmfit import minimize, Minimizer, Parameters, Parameter, report_fit, fit_report
import numpy as np
import matplotlib.pyplot as plt
import pylab
import csv

########################################################################
# MAKE GUESS FOR INITIAL PARAMS                                        #
########################################################################
#SET 2 is somewhat similar to the kind of exponential decay data we expect with a lot of noise
x = np.random.choice(1000000, 200000, replace=True)
data = 1*np.exp(-.000005*x) + np.random.normal(size=len(x), scale=0.1)

def LIN(paramsLIN, x, data):
	"""Linear function"""
	a = paramsLIN['a']
	b = paramsLIN['b']
	model = a + b*x
	return model - data

#Create parameter set
paramsLIN = Parameters()
paramsLIN.add('a', value=1)
paramsLIN.add('b', value=-1)

ResultLIN=minimize(LIN, paramsLIN, args=(x,), kws={'data':data})

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
paramsEXP.add('lam', value=ResultLIN.params.valuesdict()["b"])

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

#SET 0 is somewhat similar to the kind of exponential decay data we expect
#Scaled down to 100 kb
x3 = np.random.choice(1000000, 200000, replace=True)
data3 = 1*np.exp(-.000005*x3) 
ActualInit3=1
ActualLam3=-0.000005
#Add to List
SetNames.append("HypotheticalLD1")
xList.append(x3)
dataList.append(data3)
AInitList.append(ActualInit3)
ALamList.append(ActualLam3)



#SET 1 is somewhat similar to the kind of exponential decay data we expect with some noise
#Scaled down to 100 kb
x4 = np.random.choice(1000000, 200000, replace=True)
data4 = 1*np.exp(-.000005*x4) + np.random.normal(size=len(x4), scale=0.01)
ActualInit4=1
ActualLam4=-0.000005
#Add to List
SetNames.append("HypotheticalLD2")
xList.append(x4)
dataList.append(data4)
AInitList.append(ActualInit4)
ALamList.append(ActualLam4)



#SET 2 is somewhat similar to the kind of exponential decay data we expect with a lot of noise
#Scaled down to 100 kb
x5 = np.random.choice(1000000, 200000, replace=True)
data5 = 1*np.exp(-.000005*x5) + np.random.normal(size=len(x5), scale=0.1)
ActualInit5=1
ActualLam5=-0.000005
#Add to List
SetNames.append("HypotheticalLD3")
xList.append(x5)
dataList.append(data5)
AInitList.append(ActualInit5)
ALamList.append(ActualLam5)



#SET 3 is somewhat similar to the kind of exponential decay data we expect WHEN BINNED
#Scaled down to 100 kb
x6 = np.linspace(0, 1000000, 20000)
data6 = 1*np.exp(-.000005*x6) 
ActualInit6=1
ActualLam6=-0.000005
#Add to List
SetNames.append("BinLD1")
xList.append(x6)
dataList.append(data6)
AInitList.append(ActualInit6)
ALamList.append(ActualLam6)



#SET 4 is somewhat similar to the kind of exponential decay data we expect WHEN BINNED with some noise
#Scaled down to 100 kb
x7 = np.linspace(0, 1000000, 20000)
data7 = 1*np.exp(-.000005*x7) + np.random.normal(size=len(x7), scale=0.01)
ActualInit7=1
ActualLam7=-0.000005
#Add to List
SetNames.append("BinLD2")
xList.append(x7)
dataList.append(data7)
AInitList.append(ActualInit7)
ALamList.append(ActualLam7)



#SET 5 is somewhat similar to the kind of exponential decay data we expect WHEN BINNED with a lot of noise
#Scaled down to 100 kb
x8 = np.linspace(0, 1000000, 20000)
data8 = 1*np.exp(-.000005*x8) + np.random.normal(size=len(x8), scale=0.1)
ActualInit8=1
ActualLam8=-0.000005
#Add to List
SetNames.append("BinLD3")
xList.append(x8)
dataList.append(data8)
AInitList.append(ActualInit8)
ALamList.append(ActualLam8)
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
with open("TestParams.csv", 'a') as csvfile:
	ResultFile = csv.writer(csvfile, delimiter=',', quotechar='|')
	for i in range(0, len(SetNames)):
		resultEXP = minimize(EXP, paramsEXP, args=(xList[i],), kws={'data':dataList[i]})
		ResultFile.writerow([SetNames[i], AInitList[i], ALamList[i], resultEXP.params.valuesdict()["init"], resultEXP.params.valuesdict()["lam"]])


