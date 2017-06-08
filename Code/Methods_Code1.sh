SAM=samtools
MS=/usr/bin/ms
TOGLF=/usr/bin/msToGlf
ANGSD=/usr/bin/angsd
NGSLD=/usr/bin/ngsLD

$MS $N_SAM $N_REPS -t $THETA -r $RHO $N_SITES > $1.txt
for i in 50 20 10 5
do
	$TOGLF -in $1.txt -out $1_reads$i -regLen $N_SITES -singleOut 1 -depth $i -err $ERR_RATE -pileup 0 -Nsites 0

	$ANGSD -glf $1_reads$i.glf.gz -fai reference.fa.fai -nInd $N_IND -doMajorMinor 1 -doPost 1 -doMaf 1 -doGeno 32 -out $1_reads$i -isSim 1 -minMaf $MINMAF

	gunzip -f $1_reads$i.geno.gz

	zcat $1_reads$i.mafs.gz | cut -f 1,2 | tail -n +2 > $1_pos$i.txt
	NS=`cat $1_pos$i.txt | wc -l` 
 
	$NGSLD --verbose 1 --n_ind $N_IND --n_sites $NS --geno $1_reads$i.geno --probs --pos $1_pos$i.txt --max_kb_dist 1000 | gzip > $1_Reads$i.ld.gz

	$NGSLD --verbose 1 --n_ind $N_IND --n_sites $NS --geno $1_reads$i.geno --probs --pos $1_pos$i.txt --max_kb_dist 1000 --call_geno | gzip > $1_Call$i.ld.gz
done
