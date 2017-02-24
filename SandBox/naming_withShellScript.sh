#!/bin/bash
# Author: Emma Fox e.fox16@imperial.ac.uk
# Script: naming_withShellScript.sh

echo "NAMES"
echo $1

SET_NAME=$1
echo $SET_NAME

echo "EXTENSIONS"
echo $1.qrs
echo $SET_NAME.qrs

echo "UNDERSCORES"
echo $1_qrs
echo $SET_NAME_qrs

echo "LOOPS"
for i in 1 2 3
do
	echo $1_reads$i_bin.glf.gz
done
