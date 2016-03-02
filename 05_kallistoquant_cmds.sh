#!/bin/bash

## this script creates a list of top hat commands to execute fore every file in the folder
## the outhput is a .cmds file that will be called in the 05_kallistoquant_launcher.slurm

## make output directory on scratch
mkdir /scratch/02189/rmharris/results_scratch/05_kallistoquant_2016-03-02

## the $WORKING_DIRECTORY
cd ../results/03_trimmedreads_filtered_2016-03-02


## in case there is an older version, let's delete the file, so we don't append to it
rm 05_kallistoquant_cmds.cmds

## now, create 05_kallistoquant_cmds.cmds with all a kallisto quant command for each sample

## this for loop will append a tophat command for sample to 05_tophat_launcher.slurm
for R1 in *R1_001.trimmed_filtered.fastq.gz; do
    R2=$(basename $R1 R1_001.trimmed_filtered.fastq.gz)R2_001.trimmed_filtered.fastq.gz
    samp=$(basename $R1 _R1_001.trimmed_filtered.fastq.gz)
    echo $R1 $R2 $samp
    cat >> 05_kallistoquant_cmds.cmds <<EOF
kallisto quant -i /work/02189/rmharris/SingleNeuronSeq/data/reference_genomes/combo.idx -o /scratch/02189/rmharris/results_scratch/05_kallistoquant_2016-03-02/${samp} $R1 $R2
EOF
done

## check number of lines in commands file
wc 05_kallistoquant_cmds.cmds 

## now this makes a new file. to execute the follow command from bin
## edit the 05_kallistoquant_launcher.slurm script  then launch
# sbatch 05_kallistoquant_launcher.slurm  





