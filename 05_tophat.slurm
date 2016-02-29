#!/bin/bash

## Tophat Pipeline

#SBATCH -J tophat # Job name
#SBATCH -o tophat.%j  # Name of stdout output file (%j expands to jobId)
#SBATCH -e tophat.error.%j
#SBATCH -p 'normal'     # Queue name
#SBATCH -n 1   # Total number of  tasks requested
#SBATCH -t 24:00:00     # Run time (hh:mm:ss)
#SBATCH --mail-user rayna.harris@utexas.edu     # email to notify
#SBATCH --mail-type END # when to notify email
#SBATCH -A NeuroEthoEvoDevo     # Allocation name to charge job against

## USAGE: sbatch 04_bowtie_index.slurm

module load bowtie/2.2.5
module load tophat/2.0.13

## Mouse ref index is here: data/reference_genomes/Mus_musculus/UCSC/mm10/Annotation/Archives/archive-2015-07-17-14-33-26/Genes/genes.gtf 
## Rat ref index is here: /work/02189/rmharris/SingleNeuronSeq/data/reference_genomes/Rattus_norvegicus/UCSC/rn5/Annotation/Archives/archive-current/Genes/genes.gtf 

# move to folder with trimmed reads
cd ../results/02_trimmedreads_2016-02-29

## loop through all R1 and R2 files to create R1s and R2s
for R1 in *R1_001.trimmed.fastq; do
    R2=$(basename $R1 R1_001.trimmed.fastq)R2_001.trimmed.fastq
    samp=$(basename $R1 _R1_001.trimmed.fastq)
    echo $R1 $R2 $samp
    tophat -p 2 -r 200 -G   /work/02189/rmharris/SingleNeuronSeq/data/reference_genomes/Mus_musculus/UCSC/mm10/Annotation/Genes/genes.gtf /work/02189/rmharris/SingleNeuronSeq/data/reference_genomes/Mus_musculus/UCSC/mm10/Sequence/Bowtie2Index/*.bt2 $R1 $R2
done 


 