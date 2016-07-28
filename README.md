#Exome pipe

A pipeline for variant calling exome/whole genome using GATK best practices workflow

##Exomepipe

*Note: This pipeline is made to work inside the iPSYCH cluster environment and so will work fully only if you are part of the iPSYCH community and have access to the cluster.*

If you would like to use this outside the iPSYCH cluster, let me know

##Installation

####Clone the repository
`git clone https://github.com/veera-dr/exomepipe.git
`
####run the install script (it just adds an alias inside bashprofile)
`sh install.sh`

##Quick start

###Step1 -  generate g.vcf files from fastq files
`exomepipe --fqlist <value> --outdir <value> --bed <value>`

###Step2 - combine the g.vcf files
`exomepipe --gvcflist <value> --outdir <value>`

###Step3 - genotype g.vcf files
`exomepipe --gzlist <value> --outdir <value>`

