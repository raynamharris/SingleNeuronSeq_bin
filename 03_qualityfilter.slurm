#!/bin/bash

#SBATCH -J qualityfilter # Job name
#SBATCH -o qualityfilter.%j.out  # Name of stdout output file (%j expands to job$
#SBATCH -p 'normal'     # Queue name
#SBATCH -n 1   # Total number of  tasks requested
#SBATCH -N 1
#SBATCH -t 08:00:00     # Run time (hh:mm:ss)
#SBATCH --mail-user rayna.harris@utexas.edu     # email to notify
#SBATCH --mail-type END # when to notify email
#SBATCH -A NeuroEthoEvoDevo     # Allocation name to charge job against

## USAGE: sbatch 03_qualityfilter.slurm

module load fastqc
module load fastx_toolkit

# move to directory with rad data
cd ../data/JA16033/2016-02-10-trimmed_reads


#this will trim using the fastx toolkit on R1 reads
for R1 in *R1_001.trimmed.fastq"
do
     echo working with $R1
     newR1="$(basename $R1 .trimmed.fastq)"
     fastq_quality_filter -Q33 -q 30 -p 50 | gzip -9c > "${newR1}.trimmed_filtered.fastq.gz"
done

#this will trim using the fastx toolkit on R2 reads
for R2 in *R2_001.trimmed.fastq"
do
     echo working with $R2
     newR2="$(basename $R2 .trimmed.fastq)"
     fastq_quality_filter -Q33 -q 30 -p 50 | gzip -9c > "${newR2}.trimmed_filtered.fastq.gz"
done

mkdir 2016-02-26_trimmed_filtered
mv *trimmed_filtered.fastq.gz  2016-02-26_trimmed_filtered/





	

	
