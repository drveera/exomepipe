#!/bin/sh

OPTS=`getopt -o h -l read1:,read2:,sample:,gbundle:,outdir:,fqlist:,bamlist:,bed:,gvcflist:,gzlist: -n "exomepipe" -- "$@"`

eval set -- "$OPTS"
helpmessage(){
    echo "
USAGE:
1. If you want to run a single sample:
exomepipe --read1 <fastq1> --read2 <fastq2> --bed <capture interval file> --sample <outfilename> --outdir <output folder>

2. If you want to run multiple fastq files:
exomepipe --fqlist <list file> --outdir <outfolder> --bed <capture file>

3. If you want to run multiple bam files:
exomepipe --bamlist <list file> --outdir <outfolder> --bed <capture file>

OPTIONS:
--read1 <fastq1>
--read2 <fastq2>
--sample <samplename>
--outdir <dir>
--fqlist <file with list of fq files, 2 columns column1 with read1 and column2 with read2>
--bamlist <file with list of bam files>
--bed <capture interval in bed format>
--gvcflist <file with list of gvcf files>
--gzlist <file with list of gz files>"
}

while true; do
    case "$1" in
	--read1) read1=$2; shift 2;;
	--read2) read2=$2; shift 2;;
	--sample) sample=$2; shift 2;;
	--gbundle) gbundle=$2; shift 2;; #this is defined by default; user can specify a different bundle location if they want
	--outdir) outdir=$2; shift 2;;
	--fqlist) fqlist=$2; shift 2;;
	--bamlist) bamlist=$2; shift 2;;
	--bed) bed=$2; shift 2;;
	--gvcflist) gvcflist=$2; shift 2;;
	--gzlist) gzlist=$2; shift 2;;
	-h | --help) helpmessage; exit 1; shift ;; 
#	--) echo "type -h for help"; shift; break;;
	*) break ;;
    esac
done


#loaction of the scripts

scriptdir=`dirname $0`


if [ ! -z $fqlist ];
then
    
    if [ -z $outdir ];
    then
	echo "specify the output folder --outdir"
	exit 1
    fi

    if [ -z $bed ];
    then
	echo "capture interval?"
	exit 1
    fi
    
    
    while read fq
    do

	r1=$fq
	r2=`echo "$fq" | awk '{gsub("1.fq.gz","2.fq.gz"); print}'`

	#sample=`echo "$fq" | awk '{gsub("/","."); print}' | awk '{gsub("^.",""); print}' | awk '{gsub("_1.fq.gz",""); print}'`
	sample=$(basename $fq)_folder
	echo "$sample"
	echo "sh $scriptdir/exome.pipeline.sh --read1 $r1 --read2 $r2 --sample $sample --outdir $outdir --bed $bed" >> exome.job.adispatch
    done < $fqlist
fi


if [ ! -z $read1 ];
then

    if [ -z $read2 ];
    then
	echo "specify the read files --read2"
	exit 1
    fi

    if [ -z $sample ];
    then
	echo "specify the name of the sample --sample"
	exit 1
    fi

    if [ -z $outdir ];
    then
	echo "specify the output directory"
	exit 1
    fi

   echo "#!/bin/sh
sh $scriptdir/exome.pipeline.sh --read1 $read1 --read2 $read2 --sample $sample --outdir $outdir" > $sample.job
fi

if [ ! -z $bamlist ];
then
    if [ -z $outdir ];
    then
	echo "specify the output folder --outdir"
	exit 1
    fi

    if [ -z $bed ];
    then
	echo "capture interval?"
	exit 1
    fi

    if [ -z $dryrun ];
       
    then
    while read bam
    do
	#sample=`echo "$bam" | awk '{gsub("/","."); print}' | awk '{gsub("^.",""); print}' | awk '{gsub(".bam",""); print}'`
	sample=$(basename $bam)_folder
	echo "sh $scriptdir/exome.pipeline.sh --sample $sample --outdir $outdir --bamfile $bam --bed $bed " 
    done < $bamlist > job1.adispatch
    
    else
	while read bam
	do
	    #sample=`echo "$bam" | awk '{gsub("/","."); print}' | awk '{gsub("^.",""); print}' | awk '{gsub(".bam",""); print}'`
	    sample=$(basename $bam)_folder
	    sh $scriptdir/exome.pipeline.sh --sample $sample --outdir $outdir --bamfile $bam --bed $bed --dryrun
	    exit 1 
	done < $bamlist
   fi
      
fi

if [ ! -z $gvcflist ];
then
    if [ -z $outdir ];
    then
	echo "specify the --outdir"
	exit 1
    fi
    
	sh $scriptdir/combine.gvcfs.sh $gvcflist $outdir
fi


if [ ! -z $gzlist ];
then
    if [ -z $outdir ];
    then
	echo "specify the --outdir"
	exit 1
    fi

    for chr in X Y MT
    do
	echo "sh $scriptdir/genotype.gvcf.sh $outdir $gzlist $chr" | adispatch -p normal --mem=32g -c 16 --time=48:00:00 -
    done        
fi
