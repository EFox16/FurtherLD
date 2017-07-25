#!/bin/bash
#PBS -l walltime=47:30:00
#PBS -lselect=1:ncpus=1:mem=240gb 

module load intel-suite
module load gsl
module load htslib
module load anaconda

REF=$WORK/Guppy/Pr_Ref.fa

if [ $PBS_ARRAY_INDEX = 1 ]; then
POP_NAME="ArHi"
POP_BAMLIST=$WORK/Guppy/ArHi.BamList
N_IND=5
elif [ $PBS_ARRAY_INDEX = 2 ]; then
POP_NAME="ArLo"
POP_BAMLIST=$WORK/Guppy/ArLo.BamList
N_IND=5
elif [ $PBS_ARRAY_INDEX = 3 ]; then
POP_NAME="MaHi"
POP_BAMLIST=$WORK/Guppy/MaHi.BamList
N_IND=5
elif [ $PBS_ARRAY_INDEX = 4 ]; then
POP_NAME="MaLo"
POP_BAMLIST=$WORK/Guppy/MaLo.BamList
N_IND=5
elif [ $PBS_ARRAY_INDEX = 5 ]; then
POP_NAME="QuHi"
POP_BAMLIST=$WORK/Guppy/QuHi.BamList
N_IND=5
elif [ $PBS_ARRAY_INDEX = 6 ]; then
POP_NAME="QuLo"
POP_BAMLIST=$WORK/Guppy/QuLo.BamList
N_IND=5
elif [ $PBS_ARRAY_INDEX = 7 ]; then
POP_NAME="YaHi"
POP_BAMLIST=$WORK/Guppy/YaHi.BamList
N_IND=4
elif [ $PBS_ARRAY_INDEX = 8 ]; then
POP_NAME="YaLo"
POP_BAMLIST=$WORK/Guppy/YaLo.BamList
N_IND=5
fi

MINMAF=$(echo "scale=3; 1/$N_IND" | bc)

echo "SCRIPT BEGAN RUNNING AT..."
date

$HOME/Packages/angsd/angsd -b $POP_BAMLIST -ref $REF -out $WORK/Guppy/${POP_NAME} \
	-uniqueOnly 1 -remove_bads 1 -only_proper_pairs 1 -trim 0 -C 50 -baq 1 \
	-minMapQ 20 -minQ 20 -minInd 7 -setMinDepth 0 -setMaxDepth 219 -doCounts 1 \
	-GL 1 -doMajorMinor 1 -doMaf 1 -skipTriallelic 1 \
	-minMaf $MINMAF \
	-doGeno 32 -doPost 1 


#Get pos.txt and $NS
zcat $WORK/Guppy/${POP_NAME}.mafs.gz | cut -f 1,2 | tail -n +2 > $WORK/Guppy/${POP_NAME}_pos.txt
NS=`cat $WORK/Guppy/${POP_NAME}_pos.txt | wc -l`

#~ #Unzip geno file and run ngsLD
#~ echo "ngsLD BEGAN RUNNING AT"
#~ date
#~ gunzip -f $WORK/Guppy/${POP_NAME}.geno.gz
#~ $HOME/Packages/ngsLD/ngsLD --geno $WORK/Guppy/${POP_NAME}.geno --out ${POP_NAME}.ld --pos $WORK/Guppy/${POP_NAME}_pos.txt --n_ind $N_IND --n_sites $NS --verbose 1 --probs --max_kb_dist 1000 --min_maf $MINMAF
#~ mv ${POP_NAME}.ld $WORK/Guppy/

echo "SCRIPT RUN TO COMPLETION"


