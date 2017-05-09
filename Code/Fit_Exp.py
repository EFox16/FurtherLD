#!/usr/bin/python

"""Fits an exponential decay function to a data set. FILE NAME INPUT REQUIRED"""

___author__ = "Emma Fox (e.fox16@imperial.ac.uk)"
__version__ = "0.0.1"

########################################################################
# IMPORTS                                                              #
########################################################################
import sys
import os
import argparse
import glob
import numpy as np
from lmfit import minimize, Minimizer, Parameters, Parameter, report_fit, fit_report
import csv
import rpy2.robjects as robjects
import subprocess

########################################################################
# TAGS FOR OPTIONS                                                     #
########################################################################
parser = argparse.ArgumentParser()
parser.add_argument("input_type", choices=['FILE','FOLDER'],
					help="Specify the input: FILE or FOLDER",
					type=str)
parser.add_argument("input_name", type=str, 
					help="Specify the path to the FILE or FOLDER")
parser.add_argument("data_type", type=str, choices=['r2Pear','D','DPrime','r2GLS'],
					help="Choose which measure to plot: r2Pear, D, DPrime, or r2GLS")
parser.add_argument("--plot", 
					help="create a graph of each input file with the fit 	curve overlaid", action="store_true")
args = parser.parse_args()

# Print help if no arguments specified and quit run
if len(sys.argv) == 1:
    parser.print_help()
    sys.exit(1)

# Give some output to describe options used
print "\nData type chosen: {}".format(args.data_type)
print "Path to {} to be analysed: {}".format(args.input_type, args.input_name)

########################################################################
# LOAD DATA                                                            #
########################################################################
def Make_FileList(input_name):
	"""Takes the input and puts all the files to be analysed into a list"""
	if args.input_type == 'FILE':
		FileList=[]
		FileList.append(input_name)
	if args.input_type == 'FOLDER':
		FileList = glob.glob('%s*' % input_name)
	return FileList
		
def Load_File(file_list_pos):
	"""Loads a single file and defines the x and y axis for the graph"""
	#Opens the binned ld file
	ldFile = open(file_list_pos)
	#Loads the distance between the pairs as well as the different linkage statistics into numpy nd arrays
	BPDist,r2Pear,D,DPrime,r2GLS=np.loadtxt(ldFile, usecols=(2,3,4,5,6), unpack=True)

	#Sets the x to the distance between pairs and the response data to the r^2 value (can also change data to D, DPrime, and r2GLS)
	x=BPDist
	
	#Choose data type matching specified option
	if args.data_type == 'r2Pear':
		data=r2Pear
	elif args.data_type == 'D':
		data=D
	elif args.data_type == 'DPrime':
		data=DPrime
	elif args.data_type == 'r2GLS':
		data=r2GLS
	Axis_Data=[x,data]
	return Axis_Data
	
def GUESS(paramsGUESS, x, data):
	"""Linear function"""
	a = paramsGUESS['a']
	b = paramsGUESS['b']
	model = a + b*x
	return model - data
	
def EXP(paramsEXP, x, data):
	"""Models exponential decay"""
	init = paramsEXP['init']
	lam = paramsEXP['lam']
	model = init * np.exp(lam * x)
	return model - data

#Import list of files to work on
FileList=Make_FileList(args.input_name)

#Create name for result file
if args.input_type == 'FILE':
	FileName, Exten = os.path.splitext(os.path.basename(args.input_name))
	ResultName = '%s_%s.FitParams.csv' % (FileName, args.data_type)
if args.input_type == 'FOLDER':
	FolderName = os.path.basename(os.path.normpath(args.input_name)) 
	ResultName = '%s_%s.FitParams.csv' % (FolderName, args.data_type)
	
with open(ResultName, 'wb') as csvfile:
	ResultFile = csv.writer(csvfile, delimiter=',', quotechar='|')
	#Puts headings on the csv file
	ResultFile.writerow(["Data_Set", "Data Type", "Parameter", "Value"])
	
	#Run fitting on each file
	for i in range(0,len(FileList)):
		#Load file
		print "\nLoading data from {}".format(FileList[i])
		Axis_Data=Load_File(FileList[i])
		
		#Get the data returned from load data function
		x=Axis_Data[0]
		data=Axis_Data[1]
		
		#Create list of parameters for linear function
		paramsGUESS = Parameters()
		paramsGUESS.add('a', value=1)
		paramsGUESS.add('b', value=-1)
		
		#Run linear fitting function
		ResultGUESS=minimize(GUESS, paramsGUESS, args=(x,), kws={'data':data})
		
		#Create parameters for exponential decay curve function using guessed value from linear function
		paramsEXP = Parameters()
		paramsEXP.add('init', value=1)
		paramsEXP.add('lam', value=ResultGUESS.params.valuesdict()["b"])
		
		#Run exponential decay fitting curve function
		print "Fitting exponential decay curve function to data..."
		ResultEXP=minimize(EXP, paramsEXP, args=(x,), kws={'data':data})
		
		#Write rows to the file	
		print "Writing results to {}...".format(ResultName)
		ResultFile.writerow([os.path.basename(FileList[i]), args.data_type, "AIC", ResultEXP.aic])
		ResultFile.writerow([os.path.basename(FileList[i]), args.data_type, "init", ResultEXP.params.valuesdict()['init']])
		ResultFile.writerow([os.path.basename(FileList[i]), args.data_type, "lam", ResultEXP.params.valuesdict()['lam']])

if args.plot:
	#Use the name of the result file, the type of data used, and the files analysed as arguments for the r graphing script
	args=[ResultName] + [args.data_type] + FileList

	#HOW SHOULD I REFER TO THE PLOTTING SCRIPT? (will be in the same folder as the Fit_Exp.py script but not necessarily in the folder the script is being run) 
	print "\nBeginning plotting in R\n"
	subprocess.call(["Rscript", "Fit_Exp_Plot.R"] + args)
