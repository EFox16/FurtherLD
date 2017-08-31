#!/bin/bash
#PBS -l walltime=16:30:00
#PBS -lselect=1:ncpus=1:mem=75gb 

module load intel-suite
module load gsl
module load htslib
module load anaconda

REF=$WORK/Guppy/Pr_Ref.fa

if [ $PBS_ARRAY_INDEX = 1 ]; then
BASE_FILE=$WORK/Turkey/Turkey.ld
elif [ $PBS_ARRAY_INDEX = 2 ]; then
BASE_FILE=$WORK/Duck/Duck.ld
fi

echo "Removing NaN"
LEN1=`cat $BASE_FILE | wc -l`
echo "Original Length:" $LEN1
awk '(NR>0) && $7==($7+0)' $BASE_FILE > ${BASE_FILE}_fltrd
LEN2B=`cat ${BASE_FILE}_fltrd | wc -l`
DIFF_LENB=$((LEN1-LEN2B))
echo "Number of rows removed:" $DIFF_LENB
echo "New length:" $LEN2B

echo "SCRIPT RUN TO COMPLETION"


