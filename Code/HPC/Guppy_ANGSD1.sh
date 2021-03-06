#!/bin/bash
#PBS -l walltime=47:30:00
#PBS -lselect=1:ncpus=1:mem=199gb 

module load intel-suite
module load gsl
module load htslib

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

$HOME/Packages/angsd/angsd -b $POP_BAMLIST -ref $REF -out $WORK/Guppy/${POP_NAME}.qc \
	-uniqueOnly 1 -remove_bads 1 -only_proper_pairs 1 -trim 0 -C 50 -baq 1 \
	-minMapQ 20 -minQ 0 \
	-doQsDist 1 -doDepth 1 -doCounts 1 -maxDepth 1000 
	
echo "SCRIPT RUN TO COMPLETION"
