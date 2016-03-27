#!/bin/bash

## this script creates a list of top hat commands to execute fore every file in the folder
## the outhput is a .cmds file that will be called in the 05_kallistoquant_launcher.slurm

## make output directory on scratch
## take care to edit this so that you don't delete old files
#rm -rf /scratch/02189/rmharris/SingleNeuronSeq/results/05_kallistoquant_ERCC92_2016-03-25
#mkdir /scratch/02189/rmharris/SingleNeuronSeq/results/05_kallistoquant_ERCC92_2016-03-25

rm -rf /scratch/02189/rmharris/SingleNeuronSeq/results/05_kallistoquant_MusUCSD_2016-03-25
mkdir /scratch/02189/rmharris/SingleNeuronSeq/results/05_kallistoquant_MusUCSD_2016-03-25


## the $WORKING_DIRECTORY
cd ../results/02_trimmedreads_2016-02-29


## in case there is an older version, let's delete the file, so we don't append to it
rm 05_kallistoquant_ERCC92.cmds
rm 05_kallistoquant_MusUCSD.cmds

## now, create 05_kallistoquant_cmds.cmds with all a kallisto quant command for each sample

## this for loop will append a tophat command for sample to 05_tophat_launcher.slurm
for R1 in *R1_001.trimmed.fastq; do
    R2=$(basename $R1 R1_001.trimmed.fastq)R2_001.trimmed.fastq
    samp=$(basename $R1 _R1_001.trimmed.fastq)
    echo $samp
    cat >> 05_kallistoquant_ERCC92.cmds <<EOF
kallisto quant -b 100 -i /work/02189/rmharris/SingleNeuronSeq/data/reference_genomes/ERCC92.idx  -o /scratch/02189/rmharris/SingleNeuronSeq/results/05_kallistoquant_ERCC92_2016-03-25/${samp} $R1 $R2
EOF
done

## this for loop will append a tophat command for sample to 05_tophat_launcher.slurm
for R1 in *R1_001.trimmed.fastq; do
    R2=$(basename $R1 R1_001.trimmed.fastq)R2_001.trimmed.fastq
    samp=$(basename $R1 _R1_001.trimmed.fastq)
    echo $samp
    cat >> 05_kallistoquant_MusUCSD.cmds <<EOF
kallisto quant -b 100 -i /work/02189/rmharris/SingleNeuronSeq/data/reference_genomes/gencode.vM7.transcripts.idx  -o /scratch/02189/rmharris/SingleNeuronSeq/results/05_kallistoquant_MusUCSD_2016-03-25/${samp} $R1 $R2
EOF
done

## check number of lines in commands file
wc 05_kallistoquant_ERCC92.cmds
wc 05_kallistoquant_MusUCSD.cmds 

## now this makes a new file. to execute the follow command from bin
## edit the 05_kallistoquant_launcher.slurm script  then launch
# sbatch 05_kallistoquant_launcher.slurm  






