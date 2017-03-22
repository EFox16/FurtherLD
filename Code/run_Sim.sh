#!/bin/bash
# Author: Emma Fox e.fox16@imperial.ac.uk
# Script: Run_Full.sh
# Desc: Pipeline using ms to simulate, ANGSD to transform the files, and ngsLD to analyze with command line argument inputs to simulate a set of genomes for the scenario. The data is then binned using R, models are fitted to its distribution using python, and the resulting equations and parameters are plotted to the data using R. 
# Arguments: set name, number of samples, number of repetitions, theta, number of sites, sequencing depth, error rate, AND exponential growth rate OR bottleneck time and magnitude 

########################################################################
# SET PATH TO PACKAGES                                                 #
########################################################################
SAM=samtools
MS=/usr/bin/ms
TOGLF=/usr/bin/msToGlf
ANGSD=/usr/bin/angsd
NGSLD=/usr/bin/ngsLD


########################################################################
# CREATE RESULTS FOLDER with reference sequence                        #
########################################################################

#This process generates quite a few output files so this step creates a folder for those files. Moving the working directory to this new folder simplifies the processing of the various files. 
mkdir $1
cd $1

#Need to create a fast file with a reference sequence. Used to establish relative position of bases by a program in a later step. 
Rscript -e 'cat(">reference\n",paste(rep("A",1e7),sep="", collapse=""),"\n",sep="")' > reference.fa 

#Further formats the reference file
$SAM faidx reference.fa #should give reference.fa.fai

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
MINMAF=$(echo "scale=3; 2/$N_SAM" | bc)

########################################################################
# RUN MS                                                               #
########################################################################

#If there are only 6 values input, run ms with the assigned variables to generate data about the location and haplotype of variable sites in hypothetical genomes
#If there are 7 values, the 8th describes some demographic event in the history of the population

if [ $# = 6 ]
then
	$MS $N_SAM $N_REPS -t $THETA -r $RHO $N_SITES > $1.txt
elif [ $# = 7 ]
then
	SIMULATION_EVENTS=$8
	$MS $N_SAM $N_REPS -t $THETA -r $RHO $N_SITES $SIMULATION_EVENTS > $1.txt
fi

for i in 50 20 10 5 #2
do
	########################################################################
	# CONVERT WITH ANGSD                                                   #
	########################################################################

	#ANGSD converts ms output to glf file type which can be read by later programs
	$TOGLF -in $1.txt -out $1_reads$i -regLen $N_SITES -singleOut 1 -depth $i -err $ERR_RATE -pileup 0 -Nsites 0

	#~ #This step generates a file that includes the full genome sequence rather than just the variable sites. Original reference file is used here. 
	#~ $ANGSD -glf $1_reads$i.glf.gz -fai reference.fa.fai -nInd $N_IND -doMajorMinor 1 -doPost 1 -doMaf 1 -doGeno 32 -out $1_reads$i -isSim 1 -minMaf $MINMAF

	#~ #Unzip output files
	#~ gunzip -f $1_reads$i.geno.gz

	#~ ########################################################################
	#~ # RUN ngsLD                                                            #
	#~ ########################################################################

	#~ #Create position file that is the length of the file just created 
	#~ zcat $1_reads$i.mafs.gz | cut -f 1,2 | tail -n +2 > $1_pos$i.txt
	#~ NS=`cat $1_pos$i.txt | wc -l` 

	#~ #Run ngsLD. This will output a file with each row representing two SNPs. The file includes the position of each, the distace between the sites, and several  measures of the strength of the linkage between them 
	#~ $NGSLD --verbose 1 --n_ind $N_IND --n_sites $NS --geno $1_reads$i.geno --probs --pos $1_pos$i.txt --max_kb_dist 1000 | gzip > $1_Reads$i.ld.gz
	
	#~ #Run ngsLD with called genotypes
	#~ $NGSLD --verbose 1 --n_ind $N_IND --n_sites $NS --geno $1_reads$i.geno --probs --pos $1_pos$i.txt --max_kb_dist 1000 --call_geno | gzip > $1_Call$i.ld.gz

	####################################################################
	# DATA SETS FOR P VALUE FILTERING                                  #
	####################################################################
	for PVAL in 0.01 0.001
	do
		if [ $PVAL = 0.01 ]
		then
			P=pv1
		elif [ $PVAL = 0.001 ]
		then
			P=pv2
		fi
		#This step generates a file that includes the full genome sequence rather than just the variable sites. Original reference file is used here. 
		$ANGSD -glf $1_reads$i.glf.gz -fai reference.fa.fai -nInd $N_IND -doMajorMinor 1 -doPost 1 -doMaf 1 -doGeno 32 -out $1_reads$i$P -isSim 1 -SNP_pval $PVAL

		#Unzip output files
		gunzip -f $1_reads$i$P.geno.gz
		
		#Create position file that is the length of the file just created 
		zcat $1_reads$i$P.mafs.gz | cut -f 1,2 | tail -n +2 > $1_pos$i$P.txt
		NS=`cat $1_pos$i$P.txt | wc -l` 

		#Run ngsLD. This will output a file with each row representing two SNPs. The file includes the position of each, the distace between the sites, and several  measures of the strength of the linkage between them 
		$NGSLD --verbose 1 --n_ind $N_IND --n_sites $NS --geno $1_reads$i$P.geno --probs --pos $1_pos$i$P.txt --max_kb_dist 1000 | gzip > $1_Reads$i$P.ld.gz

		#Run ngsLD with called genotypes
		$NGSLD --verbose 1 --n_ind $N_IND --n_sites $NS --geno $1_reads$i$P.geno --probs --pos $1_pos$i$P.txt --max_kb_dist 1000 --call_geno | gzip > $1_Call$i$P.ld.gz

	done
done


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
	echo "Error Rate="$ERR_RATE  >> $1_INPUT.txt
	echo "Number of Result Sites="$NS >> $1_INPUT.txt
if [ $# = 6 ]
then
	echo "Command=" $1 $2 $3 $4 $5 $6 >> $1_INPUT.txt
elif [ $# = 7 ]
then
	echo "Simulation Events="$SIMULATION_EVENTS >> $1_INPUT.txt
	echo "Command=" $1 $2 $3 $4 $5 $6 $7 >> $1_INPUT.txt
fi

#~ ########################################################################
#~ # BACK TO CODE FOLDER                                                  #
#~ ########################################################################

#~ #Returns to code folder to begin next set
#~ cd ../../Code
