#!/bin/bash

#SBATCH -J trimreads # Job name
#SBATCH -o trimreads.out.%j  # Name of stdout output file (%j expands to job$
#SBATCH -e trimreads.error.%j
#SBATCH -p 'normal'     # Queue name
#SBATCH -n 1   # Total number of  tasks requested
#SBATCH -N 1
#SBATCH -t 08:00:00     # Run time (hh:mm:ss)
#SBATCH --mail-user rayna.harris@utexas.edu     # email to notify
#SBATCH --mail-type END # when to notify email
#SBATCH -A NeuroEthoEvoDevo     # Allocation name to charge job against

## USAGE: sbatch trimreads.slurm

## make a results directory 
mkdir ../results/02_trimmedreads_2016-02-29

## move to directory with JA16033 raw reads, loop over R1s, make new variabiles for R2 and output files for all treimmed reads, move files into results
cd ../data/JA16033/2016-02-04-raw_reads
for R1 in *R1_001.fastq.gz 
do
     	trimmedR1="$(basename $R1 .fastq.gz).trimmed.fastq"
     	echo $R1 $trimmedR1
     	R2="$(basename $R1 R1_001.fastq.gz)R2_001.fastq.gz"
     	trimmedR2="$(basename $R2 .fastq.gz).trimmed.fastq"
     	echo $R2 $trimmedR2
     	cutadapt -a GATCGGAAGAGCACACGTCTGAACTCCA -A ATCGTCGGACTGTAGAACTCTGAACGTG -m 22 -o  $trimmedR1 -p trimmedR2 $R1 $R2 
done
mv *.trimmed.fastq ../../../results/2016-02-10-trimmed_reads/


## move to directory with JA15597 raw reads, loop over R1s, make new variabiles for R2 and output files for all treimmed reads, move files into results
cd ../../JA15597
for R1 in *R1_001.fastq.gz 
do
     	trimmedR1="$(basename $R1 .fastq.gz).trimmed.fastq"
     	echo $R1 $trimmedR1
     	R2="$(basename $R1 R1_001.fastq.gz)R2_001.fastq.gz"
     	trimmedR2="$(basename $R2 .fastq.gz).trimmed.fastq"
     	echo $R2 $trimmedR2
     	cutadapt -a GATCGGAAGAGCACACGTCTGAACTCCA -A ATCGTCGGACTGTAGAACTCTGAACGTG -m 22 -o  $trimmedR1 -p trimmedR2 $R1 $R2 
done
mv *.trimmed.fastq ../../results/2016-02-10-trimmed_reads/
