
#Exomepipe
This is a pipeline for variant calling of exomes using GATK's best practices workflow.  In a nutshell, you input fastq files (or aligned bam files) and in just 3 steps, you get the vcf files. 

>**Note:** 
This pipeline is made to work inside the iPSYCH cluster environment where the required softwares and the resource files (GATK bundles) are readily available to the users. So the pipeline is fully functional only inside the iPSYCH cluster. If you would like to use the pipeline on your own system outside the iPSYCH cluster, please let me know.

------

##Main features of this pipeline 
- The workflow is scripted using GNU make and so there will be no unwanted repetition when you resubmit the jobs. Only those files that are required will be created and other files will be reused. This saves time and cluster resource. 
- The pipeline will submit the slurm jobs for you with appropriate settings and  will make sure effective utilization of cluster nodes. 



##Installation

####**Clone the repository**
`git clone https://github.com/veera-dr/exomepipe.git
`
####**run the install script (it just adds an alias inside bashprofile)**
`sh install.sh`


----------


##Quick reference

####**Step1** -  generate g.vcf files from fastq files
`exomepipe --fqlist <value> --outdir <value> --bed <value>`

####**Step2** - combine the g.vcf files
`exomepipe --gvcflist <value> --outdir <value>`

####**Step3** - genotype g.vcf files
`exomepipe --gzlist <value> --outdir <value>`


----------


##Step 1

####Usage
`exomepipe --fqlist <value> --outdir <value> --bed <value>`

or

`exomepipe --bamlist <value> --outdir <value> --bed <value>`

| Argument | Value                                                                   |
|----------|-------------------------------------------------------------------------|
| `--fqlist` | a file with the list of fastq files  |
| `--bamlist` | a file with the list of bam files  |
| `--outdir` | folder where you need the output                                        |
| `--bed`    | exome capture intervals                                                 |

> **always use full path when specifying the files or folders**

the fq files should have extension '.fq1'


##Step 2

####Usage
`exomepipe --gvcflist <value> --outdir <value>`

| Argument   | Value                                                      |
|------------|------------------------------------------------------------|
| --gvcflist | a file with the  list of g.vcf files generated from step 1 |
| --outdir   | folder where you need the output                           |

##Step 3

####Usage
`exomepipe --gzlist <value> --outdir <value>`

| Argument | Value                                                      |
|----------|------------------------------------------------------------|
| --gzlist | a file with the  list of g.vcf files generated from step 1 |
| --outdir | folder where you need the output                           |
