#!/bin/bash
# Author: Emma Fox e.fox16@imperial.ac.uk
# Script: TD_BAM_Pipeline.sh
# Desc: Draft of analysis for turkey and duck bam files
# Arguments: {AT THE MOMENT} Run in turkey (or duck) folder 

#Create list of bam files and N_IND
ls *.bam > bam.filelist
N_IND=`ls *.bam | wc -l`

#Generate glf and mafs file 
/usr/bin/angsd -GL 1 -doGlf 1 -bam bam.filelist -out Turkey -doMajorMinor 1 -doMaf 1 -minMaf 0.05 -P 4 -downSample 0.10

#Get .fai reference
samtools faidx Mg_ref.fa

#Generate geno file
/usr/bin/angsd -glf Turkey.glf.gz -out Turkey -fai Mg_ref.fa.fai -doMajorMinor 1 -doPost 1 -doMaf 1 -doGeno 32 -minMaf 0.05 -nInd $N_IND

#Get pos.txt and $NS
zcat Turkey.mafs.gz | cut -f 1,2 | tail -n +2 > Turkey_pos.txt
NS=`cat Turkey_pos.txt | wc -l`

#Unzip geno file and run ngsLD
gunzip -f Turkey.geno.gz
/usr/bin/ngsLD --geno Turkey.geno --out Turkey.ld --pos Turkey_pos.txt --n_ind $N_IND --n_sites $NS --verbose 1 --probs --max_kb_dist 1000 --min_maf 0.05 #--rnd_sample 0.05

#Run fitting script 
python Fit_Exp.py --input_type FILE --input_name Turkey.ld --data_type r2GLS --plot

