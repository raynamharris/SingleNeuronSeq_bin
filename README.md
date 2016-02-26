# SingleNeuronSeq
Rayna M Harris
Last edited Feb 18, 2016

This directory contains only the scripts used for data analysis. Data and results are  stored elsewhere. 

The current scripts and order of operations are:

01_gsaf_download.sh
02_trimreads.slurm
03_qualityfilter.slurm
04_kallisto.index.slurm
05_run_kallisto.slurm
06_kallisto_gather.R
07_dplyrmutate.R
08_ERCC_counts.R
09_DESeq.R


**01_gsaf_download.sh**
Getting data from the cloud

**02_trimreads.slurm**
Trimming reads with cutadapt

**03_qualityfilter.slurm**
Filtering reads with Fastxtoolki

**04_kallisto.index.slurm**
Building a reference index from an exising reference genome

**05_run_kallisto.slurm**
Pseudomapping reads to the kallisto index

**06_kallisto_gather.R**
Gathing the data from individual abundance.tsv files into a single counts fie

**07_dplyrmutate.R**
Wrangling the data

08_ERCC_counts.R
Checking the quality of reads by way of our ERCC counts

09_DESeq.R
Analyzing differential gene expression