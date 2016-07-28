#!/bin/sh

outdir=$1
gzlist=$2
reference=/home/veera/faststorage/resources/reference_genome/human.b37.fasta
chr=$3
mkdir $outdir/temp
mkdir $outdir/temp/java

tmpdir=$outdir/temp/java

source /com/extra/GATK/LATEST/load.sh
source /com/extra/java/8/load.sh

export _JAVA_OPTIONS="-Xmx64g -Xms12g  -Djava.io.tmpdir=$tmpdir"
gatk -T GenotypeGVCFs \
     -V $gzlist \
     -nt 8 \
     -R $reference \
     -L $chr \
     -o $outdir/Chrom$chr.final.output.vcf 

for i in `seq 22` X Y
do
    echo "hello $i"
done

