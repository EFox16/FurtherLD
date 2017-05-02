#!/bin/bash
#PBS -l walltime=08:00:00
#PBS -lselect=1:ncpus=1:mem=250gb 

module load intel-suite
module load java

echo "Processing begun at..."
date

SRA_TOOLS=$HOME/Packages/SRA_Tools/bin
TRIMMOMATIC=$HOME/Packages/Trimmomatic/trimmomatic-0.36.jar
HISAT2=$HOME/Packages/HISAT2
SAMTOOLS=$HOME/Packages/Samtools/samtools

ADAPTER_FILE=$HOME/Packages/Trimmomatic/adapters/TruSeq3-PE
REF_GENOME=Mg_Ref.fa

if [ $PBS_ARRAY_INDEX = 1 ]; then
SET_NAME=SRR1796077
SAMPLE_NAME=MGAFS1
elif [ $PBS_ARRAY_INDEX = 2 ]; then
SET_NAME=SRR1796079
SAMPLE_NAME=MGAFS2
elif [ $PBS_ARRAY_INDEX = 3 ]; then
SET_NAME=SRR1796119
SAMPLE_NAME=MGAMS1
elif [ $PBS_ARRAY_INDEX = 4 ]; then
SET_NAME=SRR1797814
SAMPLE_NAME=MGAMS2
elif [ $PBS_ARRAY_INDEX = 5 ]; then
SET_NAME=SRR1797815
SAMPLE_NAME=MGAMS3
elif [ $PBS_ARRAY_INDEX = 6 ]; then
SET_NAME=SRR1796058
SAMPLE_NAME=MGAFG2
elif [ $PBS_ARRAY_INDEX = 7 ]; then
SET_NAME=SRR1796059
SAMPLE_NAME=MGAFG3
elif [ $PBS_ARRAY_INDEX = 8 ]; then
SET_NAME=SRR1796067
SAMPLE_NAME=MGAFG4
elif [ $PBS_ARRAY_INDEX = 9 ]; then
SET_NAME=SRR1796070
SAMPLE_NAME=MGAFG5
elif [ $PBS_ARRAY_INDEX = 10 ]; then
SET_NAME=SRR1796082
SAMPLE_NAME=MGAMG1
elif [ $PBS_ARRAY_INDEX = 11 ]; then
SET_NAME=SRR1796084
SAMPLE_NAME=MGAMG2
elif [ $PBS_ARRAY_INDEX = 12 ]; then
SET_NAME=SRR1796085
SAMPLE_NAME=MGAMG3
elif [ $PBS_ARRAY_INDEX = 13 ]; then
SET_NAME=SRR1796088
SAMPLE_NAME=MGAMG4
elif [ $PBS_ARRAY_INDEX = 14 ]; then
SET_NAME=SRR1796090
SAMPLE_NAME=MGAMG5
fi

echo -e "\nDownloading paired-end reads from NCBI database"
$SRA_TOOLS/fastq-dump -I --split-files $SET_NAME
date

echo -e "\nTrimming low quality sections with trimmomatic"
java -jar $TRIMMOMATIC PE ${SET_NAME}_1.fastq ${SET_NAME}_2.fastq ${SET_NAME}_1P.fq ${SET_NAME}_1U.fq ${SET_NAME}_2P.fq ${SET_NAME}_2U.fq ILLUMINACLIP:$ADAPTER_FILE:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:50
date

echo -e "\nMapping reads to reference genome"
$HISAT2/hisat2 $WORK/Mg_db -1 ${SET_NAME}_1P.fq -2 ${SET_NAME}_2P.fq --phred33 -q --no-discordant --no-mixed --no-unal --dta -S ${SET_NAME}.sam --met-file ${SET_NAME}_MetFile
date

echo -e "\nConverting from SAM to BAM format"
$SAMTOOLS view -bS ${SET_NAME}.sam > ${SAMPLE_NAME}.bam

echo -e "\nSorting BAM file"
$SAMTOOLS sort -o ${SAMPLE_NAME}_srtd.bam $WORK/${SAMPLE_NAME}.bam 
date

echo -e "\nIndexing BAM file"
$SAMTOOLS index ${SAMPLE_NAME}_srtd.bam ${SAMPLE_NAME}_srtd.bai
date

echo -e "\nZipping .bam and .bai files"
tar czvf ${SAMPLE_NAME}.tgz ${SAMPLE_NAME}_srtd*

echo -e "\nMoving .bam and .bai files to work directory"
mv ${SAMPLE_NAME}.tgz $WORK

echo -e "\nScript run to completion"
date
