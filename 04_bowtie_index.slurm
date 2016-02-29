#!/bin/bash

## A transcriptomics workflow for Bioinformatics for Research

#SBATCH -J bowtie # Job name
#SBATCH -o bowtie%j  # Name of stdout output file (%j expands to jobId)
#SBATCH -e bowtie_error.%j
#SBATCH -p 'normal'     # Queue name
#SBATCH -n 1   # Total number of  tasks requested
#SBATCH -t 24:00:00     # Run time (hh:mm:ss)
#SBATCH --mail-user rayna.harris@utexas.edu     # email to notify
#SBATCH --mail-type END # when to notify email
#SBATCH -A NeuroEthoEvoDevo     # Allocation name to charge job against

## USAGE: sbatch 04_bowtie_index.slurm

## Some indexes are available for download from here
## I've used this to download the rat and mouse genomes and indexes from http://ccb.jhu.edu/software/tophat/igenomes.shtml
#curl -O ftp://igenome:G3nom3s4u@ussd-ftp.illumina.com/Mus_musculus/UCSC/mm10/Mus_musculus_UCSC_mm10.tar.gz
#tar zxvf Mus_musculus_UCSC_mm10.tar.gz.tar.gz -C .

#curl -O ftp://igenome:G3nom3s4u@ussd-ftp.illumina.com/Rattus_norvegicus/UCSC/rn5/Rattus_norvegicus_UCSC_rn5.tar.gz
#tar zxvf Rattus_norvegicus_UCSC_rn5.tar.gz -C .


