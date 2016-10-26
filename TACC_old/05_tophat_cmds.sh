#!/bin/bash

## this script creates a list of top hat commands to execute fore every file in the folder
## the outhput is a .cmds file that will be called in the 05_tophat_launcher.slurm

#move to folder with trimmed filtere reads
cd ../results/03_trimmedreads_filtered_2016-03-02

## in case there is an older version, let's delete the file, so we don't append to it
rm 05_tophat_cmds.cmds

## now, create 05_tophat_cmds.cmds with all the tophat commands

## this for loop will append a tophat command for sample to 05_tophat_launcher.slurm
for R1 in *R1_001.trimmed_filtered.fastq.gz; do
    R2=$(basename $R1 R1_001.trimmed_filtered.fastq.gz)R2_001.trimmed_filtered.fastq.gz
    samp=$(basename $R1 _R1_001.trimmed_filtered.fastq.gz)
    echo $R1 $R2 $samp
    cat >> 05_tophat_cmds.cmds <<EOF
tophat -p 2 -G /work/02189/rmharris/SingleNeuronSeq/data/reference_genomes/Mus_musculus/UCSC/mm10/Annotation/Genes/genes.gtf -o /scratch/02189/rmharris/SingleNeuronSeq/results/05_tophat_2016-03-02/${samp}/ /work/02189/rmharris/SingleNeuronSeq/data/reference_genomes/Mus_musculus/UCSC/mm10/Sequence/Bowtie2Index/genome $R1 $R2
EOF
done

## check number of lines in commands file
wc -l 05_tophat_cmds.cmds 

## now this makes a new file. to execute the follow command from bin
## edit the 05_tophat_launcher.slurm script  then launch
# sbatch 05_tophat_launcher.slurm  






