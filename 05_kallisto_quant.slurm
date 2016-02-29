#!/bin/bash

## Pseudo Aligning and Counting reads with Kallisto Quant

#SBATCH -J kallisto_quant # Job name
#SBATCH -o kallisto_quant.out.%j # Name of stdout output file (%j expands to job$
#SBATCH -e kallisto_quant.error.%j   # Name of stdout error file
#SBATCH -p 'normal'     # Queue name
#SBATCH -n 16   # Total number of  tasks requested
#SBATCH -t 24:00:00     # Run time (hh:mm:ss)
#SBATCH --mail-user=rayna.harris@utexas.edu     # email to notify
#SBATCH --mail-type=END # when to notify email
#SBATCH -A NeuroEthoEvoDevo     # Allocation name to charge job against

## USAGE: sbatch 05_kallisto_quant.slurm

module use /work/03439/wallen/public/modulefiles
module swap intel gcc/4.9.1
module load hdf5/1.8.15
module load zlib/1.2.8
module load gcc/4.9.1
module load kallisto

## move to directory with reads to be psudomapped 

cd ../results/02_trimmedreads_2016-02-29
mkdir 05_kallistoquant_trimmedreads_2016_02-29

## check that the file names match

## loop through all R1 and R2 files to create R1s and R2s
for R1 in *R1_001.trimmed.fastq; do
    R2=$(basename $R1 R1_001.trimmed.fastq)R2_001.trimmed.fastq
    samp=$(basename $R1 _R1_001.trimmed.fastq)
    echo $R1 $R2 $samp
    kallisto quant -i /work/02189/rmharris/SingleNeuronSeq/data/reference_genomes/combo.idx -o 05_kallistoquant_trimmedreads_2016_02-29/${samp} $R1 $R2
done    
    
mv 2016-02-28_trimmed_reads_kallisto_quant ../




