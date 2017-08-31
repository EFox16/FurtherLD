#!/bin/bash
#PBS -l walltime=14:30:00
#PBS -lselect=1:ncpus=1:mem=190gb 

module load intel-suite
module load gsl
module load htslib
module load anaconda

REF=$WORK/Guppy/Pr_Ref.fa

if [ $PBS_ARRAY_INDEX = 1 ]; then
POP_NAME="ArHi"
POP_BAMLIST=$WORK/Guppy/ArHi.BamList
N_IND=5
MAX_DEPTH=134
elif [ $PBS_ARRAY_INDEX = 2 ]; then
POP_NAME="ArLo"
POP_BAMLIST=$WORK/Guppy/ArLo.BamList
N_IND=5
MAX_DEPTH=139
elif [ $PBS_ARRAY_INDEX = 3 ]; then
POP_NAME="MaHi"
POP_BAMLIST=$WORK/Guppy/MaHi.BamList
N_IND=5
MAX_DEPTH=247
elif [ $PBS_ARRAY_INDEX = 4 ]; then
POP_NAME="MaLo"
POP_BAMLIST=$WORK/Guppy/MaLo.BamList
N_IND=5
MAX_DEPTH=227
elif [ $PBS_ARRAY_INDEX = 5 ]; then
POP_NAME="QuHi"
POP_BAMLIST=$WORK/Guppy/QuHi.BamList
N_IND=5
MAX_DEPTH=139
elif [ $PBS_ARRAY_INDEX = 6 ]; then
POP_NAME="QuLo"
POP_BAMLIST=$WORK/Guppy/QuLo.BamList
N_IND=5
MAX_DEPTH=139
elif [ $PBS_ARRAY_INDEX = 7 ]; then
POP_NAME="YaHi"
POP_BAMLIST=$WORK/Guppy/YaHi.BamList
N_IND=4
MAX_DEPTH=95
elif [ $PBS_ARRAY_INDEX = 8 ]; then
POP_NAME="YaLo"
POP_BAMLIST=$WORK/Guppy/YaLo.BamList
N_IND=5
MAX_DEPTH=139
fi

MINMAF=$(echo "scale=3; 1/(2*$N_IND)" | bc)

echo "SCRIPT BEGAN RUNNING AT..."
date

#~ $HOME/Packages/angsd/angsd -b $POP_BAMLIST -ref $REF -out $WORK/Guppy/${POP_NAME}_smll \
	#~ -uniqueOnly 1 -remove_bads 1 -only_proper_pairs 1 -trim 0 -C 50 -baq 1 \
	#~ -minMapQ 20 -minQ 20 -minInd 3 -setMinDepth 0 -setMaxDepth $MAX_DEPTH -doCounts 1 \
	#~ -GL 1 -doMajorMinor 1 -doMaf 1 -skipTriallelic 1 \
	#~ -SNP_pval 0.00001 \
	#~ -doGeno 32 -doPost 1 


#~ #Get pos.txt and $NS
#~ zcat $WORK/Guppy/${POP_NAME}_smll.mafs.gz | cut -f 1,2 | tail -n +2 > $WORK/Guppy/${POP_NAME}_smll_pos.txt
NS=`cat $WORK/Guppy/${POP_NAME}_smll_pos.txt | wc -l`

#Unzip geno file and run ngsLD
echo "ngsLD BEGAN RUNNING AT"
date
gunzip -f $WORK/Guppy/${POP_NAME}_smll.geno.gz
$HOME/Packages/ngsLD/ngsLD --geno $WORK/Guppy/${POP_NAME}_smll.geno --out ${POP_NAME}_smll200.ld --pos $WORK/Guppy/${POP_NAME}_smll_pos.txt --n_ind $N_IND --n_sites $NS --verbose 1 --probs --max_kb_dist 200 --min_maf $MINMAF --rnd_sample 0.01


echo "Removing NaN"
LEN1=`cat ${POP_NAME}_smll200.ld | wc -l`
echo "Original Length:" $LEN1
awk '(NR>0) && $7==($7+0)' ${POP_NAME}_smll200.ld > ${POP_NAME}_smll200_fltrd.ld 
LEN2B=`cat ${POP_NAME}_smll200_fltrd.ld | wc -l`
DIFF_LENB=$((LEN1-LEN2B))
echo "Number of rows removed:" $DIFF_LENB
echo "New length:" $LEN2B

echo "Fit_Exp BEGAN RUNNING AT"
date
FILENAME=${POP_NAME}_smll200_fltrd.ld
echo $FILENAME > InList_${POP_NAME}_smll200
python $WORK/Fit_Exp.py --input_list InList_${POP_NAME}_smll200  --data_type r2GLS --output_prefix ${POP_NAME}_smll_fltrd_200

mv ${POP_NAME}_smll_fltrd_200.csv $WORK/Guppy/
echo "SCRIPT RUN TO COMPLETION"


