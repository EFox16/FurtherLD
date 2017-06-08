#!/bin/bash
# Author: Emma Fox e.fox16@imperial.ac.uk
# Script: TD_BAM_Pipeline.sh
# Desc: Draft of analysis for turkey and duck bam files
# Arguments: {AT THE MOMENT} Run in turkey (or duck) folder 

#Create list of bam files and N_IND
ls *.bam > bam.filelist
N_IND=`ls *.bam | wc -l`
#1/2x ind for minMaf

#Get .fai reference
bgzip Mg_Ref.fa
samtools faidx Mg_Ref.fa

#ANGSD
#remember 'space' before \ 
/usr/bin/angsd -P 4 -b bam.filelist -ref Mg_Ref.fa -out ALL.qc -rf Mg_regions.txt \
	-uniqueOnly 1 -remove_bads 1 -only_proper_pairs 1 -trim 0 -C 50 -baq 1 \
	-minMapQ 20 -minQ 0 \
	-doQsDist 1 -doDepth 1 -doCounts 1 -maxDepth 1000 
	
Rscript ../../../Thesis/Packages/ngsTools/Scripts/plotQC.R ALL.qc
#info file will give percentiles

						#?
-minInd 7 -minMap 20 -minQ 0 -setMinDepth -setMaxDepth \
-doGeno 32 -doPost 1 -doMaf 1 -minMaf 0.14 \
-doMajorMinor 1 -GL 1


/usr/bin/angsd -P 4 -b bam.filelist -ref Mg_Ref.fa -out Turkey_prcssd -rf Mg_regions.txt \
	-uniqueOnly 1 -remove_bads 1 -only_proper_pairs 1 -trim 0 -C 50 -baq 1 \
	-minMapQ 20 -minQ 20 -minInd 7 -setMinDepth 10 -setMaxDepth 400 -doCounts 1 \
	-GL 1 -doMajorMinor 1 -doMaf 1 -skipTriallelic 1 \
	-minMaf 0.14 \
	-doGeno 32 -doPost 1 &> /dev/null


#Get pos.txt and $NS
zcat Turkey.mafs.gz | cut -f 1,2 | tail -n +2 > Turkey_pos.txt
NS=`cat Turkey_pos.txt | wc -l`

#Unzip geno file and run ngsLD
gunzip -f Turkey.geno.gz
/usr/bin/ngsLD --geno Turkey.geno --out Turkey.ld --pos Turkey_pos.txt --n_ind $N_IND --n_sites $NS --verbose 1 --probs --max_kb_dist 1000 --min_maf 0.05 #--rnd_sample 0.05

#Run fitting script 
python Fit_Exp.py --input_type FILE --input_name Turkey.ld --data_type r2GLS --plot

