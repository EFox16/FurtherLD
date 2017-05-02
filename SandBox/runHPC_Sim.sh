#!/bin/bash
#PBS -l walltime=12:00:00,mem=200gb,ncpus=1

# SETTING VARIABLES                                                    
#Assigning PBS_ARRAY_INDEX to a set
if [ $PBS_ARRAY_INDEX = 1 ] || [ $PBS_ARRAY_INDEX = 2 ]; then
	READ_NUM=50
elif [ $PBS_ARRAY_INDEX = 3 ] || [ $PBS_ARRAY_INDEX = 4 ]; then
	READ_NUM=20
elif [ $PBS_ARRAY_INDEX = 5 ] || [ $PBS_ARRAY_INDEX = 6 ]; then
	READ_NUM=10
elif [ $PBS_ARRAY_INDEX = 7 ] || [ $PBS_ARRAY_INDEX = 8 ]; then
	READ_NUM=5
elif [ $PBS_ARRAY_INDEX = 9 ] || [ $PBS_ARRAY_INDEX = 10 ]; then
	READ_NUM=2
fi

echo "PBS Array Index: $PBS_ARRAY_INDEX"
echo "Number of Reads: $READ_NUM"
#Takes each term in the input and assigns it to a variable name
NAME=Cnstnt
N_SAM=100 
N_REPS=1 
THETA=6000 
RHO=$THETA
N_SITES=10000000 
ERR_RATE=0.01

#Calculated variables
N_IND=50
MINMAF=0.02

echo "Data Type: Genotype Likelihoods"
echo "Running msToGlf"
${HOME}/gitPackages/angsd/misc/msToGlf -in $NAME.txt -out $NAME.reads$READ_NUM -regLen $N_SITES -singleOut 1 -depth $READ_NUM -err $ERR_RATE -pileup 0 -Nsites 0
${HOME}/gitPackages/angsd/angsd -glf $NAME.reads$READ_NUM.glf.gz -fai reference.fa.fai -nInd $N_IND -doMajorMinor 1 -doPost 1 -doMaf 1 -doGeno 32 -out $NAME.reads$READ_NUM -isSim 1 -minMaf $MINMAF
echo "Unzipping GLF file"
gunzip -f $NAME.reads$READ_NUM.geno.gz
zcat $NAME.reads$READ_NUM.mafs.gz | cut -f 1,2 | tail -n +2 > $NAME.pos$READ_NUM.txt
NS=`cat $NAME.pos$READ_NUM.txt | wc -l`


if [ $(( $PBS_ARRAY_INDEX % 2 )) -eq 0 ]
then	
	echo "Running ngsLD"
	${HOME}/gitPackages/ngsLD/ngsLD --verbose 1 --n_ind $N_IND --n_sites $NS --geno $NAME.reads$READ_NUM.geno --probs --pos $NAME.pos$READ_NUM.txt --max_kb_dist 10000 --min_maf $MINMAF | gzip > $NAME.GL$READ_NUM.ld.gz 
else
	echo "Running ngsLD"
	${HOME}/gitPackages/ngsLD/ngsLD --verbose 1 --n_ind $N_IND --n_sites $NS --geno $NAME.reads$READ_NUM.geno --probs --pos $NAME.pos$READ_NUM.txt --max_kb_dist 10000 --min_maf $MINMAF --call_geno | gzip > $NAME.CALL$READ_NUM.ld.gz
fi

echo "RUN COMPLETE"

mv $NAME.* $WORK
echo "Files have been moved to Work directory"
