#!/bin/bash
#PBS -l walltime=23:30:00
#PBS -lselect=1:ncpus=1:mem=64gb 

module load intel-suite
module load gsl
module load htslib
module load python

echo "FILTERING BEGUN AT..."
date

python $WORK/1.filter_length.py $WORK/Duck/Ap_Ref.fa

echo "FILTERING RUN TO COMPLETION"
