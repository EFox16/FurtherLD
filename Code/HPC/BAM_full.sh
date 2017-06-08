#!/bin/bash
#PBS -l walltime=47:30:00
#PBS -lselect=1:ncpus=1:mem=250gb 

module load intel-suite
module load gsl
module load htslib

REF=$WORK/Duck/Ap_Ref.fa
ls $WORK/Duck/A*.bam > $WORK/Duck/bam.filelist
N_IND=`ls $WORK/Duck/A*.bam | wc -l`
MINMAF=$(echo "scale=3; 1/$N_IND" | bc)

echo "SCRIPT BEGAN RUNNING AT..." 
date

$HOME/Packages/angsd/angsd -b $WORK/Duck/bam.filelist -ref $REF -out $WORK/Duck/Dchr_full.qc \
	-uniqueOnly 1 -remove_bads 1 -only_proper_pairs 1 -trim 0 -C 50 -baq 1 \
	-minMapQ 20 -minQ 0 \
	-doQsDist 1 -doDepth 1 -doCounts 1 -maxDepth 1000 

echo "SCRIPT RUN TO COMPLETION"
