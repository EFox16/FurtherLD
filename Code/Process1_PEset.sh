#!/bin/bash
# Author: Emma Fox e.fox16@imperial.ac.uk
# Script: Process1_PEset.sh
# Desc: Pipeline for taking a set of paired end files and running them through
# 	FastQC - to get graphs of initital quality
# 	Trimmomatic - to remove low quality sequence data
#	FastQC (again) - to evaluate trimmed sequence data
# 	STAMPY - to map the reads to the guppy genome
#	GATK and Platypus - to call variants
# 	VCFTools - to filter the calle SNPS
# Arguments: 
#	Set name of file pairs
#
#	File in path names to packages and reference files 

########################################################################
# PATHS                                                                #
########################################################################

FASTQC=../../Thesis/Packages/FastQC/fastqc
TRIMMOMATIC=/usr/bin/trimmomatic.jar
STAMPY=./../../Thesis/Packages/stampy-1.0.31/stampy.py
SAMTOOLS=samtools
GATK=../../Thesis/Packages/GenomeAnalysisTK-3.7/GenomeAnalysisTK.jar

ADAPTOR_FILE=Adaptors.fa
REF_GENOME=GCF_000633615.1_Guppy_female_1.0_MT_genomic.fna
#fna is a fasta nucleic acid file. can rename to .fa or .fasta

########################################################################
# INPUT VARIABLES                                                      #
########################################################################

SET_NAME=$1

########################################################################
# INITIAL QUALITY ANALYSIS                                             #
########################################################################

echo -e "\nChecking initial ready quality with FastQC"

$FASTQC ${SET_NAME}_1.fastq ${SET_NAME}_2.fastq

########################################################################
# TRIM LOW QUALITY SECTIONS                                            #
########################################################################
#How to use base out?
echo -e "\nTrimming low quality section with Trimmomatic"

java -jar $TRIMMOMATIC PE ${SET_NAME}_1.fastq ${SET_NAME}_2.fastq ${SET_NAME}_1P.fq.gz ${SET_NAME}_1U.fq.gz ${SET_NAME}_2P.fq.gz ${SET_NAME}_2U.fq.gz ILLUMINACLIP:$ADAPTOR_FILE:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:50

########################################################################
# QUALITY ANALYSIS AFTER TRIMMING                                      #
########################################################################
#Use paired or unpaired reads? Do I have to unzip first?

echo -e "\nChecking processed sequence quality"

$FASTQC ${SET_NAME}_1P.fq.gz ${SET_NAME}_2P.fq.gz

########################################################################
# MAP TO REFERENCE GENOME                                              #
########################################################################

if [ ! -f hg18.stidx ]
	then
		echo -e "\nFormatting genome file"
		$STAMPY -G hg18 $REF_GENOME
	else 
		echo -e "\nFormatted genome file already exists"
fi

if [ ! -f hg18.sthash ]
	then
		echo -e "\nBuilding hash table"
		$STAMPY -g hg18 -H hg18
	else 
		echo -e "\nHash table already exists"
fi

echo -e "\nMapping reads with Stampy"
$STAMPY -g hg18 -h hg18 -M ${SET_NAME}_1P.fq.gz ${SET_NAME}_2P.fq.gz

########################################################################
# CONVERT TO BAM FORMAT WITH SAMTOOLS                                  #
########################################################################
#check if there's a HEADER and if the command is bS or Sb
$SAMTOOLS view -bS ${SET_NAME}.sam | $SAMTOOLS sort - ${SET_NAME}_sorted


########################################################################
# VARIANT CALLING WITH GATK                                            #
########################################################################
#needs to be in SAM format when we get to this point
#.bam, indexed and sorted in coordinate order, proper bam header

echo -e "\nCalling SNPs with GATK"
java -jar $GATK -T HaplotypeCaller -R $REF_GENOME -I ${SET_NAME}_sorted.bam -o ${SET_NAME}.vcf -ERC GVCF 

#-L 20:10,000,000-10,200,000 Don't think we need to subset because
#we have full genome but should ask

#Can combine lots of gvcfs after that
