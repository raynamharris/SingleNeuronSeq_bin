#!/bin/bash

## this script creates a kallistoquant command for every file in the working direcotry
## the outhput is a .cmds file that is referenced in 05_kallistoquant_launcher.slurm

## make output directory on scratch
mkdir /scratch/02189/rmharris/SingleNeuronSeq/results/JA16393/2016-06-27-kallistoquant-cds


## the $WORKDIR
cd /work/02189/rmharris/IntMolModule/STG/data/2016-06-27-JA16393


## now, create 2016-06-27-kallistoquant-cds.cmds 

for R1 in *R1_001.fastq.gz; do
    R2=$(basename $R1 R1_001.fastq.gz)R2_001.fastq.gz
    samp=$(basename $R1 _R1_001.fastq.gz)
    echo $R1 $R2 $samp
    cat >> 2016-06-27-kallistoquant-cds.cmds <<EOF
kallisto quant -b 100 -i /scratch/02189/rmharris/Cborealis_ref/Cborealis_candidategenes.idx  -o /scratch/02189/rmharris/SingleNeuronSeq/results/JA16393/2016-06-27-kallistoquant-cds/${samp} $R1 $R2
EOF
done


## check number of lines in commands file
wc 2016-06-27-kallistoquant-cds.cmds

