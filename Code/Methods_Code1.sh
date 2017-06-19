########################################################################
# Pt. 1 - Simulation                                                   #
########################################################################

#Define paths to packages
SAM=/usr/bin/samtools
MS=/usr/bin/ms
TOGLF=/usr/bin/angsd/msToGlf
ANGSD=/usr/bin/angsd/angsd
NGSLD=/usr/bin/ngsLD

#Set input parameters
SET_NAME=Test_Sim
N_SAM=100
N_REPS=1 
THETA=600 
RHO=600
N_SITES=10000000 
ERR_RATE=0.01
N_IND=$((N_SAM / 2))
MINMAF=$(echo "scale=3; 2/$N_SAM" | bc)

# PIPELINE #############################################################

#Simulate variable sites for the specified population
$MS $N_SAM $N_REPS -t $THETA -r $RHO $N_SITES > $1.txt

#This loop runs ANGSD for a hypothetical read depth of 50, 20, 10, and 5
for i in 50 20 10 5
do
	#Create genotype likelihood files for data sets of varying depth from the ms variable sites
	$TOGLF -in $1.txt -out $1_reads$i -regLen $N_SITES -singleOut 1 -depth $i -err $ERR_RATE -pileup 0 -Nsites 0
	
	#Run ANGSD to create the full sample sequences for each data set
	$ANGSD -glf $1_reads$i.glf.gz -fai reference.fa.fai -nInd $N_IND -doMajorMinor 1 -doPost 1 -doMaf 1 -doGeno 32 -out $1_reads$i -isSim 1 -minMaf $MINMAF
	
	#Unzip geno file
	gunzip -f $1_reads$i.geno.gz

	#Create position file and determine number of sites (NS)
	zcat $1_reads$i.mafs.gz | cut -f 1,2 | tail -n +2 > $1_pos$i.txt
	NS=`cat $1_pos$i.txt | wc -l` 
 
	#Run ngsLD using genotype likelihoods
	$NGSLD --verbose 1 --n_ind $N_IND --n_sites $NS --geno $1_reads$i.geno --probs --pos $1_pos$i.txt --max_kb_dist 1000 | gzip > $1_Reads$i.ld.gz

	#Run ngsLD using called genotypes
	$NGSLD --verbose 1 --n_ind $N_IND --n_sites $NS --geno $1_reads$i.geno --probs --pos $1_pos$i.txt --max_kb_dist 1000 --call_geno | gzip > $1_Call$i.ld.gz
done
