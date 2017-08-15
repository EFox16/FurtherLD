#!/usr/bin/python

"""Bootstraps a data file"""

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
import csv
import subprocess
import random
import linecache

########################################################################
# FUNCTIONS                                                            #
########################################################################

input_file=sys.argv[1]
output_file=sys.argv[2]

start_pos=0
end_pos=1731841
group_pos_list=[]
#Create list of the positions in each of the 100 blocks 
for i in range(0,100):
	new_pos_list=list(range(start_pos,end_pos))
	group_pos_list.append(new_pos_list)
	start_pos=start_pos+1731841
	end_pos=end_pos+1731841

#Select 100 blocks randomly with replacement
#And write those rows to a new file
for i in range(1,11):
	new_file='%s_%d.ld' % (output_file,i)
	with open(new_file,"wb") as sink:
		for i in np.random.choice(range(0,100),100):
			for row in group_pos_list[i]: 
				sink.write(linecache.getline(input_file, row))
	linecache.clearcache()
