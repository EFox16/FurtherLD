#!/bin/bash
#PBS -l walltime=16:30:00
#PBS -lselect=1:ncpus=1:mem=75gb 

module load intel-suite
module load gsl
module load htslib
module load anaconda

REF=$WORK/Guppy/Pr_Ref.fa

if [ $PBS_ARRAY_INDEX = 1 ]; then
BASE_FILE=/work/eaf16/Constant/Constant_Call50.ld.gz
NEW_FILE=/work/eaf16/Constant/Constant_Call50_fltrd.ld.gz
echo $NEW_FILE > InList_${PBS_ARRAY_INDEX}
PREFIX=/work/eaf16/Constant/Constant_Call50_GLS
elif [ $PBS_ARRAY_INDEX = 2 ]; then
BASE_FILE=/work/eaf16//Constant/Constant_Call20.ld.gz 
NEW_FILE=/work/eaf16/Constant/Constant_Call20_fltrd.ld.gz
echo $NEW_FILE > InList_${PBS_ARRAY_INDEX}
PREFIX=/work/eaf16/Constant/Constant_Call20_GLS
elif [ $PBS_ARRAY_INDEX = 3 ]; then
BASE_FILE=/work/eaf16/Constant/Constant_Call10.ld.gz 
NEW_FILE=/work/eaf16/Constant/Constant_Call10_fltrd.ld.gz
echo $NEW_FILE > InList_${PBS_ARRAY_INDEX}
PREFIX=/work/eaf16/Constant/Constant_Call10_GLS
elif [ $PBS_ARRAY_INDEX = 4 ]; then
BASE_FILE=/work/eaf16/Constant/Constant_Call5.ld.gz 
NEW_FILE=/work/eaf16/Constant/Constant_Call5_fltrd.ld.gz
echo $NEW_FILE > InList_${PBS_ARRAY_INDEX}
PREFIX=/work/eaf16/Constant/Constant_Call5_GLS
elif [ $PBS_ARRAY_INDEX = 5 ]; then
BASE_FILE=/work/eaf16/Constant/Constant_Call2.ld.gz 
NEW_FILE=/work/eaf16/Constant/Constant_Call2_fltrd.ld.gz
echo $NEW_FILE > InList_${PBS_ARRAY_INDEX}
PREFIX=/work/eaf16/Constant/Constant_Call2_GLS
elif [ $PBS_ARRAY_INDEX = 6 ]; then
BASE_FILE=/work/eaf16/Constant/Constant_Reads50.ld.gz 
NEW_FILE=/work/eaf16/Constant/Constant_Reads50_fltrd.ld.gz
echo $NEW_FILE > InList_${PBS_ARRAY_INDEX}
PREFIX=/work/eaf16/Constant/Constant_Reads50_GLS
elif [ $PBS_ARRAY_INDEX = 7 ]; then
BASE_FILE=/work/eaf16/Constant/Constant_Reads20.ld.gz 
NEW_FILE=/work/eaf16/Constant/Constant_Reads20_fltrd.ld.gz
echo $NEW_FILE > InList_${PBS_ARRAY_INDEX}
PREFIX=/work/eaf16/Constant/Constant_Reads20_GLS
elif [ $PBS_ARRAY_INDEX = 8 ]; then
BASE_FILE=/work/eaf16/Constant/Constant_Reads10.ld.gz 
NEW_FILE=/work/eaf16/Constant/Constant_Reads10_fltrd.ld.gz
echo $NEW_FILE > InList_${PBS_ARRAY_INDEX}
PREFIX=/work/eaf16/Constant/Constant_Reads10_GLS
elif [ $PBS_ARRAY_INDEX = 9 ]; then
BASE_FILE=/work/eaf16/Constant/Constant_Reads5.ld.gz 
NEW_FILE=/work/eaf16/Constant/Constant_Reads5_fltrd.ld.gz
echo $NEW_FILE > InList_${PBS_ARRAY_INDEX}
PREFIX=/work/eaf16/Constant/Constant_Reads5_GLS
elif [ $PBS_ARRAY_INDEX = 10 ]; then
BASE_FILE=/work/eaf16/Constant/Constant_Reads2.ld.gz 
NEW_FILE=/work/eaf16/Constant/Constant_Reads2_fltrd.ld.gz
echo $NEW_FILE > InList_${PBS_ARRAY_INDEX}
PREFIX=/work/eaf16/Constant/Constant_Reads2_GLS
fi


echo "Removing NaN"
LEN1=`zcat $BASE_FILE | wc -l`
echo "Original Length:" $LEN1
awk '(NR>0) && $7==($7+0)' <(gzip -dc $BASE_FILE) | gzip > $NEW_FILE
LEN2B=`zcat $NEW_FILE.gz | wc -l`
DIFF_LENB=$((LEN1-LEN2B))
echo "Number of rows removed:" $DIFF_LENB
echo "New length:" $LEN2B

echo "Running fitting using GLS"
date
python $WORK/Fit_Exp.py --input_list InList_${PBS_ARRAY_INDEX}  --data_type r2GLS --output_prefix $PREFIX

echo "SCRIPT RUN TO COMPLETION"


