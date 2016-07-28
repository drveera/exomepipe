#!/bin/sh

mainlist=$1
scriptdir=`dirname $0`

gvcflist=`basename $1`
split -l 50 $mainlist $outdir/temp/batch

ls $outdir/temp/batch* > $outdir/temp/batch.list


while read batch
do
    batchname=`basename $batch`
    
    for chr in `seq 22`
    do
	while read gvcf
	do
	    echo "sh $scriptdir/gatk.selectvariants.sh $chr $gvcf $outdir $batchname "
	done < $batch > $outdir/temp/$batchname.chr$chr.adispatch

	#submit the job
	$batchname.combine.job= `adispatch -p normal --mem=8g -c 1 --time=10:00:00 $outdir/temp/$batchname.chr$chr.adispatch | awk '{print $NF}'`
	#once all the jobs are done, combine them
	echo "sh $scriptdir/gatk.combine.gvcf.sh $chr $batchname $outdir" > $outdir/temp/$batchname.$chr.combine.sbatch

    done
    
    echo "" > $outdir/temp/$batchname.allchrom.combine.sbatch
    #submit the job
    
done < $outdir/temp/batch.list
