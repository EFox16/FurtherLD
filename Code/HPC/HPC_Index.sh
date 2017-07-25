#!/bin/bash
#PBS -l walltime=08:00:00
#PBS -lselect=1:ncpus=1:mem=70gb

module load intel-suite

echo "Indexing begun at..."
date


FILE1=Constant_Call50.ld.gz
FILE2=Constant_Reads50.ld.gz
FILE3=Constant_Call20.ld.gz
FILE4=Constant_Reads20.ld.gz
FILE5=Constant_Call10.ld.gz
FILE6=Constant_Reads10.ld.gz
FILE7=Constant_Call5.ld.gz
FILE8=Constant_Reads5.ld.gz
FILE9=Constant_Call2.ld.gz
FILE10=Constant_Reads2.ld.gz


LEN1=`zcat $FILE1 | wc -l`
echo "Removing rows with r^2 value of 0 then Na"
awk '(NR>0) && ($7 > 0)' <(gzip -dc $WORK/Constant/$FILE1) > FullIndex.$PBS_ARRAY_INDEX.0B
LEN2=`cat FullIndex.$PBS_ARRAY_INDEX.0B | wc -l`
DIFF_LEN=$((LEN1-LEN2))
echo "Number of rows removed:" $DIFF_LEN
echo "New length:" $LEN2

awk '(NR>0) && ($7 != "NA")' FullIndex.$PBS_ARRAY_INDEX.0B > FullIndex.$PBS_ARRAY_INDEX.0
LEN2B=`cat FullIndex.$PBS_ARRAY_INDEX.0 | wc -l`
DIFF_LENB=$((LEN2-LEN2B))
echo "Number of rows removed:" $DIFF_LENB
echo "New length:" $LEN2B

PREV_STEP=0
STEP=1
for file in $FILE2 $FILE3 $FILE4 $FILE5 $FILE6 $FILE7 $FILE8 $FILE9 $FILE10
do
echo "Removing NA Rows"
NaLEN1=`zcat $WORK/Constant/$file | wc -l`
awk '(NR>0) && ($7 != "NA")' <(gzip -dc $WORK/Constant/$file) > $file.$PBS_ARRAY_INDEX.fltrd
NaLEN2=`cat $file.$PBS_ARRAY_INDEX.fltrd | wc -l`
DIFF_LENa=$((NaLEN1-NaLEN2))
echo "Number of rows removed:" $DIFF_LENa
echo "New length:" $NaLEN2

echo "Cross referencing with" $file
awk 'NR==FNR{a[$1,$2]=$4;next} ($1,$2) in a{print $1,$2,$3,a[$1,$2]}' FullIndex.$PBS_ARRAY_INDEX.$PREV_STEP $file.$PBS_ARRAY_INDEX.fltrd > FullIndex.$PBS_ARRAY_INDEX.$STEP    
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
INDEX_FILE=$WORK/Constant/$FILE1
elif [ $PBS_ARRAY_INDEX = 2 ]; then
INDEX_FILE=$WORK/Constant/$FILE2
elif [ $PBS_ARRAY_INDEX = 3 ]; then
INDEX_FILE=$WORK/Constant/$FILE3
elif [ $PBS_ARRAY_INDEX = 4 ]; then
INDEX_FILE=$WORK/Constant/$FILE4
elif [ $PBS_ARRAY_INDEX = 5 ]; then
INDEX_FILE=$WORK/Constant/$FILE5
elif [ $PBS_ARRAY_INDEX = 6 ]; then
INDEX_FILE=$WORK/Constant/$FILE6
elif [ $PBS_ARRAY_INDEX = 7 ]; then
INDEX_FILE=$WORK/Constant/$FILE7
elif [ $PBS_ARRAY_INDEX = 8 ]; then
INDEX_FILE=$WORK/Constant/$FILE8
elif [ $PBS_ARRAY_INDEX = 9 ]; then
INDEX_FILE=$WORK/Constant/$FILE9
elif [ $PBS_ARRAY_INDEX = 10 ]; then
INDEX_FILE=$WORK/Constant/$FILE10
fi

echo "Indexing data file: " $INDEX_FILE
awk 'NR==FNR{a[$1,$2]=$4;next} ($1,$2) in a{print $1,$2,$3,a[$1,$2],$4}' FullIndex.$PBS_ARRAY_INDEX.$PREV_STEP <(gzip -dc $INDEX_FILE) > Idx.$PBS_ARRAY_INDEX
LEN3=`cat Idx.$PBS_ARRAY_INDEX | wc -l`
echo "Length of new data file" $LEN3

echo "Adding column for standard bias calculation"
awk 'NR>0{printf("%s %6.6f\n", $0, ($5-$4)/$4)}' Idx.$PBS_ARRAY_INDEX > Calc1.$PBS_ARRAY_INDEX
rm Idx.$PBS_ARRAY_INDEX

echo "Adding column for root mean square deviation calculation"
awk 'NR>0{printf("%s %7.6f\n", $0, ($5-$4)^2)}' Calc1.$PBS_ARRAY_INDEX > $INDEX_FILE.idx
LEN4=`cat $INDEX_FILE.idx | wc -l`
LEN5=`zcat $INDEX_FILE.idx | wc -l`
echo "Length of final file:" $LEN4
rm Calc1.$PBS_ARRAY_INDEX

echo "Full processing completed"

SB=$(awk '{s+=$6}END{print s}' $INDEX_FILE.idx)
SUM_RMSD=$(awk '{s+=$7}END{print s}' $INDEX_FILE.idx)
RMSD=$(echo "scale=6;sqrt($SUM_RMSD/$LEN4)" | bc)

echo "Standard Bias:" $SB
echo "The sum of RMSD before scaled:" $SUM_RMSD
echo "Len of final is" $LEN4
echo "Zcat len:" $LEN5
echo "Root Mean Square Deviation" $RMSD
