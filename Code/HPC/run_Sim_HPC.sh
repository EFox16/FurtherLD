#!/bin/bash
#PBS -l walltime=07:30:00
#PBS -lselect=1:ncpus=1:mem=50gb 

module load intel-suite
module load gsl
module load htslib

MS=$HOME/Packages/msdir/ms
TOGLF=$HOME/Packages/angsd/misc/msToGlf
ANGSD=$HOME/Packages/angsd/angsd
NGSLD=$HOME/Packages/ngsLD/ngsLD


echo "BEGINNING RUN AT..."
date

SET_NAME="Constant"
N_SAM=100 
N_REPS=1 
THETA=6000 
RHO=$THETA
N_SITES=10000000 
ERR_RATE=0.01

N_IND=$((N_SAM / 2))
MINMAF=$(echo "scale=3; 2/$N_SAM" | bc)

if [ $PBS_ARRAY_INDEX = 1 ]; then
READ_NUM=50
elif [ $PBS_ARRAY_INDEX = 2 ]; then
READ_NUM=20
elif [ $PBS_ARRAY_INDEX = 3 ]; then
READ_NUM=10
elif [ $PBS_ARRAY_INDEX = 4 ]; then
READ_NUM=5
elif [ $PBS_ARRAY_INDEX = 5 ]; then
READ_NUM=2
fi

$MS $N_SAM $N_REPS -t $THETA -r $RHO $N_SITES > ${SET_NAME}.txt
echo "MS RUN COMPLETE"
date

$TOGLF -in ${SET_NAME}.txt -out ${SET_NAME}_reads${READ_NUM} -regLen $N_SITES -singleOut 1 -depth ${READ_NUM} -err $ERR_RATE -pileup 0 -Nsites 0
echo "msToGLF RUN COMPLETE"
date

$ANGSD -glf ${SET_NAME}_reads${READ_NUM}.glf.gz -fai $WORK/Constant/reference.fa.fai -nInd $N_IND -doMajorMinor 1 -doPost 1 -doMaf 1 -doGeno 32 -out ${SET_NAME}_reads${READ_NUM} -isSim 1 -minMaf $MINMAF
echo "ANGSD RUN COMPLETE"
date

gunzip -f ${SET_NAME}_reads${READ_NUM}.geno.gz
echo "GENO FILE UNZIPPED"
date

zcat ${SET_NAME}_reads${READ_NUM}.mafs.gz | cut -f 1,2 | tail -n +2 > ${SET_NAME}_pos${READ_NUM}.txt
NS=`cat ${SET_NAME}_pos${READ_NUM}.txt | wc -l` 
echo "POSITION FILE CREATED"
date

$NGSLD --verbose 1 --n_ind $N_IND --n_sites $NS --geno ${SET_NAME}_reads${READ_NUM}.geno --probs --pos ${SET_NAME}_pos${READ_NUM}.txt --max_kb_dist 1000 | gzip > ${SET_NAME}_Reads${READ_NUM}.ld.gz
mv ${SET_NAME}_Reads${READ_NUM}.ld.gz $WORK/Constant
echo "NGSLD RUN USING LIKELIHOODS COMPLETE"
date

$NGSLD --verbose 1 --n_ind $N_IND --n_sites $NS --geno ${SET_NAME}_reads${READ_NUM}.geno --probs --pos ${SET_NAME}_pos${READ_NUM}.txt --max_kb_dist 1000 --call_geno | gzip > ${SET_NAME}_Call${READ_NUM}.ld.gz
mv ${SET_NAME}_Call${READ_NUM}.ld.gz $WORK/Constant
echo "NGSLD RUN USING CALLED GENOTYPES COMPLETE"
date


echo "SCRIPT HAS RUN TO COMPLETION"
