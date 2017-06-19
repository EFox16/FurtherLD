#Define paths to packages
SAMTOOLS=/usr/bin/samtools
ANGSD=/usr/bin/angsd/angsd
NGSLD=/usr/bin/ngsLD

#Set input parameters
ls Duck/A*.bam > Duck/bam.filelist
N_IND=`ls Duck/A*.bam | wc -l`
MINMAF=$(echo "scale=3; 1/$N_IND" | bc)
REF=Ap_Ref.fa


# PIPELINE #############################################################

#Index the reference file
$SAMTOOLS faidx Ap_Ref.fa

#Analyse the quality of the sequences in the bam files
$ANGSD -b Duck/bam.filelist -ref $REF -out Duck/Dchr_full.qc \
	-uniqueOnly 1 -remove_bads 1 -only_proper_pairs 1 -trim 0 -C 50 -baq 1 \
	-minMapQ 20 -minQ 0 \
	-doQsDist 1 -doDepth 1 -doCounts 1 -maxDepth 1000

#View quality
Rscript plotQC.R Dchr_full.info

#Calculate genotype likelihoods for each locus using ANGSD
$ANGSD -b Duck/bam.filelist -ref $REF -out Duck/Duck -rf Duck/chrom_names.txt \
	-uniqueOnly 1 -remove_bads 1 -only_proper_pairs 1 -trim 0 -C 50 -baq 1 \
	-minMapQ 20 -minQ 20 -minInd 7 -setMinDepth 0 -setMaxDepth 219 -doCounts 1 \
	-GL 1 -doMajorMinor 1 -doMaf 1 -skipTriallelic 1 \
	-minMaf $MINMAF \
	-doGeno 32 -doPost 1 


#Create position files and determine number of sites
zcat Duck/Duck.mafs.gz | cut -f 1,2 | tail -n +2 > Duck/Duck_pos.txt
NS=`cat Duck/Duck_pos.txt | wc -l`

#Unzip geno file and run ngsLD
gunzip -f Duck/Duck.geno.gz
$NGSLD --geno Duck/Duck.geno --out Duck/Duck.ld --pos Duck/Duck_pos.txt --n_ind $N_IND --n_sites $NS --verbose 1 --probs --max_kb_dist 1000 --min_maf $MINMAF

#Run exponential curve fitting script 
python Fit_Exp.py --input_type FILE --input_name Duck.ld --data_type r2GLS --plot
