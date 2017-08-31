#!/bin/bash
#PBS -l walltime=04:00:00
#PBS -lselect=1:ncpus=1:mem=70gb

module load intel-suite
module load anaconda

if [ $PBS_ARRAY_INDEX = 1 ]; then
INDEX_FILE=$WORK/Constant/Idx.1
elif [ $PBS_ARRAY_INDEX = 2 ]; then
INDEX_FILE=$WORK/Constant/Idx.2
elif [ $PBS_ARRAY_INDEX = 3 ]; then
INDEX_FILE=$WORK/Constant/Idx.3
elif [ $PBS_ARRAY_INDEX = 4 ]; then
INDEX_FILE=$WORK/Constant/Idx.4
elif [ $PBS_ARRAY_INDEX = 5 ]; then
INDEX_FILE=$WORK/Constant/Idx.5
elif [ $PBS_ARRAY_INDEX = 6 ]; then
INDEX_FILE=$WORK/Constant/Idx.6
elif [ $PBS_ARRAY_INDEX = 7 ]; then
INDEX_FILE=$WORK/Constant/Idx.7
elif [ $PBS_ARRAY_INDEX = 8 ]; then
INDEX_FILE=$WORK/Constant/Idx.8
elif [ $PBS_ARRAY_INDEX = 9 ]; then
INDEX_FILE=$WORK/Constant/Idx.9
elif [ $PBS_ARRAY_INDEX = 10 ]; then
INDEX_FILE=$WORK/Constant/Idx.10
fi

awk '{print $1,$2,$3,$4,$4,$4,$4}' $INDEX_FILE > FitFile.$PBS_ARRAY_INDEX

echo FitFile.$PBS_ARRAY_INDEX > InList_${PBS_ARRAY_INDEX}

echo "SCRIPT BEGAN RUNNING AT..."
date

python $WORK/Fit_Exp.py --input_list InList_${PBS_ARRAY_INDEX} --data_type r2GLS --output_prefix $WORK/Constant/Result_Try2_${PBS_ARRAY_INDEX}

echo "SCRIPT RUN TO COMPLETION"
