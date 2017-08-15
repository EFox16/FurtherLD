#!/bin/bash
#PBS -l walltime=47:30:00
#PBS -lselect=1:ncpus=1:mem=250gb 

module load intel-suite
module load gsl
module load htslib
module load anaconda

ls $WORK/Turkey/M*.bam > $WORK/Turkey/bam.filelist
N_IND=`ls $WORK/Turkey/M*.bam | wc -l`
MINMAF=$(echo "scale=3; 1/$N_IND" | bc)

echo "SCRIPT BEGAN RUNNING AT..."
date

NS=`cat $WORK/Turkey/Turkey_pos.txt | wc -l`

#Unzip geno file and run ngsLD
$HOME/Packages/ngsLD/ngsLD --geno $WORK/Turkey/Turkey.geno --out $WORK/Turkey/Turkey.ld --pos $WORK/Turkey/Turkey_pos.txt --n_ind $N_IND --n_sites $NS --verbose 1 --probs --max_kb_dist 1000 --min_maf $MINMAF


echo "SCRIPT RUN TO COMPLETION"
