#!/bin/bash
#PBS -l walltime=00:30:00
#PBS -l mem=150mb
#PBS -l ncpus=1

module load intel-suite

echo "Indexing begun at..."
date


FILE1=$WORK/Base.ld
FILE2=$WORK/One.ld
FILE3=$WORK/Two.ld


LEN1=`cat $FILE1 | wc -l`
echo "Removing rows with r^2 value of 0"
awk '(NR>0) && ($4 > 0)' $FILE1 > $FILE1.trim$PBS_ARRAY_INDEX
LEN2=`cat $FILE1.trim$PBS_ARRAY_INDEX | wc -l`
DIFF_LEN=$((LEN1-LEN2))
echo "Number of rows removed:" $DIFF_LEN


echo "Creating reference file"
for file in $FILE2 $FILE3 
do
echo "Cross referencing with" $file
awk 'NR==FNR{a[$1,$2]=$4;next} ($1,$2) in a{print $1,$2,$3,a[$1,$2]}' FullIndex.$PBS_ARRAY_INDEX.ld $file > FullIndex.$PBS_ARRAY_INDEX.ld    
done

echo "Reference file created"
LEN3=`cat FullIndex.$PBS_ARRAY_INDEX.ld | wc -l`
echo "Number of sites" $LEN3

if [ $PBS_ARRAY_INDEX = 1 ]; then
INDEX_FILE=$FILE1
elif [ $PBS_ARRAY_INDEX = 2 ]; then
INDEX_FILE=$FILE2
elif [ $PBS_ARRAY_INDEX = 3 ]; then
INDEX_FILE=$FILE3
fi

echo "Indexing data file: " $INDEX_FILE
awk 'NR==FNR{a[$1,$2]=$4;next} ($1,$2) in a{print $1,$2,$3,a[$1,$2],$4}' FullIndex.$PBS_ARRAY_INDEX.ld $INDEX_FILE > $INDEX_FILE.idx
LEN3=`zcat $INDEX_FILE.idx | wc -l`
echo "Length of new data file" $LEN3

echo "Adding column for standard bias calculation"
awk 'NR>0{printf("%s %6.6f\n", $0, ($5-$4)/$4)}' $INDEX_FILE.idx > $INDEX_FILE.idx

echo "Adding column for root mean square deviation calculation"
awk 'NR>0{printf("%s %7.6f\n", $0, ($5-$4)^2)}' $INDEX_FILE.idx > $INDEX_FILE.idx

echo "Full processing completed"
