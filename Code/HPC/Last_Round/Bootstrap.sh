#!/bin/bash
#PBS -l walltime=20:30:00
#PBS -lselect=1:ncpus=1:mem=99gb 

module load intel-suite
module load gsl
module load htslib
module load anaconda

echo "SCRIPT BEGAN RUNNING AT..."
date

python $WORK/Bootstrap.py $WORK/Turkey/Turkey.ld_fltrd Turkey_${PBS_ARRAY_INDEX}
echo "Data for bootstrap generated"
date


for i in {1..10}
do
	LOOP_NUM=$i
	echo "Loop number is..." $LOOP_NUM
	
	echo Turkey_${PBS_ARRAY_INDEX}_${LOOP_NUM}.ld > InList.${PBS_ARRAY_INDEX}_${LOOP_NUM}
	
	python $WORK/Fit_Exp.py --input_list InList.${PBS_ARRAY_INDEX}_${LOOP_NUM} --data_type r2GLS --output_prefix Turkey_${PBS_ARRAY_INDEX}_${LOOP_NUM}
	echo "Fit_Exp run on new data"
	date
	
	mv Turkey_${PBS_ARRAY_INDEX}_${LOOP_NUM}.csv $WORK/Bootstrap/Turkey/GLS

	rm Turkey_${PBS_ARRAY_INDEX}_${LOOP_NUM}.ld
	echo "Loop run to COMPLETION"
	date
done

echo "SCRIPT RUN TO COMPLETION"
