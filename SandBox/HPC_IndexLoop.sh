#!/bin/bash
#PBS -l walltime=01:30:00
#PBS -l mem=100gb
#PBS -l ncpus=1

module load intel-suite

echo "Indexing begun at..."
date


FILE1=$WORK/Constant_Call50.ld
FILE2=$WORK/Constant_Reads5.ld
FILE3=$WORK/Constant_Call5.ld
FILE4=$WORK/Constant_Reads10.ld
FILE5=$WORK/Constant_Call10.ld
FILE6=$WORK/Constant_Reads20.ld
FILE7=$WORK/Constant_Call20.ld
FILE8=$WORK/Constant_Reads50.ld

awk 'NR==FNR{a[$1,$2]=$4;next} ($1,$2) in a{print $1,$2,$3,a[$1,$2],$4}' $FILE1 $FILE2 > FullIndex.ld


for file in $FILE3 $FILE4 $FILE5 $FILE6 $FILE7 $FILE8
do
awk 'NR==FNR{a[$1,$2]=$0;next} ($1,$2) in a{print a[$1,$2],$4}' FullIndex.ld $file > FullIndex.ld    
done

echo "Full indexing complete"
