#!/bin/bash

## A transcriptomics workflow for Bioinformatics for Research

#SBATCH -J index # Job name
#SBATCH -o index.%j.out  # Name of stdout output file (%j expands to jobId)
#SBATCH -e index.%j.e  # Name of stdout errpr file (%j expands to jobId)
#SBATCH -p 'normal'     # Queue name
#SBATCH -n 32   # Total number of  tasks requested
#SBATCH -t 24:00:00     # Run time (hh:mm:ss)
#SBATCH --mail-user rayna.harris@utexas.edu     # email to notify
#SBATCH --mail-type END # when to notify email
#SBATCH -A NeuroEthoEvoDevo     # Allocation name to charge job against

## USAGE: sbatch 04_kallisto.index.slurm

## kallisto is installed in W. Joe Allen's public space.
## then load other required modules
module use -a /work/03439/wallen/public/modulefiles
module load gcc/4.9.1
module load hdf5/1.8.15
module load zlib/1.2.8
module load kallisto/0.42.3

## move to directory with genomes
cd /work/02189/rmharris/SingleNeuronSeq/data/reference_genomes ## only for  mouse
#cd /scratch/02189/rmharris/Cborealis_ref # for C. borealis genomes

## download reference genome from the internet

## the first mouse one I used
# curl -O  ftp.sanger.ac.uk/pub/gencode/Gencode_mouse/release_M7/gencode.vM7.transcripts.fa.gz

## a different mouse reference
# curl -O ftp://igenome:G3nom3s4u@ftp.illumina.com/Mus_musculus/UCSC/mm10/Mus_musculus_UCSC_mm10.tar.gz

## a rat reference
# curl -O ftp://igenome:G3nom3s4u@ftp.illumina.com/Rattus_norvegicus/UCSC/rn5/Rattus_norvegicus_UCSC_rn5.tar.gz


## Build the kallisto index
# usage: kallisto index -i <kallistoindexname.idx> <genomefilename.fa>

# used this to make the mouse genome index
# kallisto index -i gencode.vM7.transcripts.idx gencode.vM7.transcripts.fa

# used this to make the ERCC "genome"
# kallisto index -i ERCC92.idx ERCC92.fa

# used this to make a "combo" index wiht both the rat genome and the ERCC "genome"
# cat gencode.vM7.transcripts.fa ERCC92.fa > combo.fa
# kallisto index -i combo.idx combo.fa

# used this to make the C. borealis cds transcriptome and candidate gene indeces
#kallisto index -i Cborealis_candidategenes.idx SchulzD_Cb_CDS_CHR.fasta
#kallisto index -i Cborealis_transcriptome.idx Cborealis_ref.fa

# used to make the mouse candidate gene transcriptome
kallisto index -i gencode.vM7.transcripts_candidategenes.idx gencode.vM7.transcripts_candidategenes.fa
