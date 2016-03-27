#!/bin/bash

## this script creates a list of top hat commands to execute fore every file in the folder
## the outhput is a .cmds file that will be called in the 06_samtools_launcher.slurm

#move to folder with mapped tophat reads
cd /scratch/02189/rmharris/SingleNeuronSeq/results/05_tophat_2016-03-02/

## in case there is an older version, let's delete the file, so we don't append to it
rm 06_cufflinks_cmds.cmds

## create 06_samtools_sort_cmds.cmds with all the sort and index commands

for mapped_reads in */*accepted_hits.bam; do
    echo $mapped_reads 
    cat >> 06_cufflinks_cmds.cmds <<EOF
cufflinks -g /work/02189/rmharris/SingleNeuronSeq/data/reference_genomes/Mus_musculus/UCSC/mm10/Annotation/Genes/genes.gtf $mapped_reads
EOF
done

## check number of lines in commands file
wc -l 06_cufflinks_cmds.cmds

## to execute 06_cufflinks_cmds.cmds
## edit the 06_cufflinks_launcher.slurm script  then launch
# sbatch 06_cufflinks_launcher.slurm  


