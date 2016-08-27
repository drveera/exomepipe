#!/bin/sh

OPTS=`getopt -o h -l read1:,read2:,sample:,gbundle:,outdir:,bed:,bamfile:,options: -n "exomepipe" -- "$@"`

eval set -- "$OPTS"
helpmessage(){
    echo "This is a help message"
}

while true; do
    case "$1" in
	--read1) read1=$2; shift 2;;
	--read2) read2=$2; shift 2;;
	--sample) sample=$2; shift 2;;
	--gbundle) gbundle=$2; shift 2;; #this is defined by default; user can specify a different bundle location if they want
	--outdir) outdir=$2; shift 2;;
	--bed) bed=$2; shift 2;;
	--bamfile) bamfile=$2; shift 2;;
	--options) options=$2; shift 2;;
	-h | --help) helpmessage; exit 1; shift ;; 
	--) echo "type -h for help"; shift; break;;
	*) break ;;
    esac
done
		       
#required softwares
#bwa, picard, GATK, R

#source the required softwares  
source /com/extra/R/LATEST/load.sh
source /com/extra/picard/LATEST/load.sh
source /com/extra/bwa/LATEST/load.sh
source /com/extra/GATK/LATEST/load.sh
source /com/extra/java/8/load.sh

#export java settings

mkdir $outdir/$sample
mkdir $outdir/$sample/tmp #to store java temp files

tmpdir=$outdir/$sample/tmp

export _JAVA_OPTIONS="-Xmx16g -Xms8g -Djava.io.tmpdir=$tmpdir"


mkdir $outdir/$sample/bwa
mkdir $outdir/$sample/gatk
mkdir $outdir/$sample/picard

scriptdir=`dirname $0`
if [ ! -z $read1 ];
then
    make -f $scriptdir/Makefile.fqmode $outdir/$sample/gatk/$sample.raw.snps.indels.g.VCF sample=$sample read1=$read1 read2=$read2 outdir=$outdir/$sample tmpdir=$tmpdir bed=$bed bamfile=$bamfile $options
fi

if [ ! -z $bamfile ];
then
    make -f $scriptdir/Makefile.bammode $outdir/$sample/gatk/$sample.raw.snps.indels.g.VCF sample=$sample outdir=$outdir/$sample tmpdir=$tmpdir bed=$bed bamfile=$bamfile $options
fi


