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
cd ../results/02_trimmedreads_2016-02-29

#this will trim using the fastx toolkit on R1 and then the R2 reads
for R1 in *R1_001.trimmed.fastq"
do
     echo working with $R1
     filteredR1="$(basename $R1 fastq).filtered.fastq"
     fastq_quality_filter -q 30 -p 50 -z -i $R1 -o $filteredR1
done

for R2 in *R2_001.trimmed.fastq"
do
     echo working with $R2
     filteredR2="$(basename $R2 fastq).filtered.fastq"
     fastq_quality_filter -q 30 -p 50 -z -i $R2 -o $filteredR2
done

mkdir 03_trimmed_filtered_2016-02-29
mv *trimmed_filtered.fastq.gz  03_trimmed_filtered_2016-02-29
mv 03_trimmed_filtered_2016-02-29/ ..





	

	
