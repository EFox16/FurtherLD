#!/bin/bash
#PBS -l walltime=20:30:00
#PBS -lselect=1:ncpus=1:mem=99gb 

module load intel-suite
module load gsl
module load htslib
module load anaconda

if [ $PBS_ARRAY_INDEX = 1 ]; then
GEN_FILE=$WORK/Turkey/Turkey
LD_FILE=Turkey_200
N_IND=14
MINMAF=0.071
PREFIX=$WORK/Turkey/Turkey_GLS200
elif [ $PBS_ARRAY_INDEX = 2 ]; then
GEN_FILE=$WORK/Duck/Duck
LD_FILE=Duck_200
N_IND=20
MINMAF=0.05
PREFIX=$WORK/Duck/Duck_GLS200
fi

#Unzip geno file and run ngsLD
echo "ngsLD BEGAN RUNNING AT"
date
NS=`cat ${GEN_FILE}_pos.txt | wc -l`
$HOME/Packages/ngsLD/ngsLD --geno ${GEN_FILE}.geno --out ${LD_FILE}.ld --pos ${GEN_FILE}_pos.txt --n_ind $N_IND --n_sites $NS --verbose 1 --probs --max_kb_dist 200 --min_maf $MINMAF


echo "Removing NaN"
LEN1=`cat ${LD_FILE}.ld | wc -l`
echo "Original Length:" $LEN1
awk '(NR>0) && $7==($7+0)' ${LD_FILE}.ld > ${LD_FILE}_fltrd.ld 
LEN2B=`cat ${LD_FILE}_fltrd.ld | wc -l`
DIFF_LENB=$((LEN1-LEN2B))
echo "Number of rows removed:" $DIFF_LENB
echo "New length:" $LEN2B

echo "Fit_Exp BEGAN RUNNING AT"
date
FILENAME=${LD_FILE}_fltrd.ld
echo $FILENAME > InList_${PBS_ARRAY_INDEX}_200
python $WORK/Fit_Exp.py --input_list InList_${PBS_ARRAY_INDEX}_200  --data_type r2GLS --output_prefix $PREFIX

echo "SCRIPT RUN TO COMPLETION"
