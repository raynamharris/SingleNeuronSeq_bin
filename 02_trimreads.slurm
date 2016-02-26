#!/bin/bash

#SBATCH -J trimreads # Job name
#SBATCH -o trimreads%j.out  # Name of stdout output file (%j expands to job$
#SBATCH -p 'normal'     # Queue name
#SBATCH -n 1   # Total number of  tasks requested
#SBATCH -N 1
#SBATCH -t 08:00:00     # Run time (hh:mm:ss)
#SBATCH --mail-user rayna.harris@utexas.edu     # email to notify
#SBATCH --mail-type END # when to notify email
#SBATCH -A NeuroEthoEvoDevo     # Allocation name to charge job against

## USAGE: sbatch trimreads.slurm

# move to directory with raw reads
cd ../data/JA16033/2016-02-04-raw_reads

#this just test to make sure the renaming and name calling is working
for R1 in *R1_001.fastq.gz 
do
     	echo $R1
     	newR1="$(basename $R1 .fastq.gz)"
     	echo $newR1
     	R2="$(basename $R1 R1_001.fastq.gz)R2_001.fastq.gz"
     	echo $R2
     	newR2="$(basename $R2 .fastq.gz)"
     	echo $newR2
     	echo "${newR1}.trimmed.fastq"
     	echo "${newR2}.trimmed.fastq"
done 

#this will perform cutadapt on paired end reads
for R1 in *R1_001.fastq.gz
do
     echo working with $R1
     newR1="$(basename $R1 .fastq.gz)"
     R2="$(basename $R1 R1_001.fastq.gz)R2_001.fastq.gz"
     newR2="$(basename $R2 .fastq.gz)"
     cutadapt -a GATCGGAAGAGCACACGTCTGAACTCCA -A ATCGTCGGACTGTAGAACTCTGAACGTG -m 22 -o  "${newR1}.trimmed.fastq" -p "${newR2}.trimmed.fastq" $R1 $R2 
done

#move files to new directory
mv *.trimmed.fastq 2016-02-10-trimmed_reads/