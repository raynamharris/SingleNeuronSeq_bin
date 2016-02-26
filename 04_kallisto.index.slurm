#!/bin/bash

## A transcriptomics workflow for Bioinformatics for Research

#SBATCH -J index # Job name
#SBATCH -o index.%j.out  # Name of stdout output file (%j expands to jobId)
#SBATCH -p 'normal'     # Queue name
#SBATCH -n 32   # Total number of  tasks requested
#SBATCH -t 01:05:00     # Run time (hh:mm:ss)
#SBATCH --mail-user rayna.harris@utexas.edu     # email to notify
#SBATCH --mail-type END # when to notify email
#SBATCH -A NeuroEthoEvoDevo     # Allocation name to charge job against

## USAGE: sbatch 04_kallisto.index.slurm

# kallisto is installed in W. Joe Allen's public space.
# then load other required modules
module use -a /work/03439/wallen/public/modulefiles
module load gcc/4.9.1
module load hdf5/1.8.15
module load zlib/1.2.8
module load kallisto/0.42.3

# move to directory with genomes
cd ../data/reference_genomes

# usage: kallisto index -i <kallistoindexname.idx> <genomefilename.fa>
# this makes the rat genome index
# kallisto index -i gencode.vM7.transcripts.idx gencode.vM7.transcripts.fa

# this makes jsut the ERCC "genome"
# kallisto index -i ERCC92.idx ERCC92.fa

# this makes an "combo" index wiht both the rat genome and the ERCC "genome"
cat gencode.vM7.transcripts.fa ERCC92.fa > combo.fa
kallisto index -i combo.idx combo.fa
