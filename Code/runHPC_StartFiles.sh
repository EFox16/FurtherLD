#!/bin/bash
#Creates the files needed for running the HPC. Must upload before running. 


#Run Values
NAME=Cnstnt
N_SAM=100 
N_REPS=1 
THETA=6000 
RHO=$THETA
N_SITES=10000000 
ERR_RATE=0.01


#Need to create a fast file with a reference sequence. Used to establish relative position of bases by a program in a later step. 
Rscript -e 'cat(">reference\n",paste(rep("A",1e6),sep="", collapse=""),"\n",sep="")' > reference.fa 

#Further formats the reference file
samtools faidx reference.fa #should give reference.fa.fai

#Create initial variable sites to work with
/usr/bin/ms $N_SAM $N_REPS -t $THETA -r $RHO $N_SITES > $NAME.txt
