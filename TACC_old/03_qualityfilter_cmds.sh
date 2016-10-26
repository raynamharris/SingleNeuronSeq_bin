#!/bin/bash
## This script will create a list of commands for running quality filter on every file in our directory

# move to directory with rad data
cd ../results/02_trimmedreads_2016-02-29/


## These are the fastq quality filter flags
## -Q for Illumina Data
## -q min quality score to keep
## -p Minimum percent of bases that must have -q quality
## -z compress the output
### Find help here with this documentation
### http://hannonlab.cshl.edu/fastx_toolkit/commandline.html#fastq_quality_filter_usage


#this will trim using the fastx toolkit on R1 and then the R2 reads
# I'm using basename function to create a new filename for the reads after filtering
for trimmed_read in *R1_001.trimmed.fastq
do
     filtered_read="$(basename $trimmed_read .fastq)_filtered.fastq.gz"
     echo $trimmed_read $filtered_read
     cat >> 03_qualityfilter.slurm <<EOF
fastq_quality_filter -Q 33 -q 20 -p 80 -z -i $trimmed_read -o $filtered_read
EOF
done






	
