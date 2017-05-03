#!/bin/bash
#PBS -l walltime=03:00:00
#PBS -lselect=1:ncpus=8:mem=230gb 

module load intel-suite
module load python

echo -e "\nIndexing begun at..."
date

$HOME/Packages/HISAT2/hisat2-build --ss $WORK/Ap.ss --exon $WORK/Ap.exon $WORK/Ap.fa $WORK/Ap_db

echo -e "\nINDEXING RAN TO COMPLETION"

