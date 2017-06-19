#!/bin/bash
#PBS -l walltime=47:30:00
#PBS -lselect=1:ncpus=1:mem=250gb 

module load intel-suite
module load gsl
module load htslib
module load anaconda

REF=$WORK/Duck/Ap_Ref.fa
ls $WORK/Duck/A*.bam > $WORK/Duck/bam.filelist
N_IND=`ls $WORK/Duck/A*.bam | wc -l`
MINMAF=$(echo "scale=3; 1/$N_IND" | bc)

echo "SCRIPT BEGAN RUNNING AT..."
date

#Get pos.txt and $NS
zcat $WORK/Duck/Duck.mafs.gz | cut -f 1,2 | tail -n +2 > $WORK/Duck/Duck_pos.txt
NS=`cat $WORK/Duck/Duck_pos.txt | wc -l`

#Unzip geno file and run ngsLD
gunzip -f $WORK/Duck/Duck.geno.gz
$HOME/Packages/ngsLD/ngsLD --geno $WORK/Duck/Duck.geno --out $WORK/Duck/Duck.ld --pos $WORK/Duck/Duck_pos.txt --n_ind $N_IND --n_sites $NS --verbose 1 --probs --max_kb_dist 1000 --min_maf $MINMAF

echo "SCRIPT RUN TO COMPLETION"
