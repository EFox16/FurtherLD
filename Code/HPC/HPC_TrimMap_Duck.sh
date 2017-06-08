#!/bin/bash
#PBS -l walltime=06:30:00
#PBS -lselect=1:ncpus=1:mem=64gb 

module load intel-suite
module load java

echo "Processing begun at..."
date

SRA_TOOLS=$HOME/Packages/SRA_Tools/bin
TRIMMOMATIC=$HOME/Packages/Trimmomatic/trimmomatic-0.36.jar
HISAT2=$HOME/Packages/HISAT2
SAMTOOLS=$HOME/Packages/Samtools/samtools

ADAPTER_FILE=$HOME/Packages/Trimmomatic/adapters/TruSeq3-PE
REF_GENOME=Ap_Ref.fa

if [ $PBS_ARRAY_INDEX = 1 ]; then
SET_NAME=SRR1796027
SAMPLE_NAME=APLFS1
elif [ $PBS_ARRAY_INDEX = 2 ]; then
SET_NAME=SRR1796028
SAMPLE_NAME=APLFS2
elif [ $PBS_ARRAY_INDEX = 3 ]; then
SET_NAME=SRR1796029
SAMPLE_NAME=APLFS3
elif [ $PBS_ARRAY_INDEX = 4 ]; then
SET_NAME=SRR1796030
SAMPLE_NAME=APLFS4
elif [ $PBS_ARRAY_INDEX = 5 ]; then
SET_NAME=SRR1796031
SAMPLE_NAME=APLFS5
elif [ $PBS_ARRAY_INDEX = 6 ]; then
SET_NAME=SRR1796037
SAMPLE_NAME=APLMS1
elif [ $PBS_ARRAY_INDEX = 7 ]; then
SET_NAME=SRR1796038
SAMPLE_NAME=APLMS2
elif [ $PBS_ARRAY_INDEX = 8 ]; then
SET_NAME=SRR1796039
SAMPLE_NAME=APLMS3
elif [ $PBS_ARRAY_INDEX = 9 ]; then
SET_NAME=SRR1796040
SAMPLE_NAME=APLMS4
elif [ $PBS_ARRAY_INDEX = 10 ]; then
SET_NAME=SRR1796041
SAMPLE_NAME=APLMS5
elif [ $PBS_ARRAY_INDEX = 11 ]; then
SET_NAME=SRR1796022
SAMPLE_NAME=APLFG1
elif [ $PBS_ARRAY_INDEX = 12 ]; then
SET_NAME=SRR1796023
SAMPLE_NAME=APLFG2
elif [ $PBS_ARRAY_INDEX = 13 ]; then
SET_NAME=SRR1796024
SAMPLE_NAME=APLFG3
elif [ $PBS_ARRAY_INDEX = 14 ]; then
SET_NAME=SRR1796025
SAMPLE_NAME=APLFG4
elif [ $PBS_ARRAY_INDEX = 15 ]; then
SET_NAME=SRR1796026
SAMPLE_NAME=APLFG5
elif [ $PBS_ARRAY_INDEX = 16 ]; then
SET_NAME=SRR1796032
SAMPLE_NAME=APLMG1
elif [ $PBS_ARRAY_INDEX = 17 ]; then
SET_NAME=SRR1796033
SAMPLE_NAME=APLMG2
elif [ $PBS_ARRAY_INDEX = 18 ]; then
SET_NAME=SRR1796034
SAMPLE_NAME=APLMG3
elif [ $PBS_ARRAY_INDEX = 19 ]; then
SET_NAME=SRR1796035
SAMPLE_NAME=APLMG4
elif [ $PBS_ARRAY_INDEX = 20 ]; then
SET_NAME=SRR1796036
SAMPLE_NAME=APLMG5
fi

echo -e "\nDownloading paired-end reads from NCBI database"
$SRA_TOOLS/fastq-dump -I --split-files $SET_NAME
date

echo -e "\nTrimming low quality sections with trimmomatic"
java -jar $TRIMMOMATIC PE ${SET_NAME}_1.fastq ${SET_NAME}_2.fastq ${SET_NAME}_1P.fq ${SET_NAME}_1U.fq ${SET_NAME}_2P.fq ${SET_NAME}_2U.fq ILLUMINACLIP:$ADAPTER_FILE:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:50
date

echo -e "\nMapping reads to reference genome"
$HISAT2/hisat2 $WORK/Ap_db -1 ${SET_NAME}_1P.fq -2 ${SET_NAME}_2P.fq --phred33 -q --no-discordant --no-mixed --no-unal --dta -S ${SET_NAME}.sam --met-file ${SET_NAME}_MetFile
date

echo -e "\nConverting from SAM to BAM format"
$SAMTOOLS view -bS ${SET_NAME}.sam > ${SAMPLE_NAME}.bam
rm $WORK/Downloads/sra/${SET_NAME}*
date

echo -e "\nSorting BAM file"
$SAMTOOLS sort -o ${SAMPLE_NAME}_srtd.bam ${SAMPLE_NAME}.bam 
date

echo -e "\nIndexing BAM file"
$SAMTOOLS index ${SAMPLE_NAME}_srtd.bam ${SAMPLE_NAME}_srtd.bai
date

echo -e "\nZipping .bam and .bai files"
tar czvf ${SAMPLE_NAME}.tgz ${SAMPLE_NAME}_srtd*
date

echo -e "\nMoving .bam and .bai files to work directory"
mv ${SAMPLE_NAME}.tgz $WORK

echo -e "\nScript run to completion"
date

