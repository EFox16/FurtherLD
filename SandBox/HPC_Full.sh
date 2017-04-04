#!/bin/bash
#PBS -l walltime=03:00:00
#PBS -l mem=130gb
#PBS -l ncpus=1

module load intel-suite

echo "Indexing begun at..."
date


FILE1=$WORK/Constant_Call50.ld
FILE2=$WORK/Constant_Reads50.ld
FILE3=$WORK/Constant_Call20.ld
FILE4=$WORK/Constant_Reads20.ld
FILE5=$WORK/Constant_Call10.ld
FILE6=$WORK/Constant_Reads10.ld
FILE7=$WORK/Constant_Call5.ld
FILE8=$WORK/Constant_Reads5.ld

LEN1=`cat $FILE1 | wc -l`
echo "Removing rows with r^2 value of 0"
awk '(NR>0) && ($4 > 0)' $FILE1 > $FILE1
LEN2=`cat $FILE1 | wc -l`
DIFF_LEN=$((LEN1-LEN2))
echo "Number of rows removed:" $DIFF_LEN


echo "Creating reference file"
awk 'NR==FNR{a[$1,$2]=$4;next} ($1,$2) in a{print $1,$2,$3}' $FILE1 $FILE2 > FullIndex.ld

for file in $FILE3 $FILE4 $FILE5 $FILE6 $FILE7 $FILE8
do
echo "Cross referencing with" $file
awk 'NR==FNR{a[$1,$2]=$0;next} ($1,$2) in a{print a[$1,$2]}' FullIndex.ld $file > FullIndex.ld    
done

echo "Reference file created"
LEN3=`cat FullIndex.ld | wc -l`
echo "Number of sites" $LEN3

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
awk 'NR==FNR{a[$1,$2]=$4;next} ($1,$2) in a{print $1,$2,$3,a[$1,$2],$4}' FullIndex.ld $INDEX_FILE > $INDEX_FILE.idx
LEN3=`zcat $INDEX_FILE.idx | wc -l`
echo "Length of new data file" $LEN3

echo "Adding column for standard bias calculation"
awk 'NR>0{printf("%s %6.6f\n", $0, ($5-$4)/$4)}' $INDEX_FILE.idx > $INDEX_FILE.idx

echo "Adding column for root mean square deviation calculation"
awk 'NR>0{printf("%s %7.6f\n", $0, ($5-$4)^2)}' $INDEX_FILE.idx > $INDEX_FILE.idx

echo "Full processing completed"
