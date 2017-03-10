#!/usr/bin/python

"""Experimenting with passing results from one model to parameters of another"""

___author__ = "Emma Fox (e.fox16@imperial.ac.uk)"
__version__ = "0.0.1"

##IMPORTS
import sys
from lmfit import minimize, Minimizer, Parameters, Parameter, report_fit, fit_report
import numpy as np
import matplotlib.pyplot as plt
import pylab
import csv

########################################################################
# DATA SET                                                             #
########################################################################
#SET 2 is somewhat similar to the kind of exponential decay data we expect with a lot of noise
#Scaled down to 100 kb
x = np.random.choice(1000000, 200000, replace=True)
data = 1*np.exp(-.000005*x) + np.random.normal(size=len(x), scale=0.1)


########################################################################
# MAKE GUESS FOR INITIAL PARAMS                                        #
########################################################################
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
report_fit(ResultLIN)

########################################################################
# RUN EXPONENTIAL FIT                                                  #
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
paramsEXP.add('lam', value=ResultLin.params.valuesdict()["b"])

ResultEXP=minimize(EXP, paramsEXP, args=(x,), kws={'data':data})
report_fit(ResultEXP)

