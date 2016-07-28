#!/bin/sh


gvcflist=$1
outdir=$2
scriptdir=`dirname $0`
reference=/home/veera/faststorage/resources/reference_genome/human.b37.fasta

gvcflistname=`basename $gvcflist`


mkdir $outdir/temp


#split the list in to chunks of 50 lines
split -l 50 $gvcflist $outdir/$gvcflistname.split

#make a list of split files 
ls $outdir/$gvcflistname.split* > $outdir/$gvcflistname.split.list

while read list
do
    batch=`basename $list`
    for chr in X Y MT 
    do
	while read gvcf
	do
	    outname=`basename $gvcf`
	    outfile=$outdir/temp/$outname.$batch.chr$chr.g.VCF
	    echo "sh $scriptdir/gatk.selectvariants.sh $gvcf $chr $outfile $reference"
	done < $list >> $outdir/$batch.selectvariants.adispatch 

	echo "ls $outdir/temp/*.$batch.chr$chr.g.VCF > $outdir/$batch.$chr.list" >> $outdir/$batch.list1.adispatch
	echo "sh $scriptdir/gatk.combine.gvcf.sh $outdir/$batch.$chr.list $outdir/temp/$batch.chr$chr.combined.g.VCF.gz $reference" >> $outdir/$batch.combine.gvcf.adispatch 
	
    done
    echo "ls $outdir/temp/$batch*combined.g.VCF.gz > $outdir/$batch.list" >> $outdir/$batch.list2.adispatch
    echo "sh $scriptdir/gatk.combinevariants.sh $outdir/$batch.list $outdir/$batch.final.g.VCF.gz $reference" >> $outdir/$batch.combinevariants.adispatch

    
    job1id=`adispatch $outdir/$batch.selectvariants.adispatch | awk '{print $NF}'`
    job2id=`adispatch --dependency=afterok:$job1id $outdir/$batch.list1.adispatch | awk '{print $NF}'`
    job3id=`adispatch --dependency=afterok:$job2id --mem=32g --time=48:00:00 $outdir/$batch.combine.gvcf.adispatch | awk '{print $NF}'`
    job4id=`adispatch --dependency=afterok:$job3id $outdir/$batch.list2.adispatch | awk '{print $NF}'`
    job5id=`adispatch  --dependency=afterok:$job4id --mem=32g --time=48:00:00 $outdir/$batch.combinevariants.adispatch | awk '{print $NF}'`

done < $outdir/$gvcflistname.split.list

