#!/bin/bash
#PBS -l walltime=04:00:00
#PBS -l mem=25gb
#PBS -l ncpus=1

module load intel-suite

echo "Indexing begun at..."
date


FILE1=$WORK/Constant_Call50pv2.ld
FILE2=$WORK/Constant_Reads50pv2.ld
FILE3=$WORK/Constant_Call20pv2.ld
FILE4=$WORK/Constant_Reads20pv2.ld
FILE5=$WORK/Constant_Call10pv2.ld
FILE6=$WORK/Constant_Reads10pv2.ld
FILE7=$WORK/Constant_Call5pv2.ld
FILE8=$WORK/Constant_Reads5pv2.ld

LEN1=`cat $FILE1 | wc -l`
echo "Removing rows with r^2 value of 0"
awk '(NR>0) && ($4 > 0)' $FILE1 > FullIndex.$PBS_ARRAY_INDEX.0
LEN2=`cat FullIndex.$PBS_ARRAY_INDEX.0 | wc -l`
DIFF_LEN=$((LEN1-LEN2))
echo "Number of rows removed:" $DIFF_LEN
echo "New length:" $LEN2

PREV_STEP=0
STEP=1
for file in $FILE2 $FILE3 $FILE4 $FILE5 $FILE6 $FILE7 $FILE8 
do
echo "Cross referencing with" $file
awk 'NR==FNR{a[$1,$2]=$4;next} ($1,$2) in a{print $1,$2,$3,a[$1,$2]}' FullIndex.$PBS_ARRAY_INDEX.$PREV_STEP $file > FullIndex.$PBS_ARRAY_INDEX.$STEP    
TEMP_LEN=`cat FullIndex.$PBS_ARRAY_INDEX.$STEP | wc -l`
rm FullIndex.$PBS_ARRAY_INDEX.$PREV_STEP
echo "New length:" $TEMP_LEN
PREV_STEP=$((PREV_STEP+1))
STEP=$((STEP+1))
done

echo "Reference file created"
LEN3=`cat FullIndex.$PBS_ARRAY_INDEX.$PREV_STEP | wc -l`
echo "Final number of sites:" $LEN3

if [ $PBS_ARRAY_INDEX = 1 ]; then
INDEX_FILE=$FILE1
elif [ $PBS_ARRAY_INDEX = 2 ]; then
INDEX_FILE=$FILE2
elif [ $PBS_ARRAY_INDEX = 3 ]; then
INDEX_FILE=$FILE3
elif [ $PBS_ARRAY_INDEX = 4 ]; then
INDEX_FILE=$FILE4
elif [ $PBS_ARRAY_INDEX = 5 ]; then
INDEX_FILE=$FILE5
elif [ $PBS_ARRAY_INDEX = 6 ]; then
INDEX_FILE=$FILE6
elif [ $PBS_ARRAY_INDEX = 7 ]; then
INDEX_FILE=$FILE7
elif [ $PBS_ARRAY_INDEX = 8 ]; then
INDEX_FILE=$FILE8
fi

echo "Indexing data file: " $INDEX_FILE
awk 'NR==FNR{a[$1,$2]=$4;next} ($1,$2) in a{print $1,$2,$3,a[$1,$2],$4}' FullIndex.$PBS_ARRAY_INDEX.$PREV_STEP $INDEX_FILE > Idx.$PBS_ARRAY_INDEX
LEN3=`cat Idx.$PBS_ARRAY_INDEX | wc -l`
echo "Length of new data file" $LEN3

echo "Adding column for standard bias calculation"
awk 'NR>0{printf("%s %6.6f\n", $0, ($5-$4)/$4)}' Idx.$PBS_ARRAY_INDEX > Calc1.$PBS_ARRAY_INDEX
rm Idx.$PBS_ARRAY_INDEX

echo "Adding column for root mean square deviation calculation"
awk 'NR>0{printf("%s %7.6f\n", $0, ($5-$4)^2)}' Calc1.$PBS_ARRAY_INDEX > $INDEX_FILE.idx
LEN4=`cat $INDEX_FILE.idx | wc -l`
echo "Length of final file:" $LEN4
rm Calc1.$PBS_ARRAY_INDEX

echo "Full processing completed"

SB=$(awk '{s+=$6}END{print s}' $INDEX_FILE.idx)
SUM_RMSD=$(awk '{s+=$7}END{print s}' $INDEX_FILE.idx)
RMSD=$(echo "scale=6;sqrt($SUM_RMSD/$LEN4)" | bc)

echo "Standard Bias:" $SB
echo "Root Mean Square Deviation" $RMSD
