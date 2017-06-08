SRA_TOOLS=$HOME/Packages/SRA_Tools/bin
TRIMMOMATIC=$HOME/Packages/Trimmomatic/trimmomatic-0.36.jar
HISAT2=$HOME/Packages/HISAT2
SAMTOOLS=$HOME/Packages/Samtools/samtools

SET_NAME=SRR1796077
SAMPLE_NAME=MGAFS1
ADAPTER_FILE=$WORK/AEW-adaptors.fa
REF_GENOME=Mg_Ref.fa

$SRA_TOOLS/fastq-dump -I --split-files $SET_NAME

java -jar $TRIMMOMATIC PE ${SET_NAME}_1.fastq ${SET_NAME}_2.fastq ${SET_NAME}_1P.fq ${SET_NAME}_1U.fq ${SET_NAME}_2P.fq ${SET_NAME}_2U.fq ILLUMINACLIP:$ADAPTER_FILE:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:50

$HISAT2/hisat2 $WORK/Mg_db -1 ${SET_NAME}_1P.fq -2 ${SET_NAME}_2P.fq --phred33 -q --no-discordant --no-mixed --no-unal --dta -S ${SET_NAME}.sam --met-file ${SET_NAME}_MetFile

$SAMTOOLS view -bS ${SET_NAME}.sam > ${SAMPLE_NAME}.bam
rm $WORK/Downloads/sra/${SET_NAME}*
date

$SAMTOOLS sort -o ${SAMPLE_NAME}_srtd.bam ${SAMPLE_NAME}.bam 

$SAMTOOLS index ${SAMPLE_NAME}_srtd.bam ${SAMPLE_NAME}_srtd.bai


ls $WORK/Duck/A*.bam > $WORK/Duck/bam.filelist
N_IND=`ls $WORK/Duck/A*.bam | wc -l`
MINMAF=$(echo "scale=3; 1/$N_IND" | bc)

$HOME/Packages/angsd/angsd -b $WORK/Duck/bam.filelist -ref $REF -out $WORK/Duck/Dchr_full.qc \
	-uniqueOnly 1 -remove_bads 1 -only_proper_pairs 1 -trim 0 -C 50 -baq 1 \
	-minMapQ 20 -minQ 0 \
	-doQsDist 1 -doDepth 1 -doCounts 1 -maxDepth 1000

Rscript plotQC.R Dchr_full.info

$HOME/Packages/angsd/angsd -b $WORK/Duck/bam.filelist -ref $REF -out $WORK/Duck/Duck -rf $WORK/Duck/chrom_names.txt \
	-uniqueOnly 1 -remove_bads 1 -only_proper_pairs 1 -trim 0 -C 50 -baq 1 \
	-minMapQ 20 -minQ 20 -minInd 7 -setMinDepth 0 -setMaxDepth 219 -doCounts 1 \
	-GL 1 -doMajorMinor 1 -doMaf 1 -skipTriallelic 1 \
	-minMaf $MINMAF \
	-doGeno 32 -doPost 1 


#Get pos.txt and $NS
zcat $WORK/Duck/Duck.mafs.gz | cut -f 1,2 | tail -n +2 > $WORK/Duck/Duck_pos.txt
NS=`cat $WORK/Duck/Duck_pos.txt | wc -l`

#Unzip geno file and run ngsLD
gunzip -f $WORK/Duck/Duck.geno.gz
$HOME/Packages/ngsLD/ngsLD --geno $WORK/Duck/Duck.geno --out $WORK/Duck/Duck.ld --pos $WORK/Duck/Duck_pos.txt --n_ind $N_IND --n_sites $NS --verbose 1 --probs --max_kb_dist 1000 --min_maf $MINMAF

python $Fit_Exp --input_type FILE --input_name Duck.ld --data_type r2GLS --plot
