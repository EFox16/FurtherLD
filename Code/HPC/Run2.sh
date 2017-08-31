#!/bin/bash
#PBS -l walltime=04:00:00
#PBS -lselect=1:ncpus=1:mem=70gb

module load intel-suite

echo "Indexing begun at..."
date

INDEX_FILE=$WORK/Constant/Idx.2

echo "Number of starting sites is"
cat $INDEX_FILE | wc -l
awk 'NR==FNR{a[$1,$2]=$4;next} ($1,$2) in a{print $1,$2,$3,$4,a[$1,$2]}' $WORK/Constant/Idx.1 $INDEX_FILE > Step1.$PBS_ARRAY_INDEX

echo "Number of sites after combined is"
cat Step1.$PBS_ARRAY_INDEX | wc -l

awk 'NR>0{printf("%s %6.6f\n", $0, ($4-$5)/5)}' Step1.$PBS_ARRAY_INDEX > Step2.$PBS_ARRAY_INDEX

echo "Number of sites after SB start"
cat Step2.$PBS_ARRAY_INDEX | wc -l

awk 'NR>0{printf("%s %7.6f\n", $0, ($5-$4)^2)}' Step2.$PBS_ARRAY_INDEX > Step3.$PBS_ARRAY_INDEX 

echo "Number of sites after RMSD start"
cat Step2.$PBS_ARRAY_INDEX | wc -l
LEN4=`cat Step3.$PBS_ARRAY_INDEX  | wc -l`


SUM_SB=$(awk '{s+=$6}END{print s}' Step3.$PBS_ARRAY_INDEX )
SB=$(echo "scale=6;$SUM_SB/$LEN4" | bc)
SUM_RMSD=$(awk '{s+=$7}END{print s}' Step3.$PBS_ARRAY_INDEX )
RMSD=$(echo "scale=6;sqrt($SUM_RMSD/$LEN4)" | bc)

echo "SB is" $SB
echo "Sum_SB" $SUM_SB
echo "Sum_RMSD" $SUM_RMSD
echo "RMSD is" $RMSD

echo "Script run to completion"

