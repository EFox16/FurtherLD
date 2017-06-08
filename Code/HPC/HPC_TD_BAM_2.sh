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

$HOME/Packages/angsd/angsd -b $WORK/Duck/bam.filelist -ref $REF -out $WORK/Duck/Duck -rf $WORK/Duck/chrom_names.txt \
	-uniqueOnly 1 -remove_bads 1 -only_proper_pairs 1 -trim 0 -C 50 -baq 1 \
	-minMapQ 20 -minQ 20 -minInd 7 -setMinDepth 0 -setMaxDepth 219 -doCounts 1 \
	-GL 1 -doMajorMinor 1 -doMaf 1 -skipTriallelic 1 \
	-minMaf $MINMAF \
	-doGeno 32 -doPost 1 


#Get pos.txt and $NS
zcat $WORK/Duck/Duck.mafs.gz | cut -f 1,2 | tail -n +2 > $WORK/Duck/Duck_pos.txt
NS=`cat $WORK/Duck/Duck_pos.txt | wc -l`

#~ #Unzip geno file and run ngsLD
#~ gunzip -f $WORK/Duck/Duck.geno.gz
#~ $HOME/Packages/ngsLD/ngsLD --geno $WORK/Duck/Duck.geno --out $WORK/Duck/Duck.ld --pos $WORK/Duck/Duck_pos.txt --n_ind $N_IND --n_sites $NS --verbose 1 --probs --max_kb_dist 1000 --min_maf $MINMAF

echo "SCRIPT RUN TO COMPLETION"
