#!/bin/bash
#PBS -l walltime=47:30:00
#PBS -lselect=1:ncpus=1:mem=250gb 

module load intel-suite
module load gsl
module load htslib
module load anaconda

echo "SCRIPT BEGAN RUNNING AT..."
date

python $WORK/Bootstrap.py $WORK/Turkey/Turkey.ld "Turkey_${PBS_ARRAY_INDEX}"
echo "Data for bootstrap generated"
date


for i in {1..10}
do
	LOOP_NUM=$i
	echo "Loop number is..." $LOOP_NUM
	
	python $WORK/Fit_Exp.py --input_type FILE --input_name Turkey_${PBS_ARRAY_INDEX}_${LOOP_NUM}.ld --data_type r2Pear
	echo "Fit_Exp run on new data"
	date
	
	mv Turkey_${PBS_ARRAY_INDEX}*.csv $WORK/Bootstrap/Turkey/

	rm Turkey_${PBS_ARRAY_INDEX}_${LOOP_NUM}.ld
	echo "Loop run to COMPLETION"
	date
done

echo "SCRIPT RUN TO COMPLETION"
