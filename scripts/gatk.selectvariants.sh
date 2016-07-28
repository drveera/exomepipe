#!/bin/sh

#required softwares


#gatk

#variables

gvcf=$1
chr=$2
outfile=$3
reference=$4

source /com/extra/GATK/LATEST/load.sh
source /com/extra/java/8/load.sh
gatk -T SelectVariants \
     -L $chr \
     -V $gvcf \
     -o $outfile \
     -R $reference
