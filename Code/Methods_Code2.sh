#Define paths to packages
SRA_TOOLS=/usr/bin/SRA_Tools/bin
TRIMMOMATIC=/usr/bin/Trimmomatic/trimmomatic-0.36.jar
HISAT2=/usr/bin/HISAT2
SAMTOOLS=/usr/bin/samtools

#Set input parameters
SET_NAME=SRR1796077
SAMPLE_NAME=MGAFS1
ADAPTER_FILE=AEW-adaptors.fa
REF_GENOME=Mg_Ref.fa

# PIPELINE #############################################################

#Download the forward and reverse fastq files for the specified SRA set
$SRA_TOOLS/fastq-dump -I --split-files $SET_NAME

#Trim low quality sections using trimmomatic
java -jar $TRIMMOMATIC PE ${SET_NAME}_1.fastq ${SET_NAME}_2.fastq ${SET_NAME}_1P.fq ${SET_NAME}_1U.fq ${SET_NAME}_2P.fq ${SET_NAME}_2U.fq ILLUMINACLIP:$ADAPTER_FILE:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:50

#Use hisat to map the paired forward and reverse fastq files
$HISAT2/hisat2 $WORK/Mg_db -1 ${SET_NAME}_1P.fq -2 ${SET_NAME}_2P.fq --phred33 -q --no-discordant --no-mixed --no-unal --dta -S ${SET_NAME}.sam --met-file ${SET_NAME}_MetFile

#Convert the mapped files from sam to bam format
$SAMTOOLS view -bS ${SET_NAME}.sam > ${SAMPLE_NAME}.bam

#Sort the bam file
$SAMTOOLS sort -o ${SAMPLE_NAME}_srtd.bam ${SAMPLE_NAME}.bam 

#Create an index for the bam file
$SAMTOOLS index ${SAMPLE_NAME}_srtd.bam ${SAMPLE_NAME}_srtd.bai


