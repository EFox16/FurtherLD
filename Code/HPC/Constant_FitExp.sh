#!/bin/bash
#PBS -l walltime=47:30:00
#PBS -lselect=1:ncpus=1:mem=99gb 

module load intel-suite
module load anaconda

if [ $PBS_ARRAY_INDEX = 1 ]; then
echo /work/eaf16/Constant/Constant_Call50.ld.gz > InList_${PBS_ARRAY_INDEX}
elif [ $PBS_ARRAY_INDEX = 2 ]; then
echo /work/eaf16//Constant/Constant_Call20.ld.gz > InList_${PBS_ARRAY_INDEX}
elif [ $PBS_ARRAY_INDEX = 3 ]; then
echo /work/eaf16/Constant/Constant_Call10.ld.gz > InList_${PBS_ARRAY_INDEX}
elif [ $PBS_ARRAY_INDEX = 4 ]; then
echo /work/eaf16/Constant/Constant_Call5.ld.gz > InList_${PBS_ARRAY_INDEX}
elif [ $PBS_ARRAY_INDEX = 5 ]; then
echo /work/eaf16/Constant/Constant_Call2.ld.gz > InList_${PBS_ARRAY_INDEX}
elif [ $PBS_ARRAY_INDEX = 6 ]; then
echo /work/eaf16/Constant/Constant_Reads50.ld.gz > InList_${PBS_ARRAY_INDEX}
elif [ $PBS_ARRAY_INDEX = 7 ]; then
echo /work/eaf16/Constant/Constant_Reads20.ld.gz > InList_${PBS_ARRAY_INDEX}
elif [ $PBS_ARRAY_INDEX = 8 ]; then
echo /work/eaf16/Constant/Constant_Reads10.ld.gz > InList_${PBS_ARRAY_INDEX}
elif [ $PBS_ARRAY_INDEX = 9 ]; then
echo /work/eaf16/Constant/Constant_Reads5.ld.gz > InList_${PBS_ARRAY_INDEX}
elif [ $PBS_ARRAY_INDEX = 10 ]; then
echo /work/eaf16/Constant/Constant_Reads2.ld.gz > InList_${PBS_ARRAY_INDEX}
fi


echo "SCRIPT BEGAN RUNNING AT..."
date

python $WORK/Fit_Exp.py --input_list InList_${PBS_ARRAY_INDEX} --data_type r2Pear --output_prefix $WORK/Constant/Result_${PBS_ARRAY_INDEX}

echo "SCRIPT RUN TO COMPLETION"
