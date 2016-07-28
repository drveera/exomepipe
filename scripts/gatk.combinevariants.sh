#!/bin/sh



source /com/extra/GATK/LATEST/load.sh
source /com/extra/java/8/load.sh

gatk -T CombineVariants \
     -V $1 \
     -o $2 \
     -R $3 \
      --assumeIdenticalSamples -genotypeMergeOptions UNSORTED

