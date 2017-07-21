#!/bin/bash
#PBS -l walltime=47:30:00
#PBS -lselect=1:ncpus=1:mem=32gb 

module load intel-suite
module load gsl
module load htslib

REF=$WORK/Guppy/Pr_Ref.fa
#*MAKE BAM FILE LIST PER POPULATION*
#*AND CALC N_IND*
N_IND=`ls $WORK/M*.bam | wc -l`
MINMAF=$(echo "scale=3; 1/$N_IND" | bc)

echo "SCRIPT BEGAN RUNNING AT..." 
date

$HOME/Packages/angsd/angsd -b $POP_BAMLIST -ref $REF -out $WORK/Guppy/chr_${PBS_ARRAY_INDEX}.qc -r $PBS_ARRAY_INDEX \
	-uniqueOnly 1 -remove_bads 1 -only_proper_pairs 1 -trim 0 -C 50 -baq 1 \
	-minMapQ 20 -minQ 0 \
	-doQsDist 1 -doDepth 1 -doCounts 1 -maxDepth 1000 

echo "SCRIPT RUN TO COMPLETION"

#WHY DOES PBS ARRAY INDEX MATTER?
