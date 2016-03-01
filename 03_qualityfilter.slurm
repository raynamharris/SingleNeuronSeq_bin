#!/bin/bash

#SBATCH -J qualityfilter # Job name
#SBATCH -o qualityfilter.%j.out  # Name of stdout output file (%j expands to job$
#SBATCH -p 'normal'     # Queue name
#SBATCH -n 4   # Total number of  tasks requested
#SBATCH -N 4
#SBATCH -t 01:00:00     # Run time (hh:mm:ss)
#SBATCH --mail-user rayna.harris@utexas.edu     # email to notify
#SBATCH --mail-type END # when to notify email
#SBATCH -A NeuroEthoEvoDevo     # Allocation name to charge job against

## USAGE: sbatch 03_qualityfilter.slurm

module load fastqc
module load fastx_toolkit

# move to directory with rad data
cd ../results/02_trimmedreads_2016-02-29/temp

## -Q for Illumina Data
## -q min quality score to keep
## -p Minimum percent of bases that must have -q quality
## -z compress the output

#this will trim using the fastx toolkit on R1 and then the R2 reads
for R1 in *R1_001.trimmed.fastq
do
     filteredR1="$(basename $R1 .fastq)_filtered.fastq.gz"
     echo $R1 $filteredR1
     fastq_quality_filter -Q 33 -q 20 -p 80 -z -i $R1 -o $filteredR1
done

for R2 in *R2_001.trimmed.fastq
do
     filteredR2="$(basename $R2 .fastq)_filtered.fastq.gz"
     echo $R2 $filteredR2
     fastq_quality_filter -Q 33 -q 20 -p 50 -z -i $R2 -o $filteredR2
done

#mkdir 03_trimmed_filtered_2016-03-01
#mv *trimmed_filtered.fastq.gz  03_trimmed_filtered_2016-03-01
#mv 03_trimmed_filtered_2016-03-01/ ..

### Find help here with this documentation
### http://hannonlab.cshl.edu/fastx_toolkit/commandline.html#fastq_quality_filter_usage




	
