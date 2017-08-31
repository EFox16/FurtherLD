#!/bin/bash
#PBS -l walltime=8:30:00
#PBS -lselect=1:ncpus=1:mem=99gb 

module load intel-suite
module load anaconda

LEN1=`zcat /work/eaf16/Constant/Constant_Call5.ld.gz | wc -l`
awk '(NR>0) && $4==($4+0)' <(gzip -dc /work/eaf16/Constant/Constant_Call5.ld.gz) | gzip > /work/eaf16/Constant/Constant_Call5.fltrd.ld.gz
LEN2B=`zcat /work/eaf16/Constant/Constant_Call5.fltrd.ld.gz | wc -l`
DIFF_LENB=$((LEN1-LEN2B))
echo "Number of rows removed:" $DIFF_LENB
echo "New length:" $LEN2B

echo /work/eaf16/Constant/Constant_Call5.fltrd.ld.gz > InList_4


echo "SCRIPT BEGAN RUNNING AT..."
date

python $WORK/Fit_Exp.py --input_list InList_4 --data_type r2Pear --output_prefix $WORK/Constant/Result_4

echo "SCRIPT RUN TO COMPLETION"
