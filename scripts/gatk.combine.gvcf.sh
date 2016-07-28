#!/bin/sh


#required softwares


#gatk

#variables


source /com/extra/GATK/LATEST/load.sh
source /com/extra/java/8/load.sh



gatk -T CombineGVCFs \
     -V $1 \
     -o $2 \
     -R $3






