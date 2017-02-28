#!/bin/bash
# Author: Emma Fox e.fox16@imperial.ac.uk
# Script: Run_Full.sh
# Desc: Pipeline using ms to simulate, ANGSD to transform the files, and ngsLD to analyze with command line argument inputs to simulate a set of genomes for the scenario. The data is then binned using R, models are fitted to its distribution using python, and the resulting equations and parameters are plotted to the data using R. 
# Arguments: set name, number of samples, number of repetitions, theta, number of sites, sequencing depth, error rate, AND exponential growth rate OR bottleneck time and magnitude 

########################################################################
# CREATE RESULTS FOLDER with reference sequence                        #
########################################################################

#This process generates quite a few output files so this step creates a folder for those files. Moving the working directory to this new folder simplifies the processing of the various files. 
mkdir ../Results/$1
cd ../Results/$1

#Create a csv file to ouput the parameters to
echo -e "Read_Set,Model,Parameter,Value" >> FitParams.csv
#Make AIC result folder for all models to access and input best models
echo "AIC Result List" > BestAIC.txt


#Need to create a fast file with a reference sequence. Used to establish relative position of bases by a program in a later step. 
Rscript -e 'cat(">reference\n",paste(rep("A",1e6),sep="", collapse=""),"\n",sep="")' > reference.fa 

#Further formats the reference file
samtools faidx reference.fa #should give reference.fa.fai


########################################################################
# SETTING VARIABLES                                                    #
########################################################################

#Takes each term in the input and assigns it to a variable name
SET_NAME=$1
N_SAM=$2 
N_REPS=$3 
THETA=$4 
RHO=$THETA
N_SITES=$5 
ERR_RATE=$6

#Calculated variables
N_IND=$((N_SAM / 2))
MINMAF=$(echo "scale=2; 2/$N_SAM" | bc)

########################################################################
# RUN MS                                                               #
########################################################################

#If there are only 7 values input, run ms with the assigned variables to generate data about the location and haplotype of variable sites in hypothetical genomes
#If there are 8 values, the 8th describes some demographic event in the history of the population

if [ $# = 6 ]
then
	/usr/bin/ms $N_SAM $N_REPS -t $THETA -r $RHO $N_SITES > $1.txt
elif [ $# = 7 ]
then
	SIMULATION_EVENTS=$8
	/usr/bin/ms $N_SAM $N_REPS -t $THETA -r $RHO $N_SITES $SIMULATION_EVENTS > $1.txt
fi

for i in 2 5 10 20 50
do
	########################################################################
	# CONVERT WITH ANGSD                                                   #
	########################################################################

	#ANGSD converts ms output to glf file type which can be read by later programs
	/usr/bin/msToGlf -in $1.txt -out $1_reads$i -regLen $N_SITES -singleOut 1 -depth $i -err $ERR_RATE -pileup 0 -Nsites 0

	#This step generates a file that includes the full genome sequence rather than just the variable sites. Original reference file is used here. 
	/usr/bin/angsd -glf $1_reads$i.glf.gz -fai reference.fa.fai -nInd $N_IND -doMajorMinor 1 -doPost 1 -doMaf 1 -doGeno 32 -out $1_reads$i -isSim 1 -minMaf $MINMAF

	#Unzip output files
	gunzip -f $1_reads$i.geno.gz

	########################################################################
	# RUN ngsLD                                                            #
	########################################################################

	#Create position file that is the length of the file just created 
	zcat $1_reads$i.mafs.gz | cut -f 1,2 | tail -n +2 > $1_pos$i.txt
	NS=`cat $1_pos$i.txt | wc -l` 

	#Run ngsLD. This will output a file with each row representing two SNPs. The file includes the position of each, the distace between the sites, and several  measures of the strength of the linkage between them 
	/usr/bin/ngsLD --verbose 1 --n_ind $N_IND --n_sites $NS --geno $1_reads$i.geno --probs --pos $1_pos$i.txt --max_kb_dist 1000 --min_maf $MINMAF --rnd_sample 0.05 > $1_$i.ld

	########################################################################
	# BIN DATA  														   #
	########################################################################

	#Breaks the data into bins of pairs that are 50*n pairs apart for easier visualization
	Rscript ../../Code/Bin_ReadData.R $1_$i.ld

	########################################################################
	# MODEL FITTING                                                        #
	########################################################################

	#Fits 5 model curves (an exponential, gamma, linear, and 2 polynomial) to the data. Returns a file of the fit parameters as well as a file of AIC values for comparison.
	python ../../Code/Fit_Models.py $1_$i.Bin.csv	

done


########################################################################
# PLOT CURVES                                                          #
########################################################################
Rscript ../../Code/Plot_5ReadDataSets.R FitParams.csv $1_50.Bin.csv


########################################################################
# RETURN INPUT PARAMETERS                                              #
########################################################################

#Creates a file that shows the input parameters for the scenario
echo "SUMMARY OF PARAMETERS:" > $1_INPUT.txt
	echo >> $1_INPUT.txt
	echo "Number of Chromosomes="$N_SAM >> $1_INPUT.txt
	echo "Number of Repetitions="$N_REPS >> $1_INPUT.txt
	echo "Number of Individuals="$N_IND  >> $1_INPUT.txt
	echo "THETA="$THETA "RHO="$RHO >> $1_INPUT.txt 
	echo "Number of Sites="$N_SITES >> $1_INPUT.txt
	echo "Error Rate="$ERR_RATE  >> $1_INPUT.txt
	echo "Number of Result Sites="$NS >> $1_INPUT.txt
if [ $# = 7 ]
then
	echo "Simulation Events="$SIMULATION_EVENTS >> $1_INPUT.txt
fi

########################################################################
# BACK TO CODE FOLDER                                                  #
########################################################################

#Returns to code folder to begin next set
cd ../../Code
