#!/bin/bash
#PBS -l walltime=04:30:00
#PBS -lselect=1:ncpus=1:mem=25gb 

module load intel-suite

if [ $PBS_ARRAY_INDEX = 1 ]; then
IN_PATH="$WORK/Turkey"
IN_FILE="Turkey.ld"
elif [ $PBS_ARRAY_INDEX = 2 ]; then
IN_FILE="$WORK/Duck"
IN_PATH="Duck.ld"
fi

echo "SCRIPT BEGAN RUNNING AT..." 
date

OLD_LEN=`cat $IN_PATH/$IN_FILE | wc -l`
awk '(NR>0) && ($7 != "NaN")' $IN_PATH/$IN_FILE > $IN_FILE.fltr

rm $IN_PATH/$IN_FILE 
mv $IN_FILE.fltr $IN_PATH
NEW_LEN=`cat $IN_PATH/$IN_FILE.fltr | wc -l`

echo "Original Length:" OLD_LEN
echo "New Length:" NEW_LEN

DIFF_LEN=$((OLD_LEN-NEW_LEN))
echo "Difference:" DIFF_LEN
