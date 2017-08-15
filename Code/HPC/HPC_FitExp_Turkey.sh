#!/bin/bash
#PBS -l walltime=47:30:00
#PBS -lselect=1:ncpus=1:mem=99gb 

module load intel-suite
module load anaconda

echo "SCRIPT BEGAN RUNNING AT..."
date

python $WORK/Fit_Exp.py --input_type FILE --input_name $WORK/Turkey/Turkey.ld --data_type r2Pear

mv Turkey*.csv $WORK/Turkey

echo "SCRIPT RUN TO COMPLETION"
