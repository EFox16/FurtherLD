#!/bin/bash
#PBS -l walltime=20:30:00
#PBS -lselect=1:ncpus=1:mem=99gb 

module load intel-suite
module load anaconda

if [ $PBS_ARRAY_INDEX = 1 ]; then
echo $WORK/Turkey/Turkey.ld_fltrd > InList_${PBS_ARRAY_INDEX}
PREFIX=Turkey/Turkey_GLS
elif [ $PBS_ARRAY_INDEX = 2 ]; then
echo $WORK/Duck/Duck.ld_fltrd > InList_${PBS_ARRAY_INDEX}
PREFIX=Duck/Duck_GLS
fi

echo "SCRIPT BEGAN RUNNING AT..."
date

echo "Fit_Exp BEGAN RUNNING AT"
date
python $WORK/Fit_Exp.py --input_list InList_${PBS_ARRAY_INDEX}  --data_type r2GLS --output_prefix $WORK/$PREFIX

echo "SCRIPT RUN TO COMPLETION"
