#!/bin/bash

## this script creates a list of kallisto commands 
## the outhput is a .cmds file that will be called in the 05_kallistopseudo_launcher.slurm

## make output directory on scratch
mkdir /scratch/02189/rmharris/SingleNeuronSeq/JA16268/2016-06-04-05-Cborealis-transcriptome-kallisto_pseudo


## the $WORKING_DIRECTORY
cd /scratch/02189/rmharris/SingleNeuronSeq/JA16268/2016-05-24-trimmedreads


## in case there is an older version, let's delete the file, so we don't append to it
rm 05_kallistopseudo_Cborealis_transcriptome.cmds



## this for loop will append a kallisto quant command for sample to 05_kallistoquant_Cborealis_transcriptome.cmds
for R1 in PD*R1_001.trimmed.fastq GM*R1_001.trimmed.fastq; do
    R2=$(basename $R1 R1_001.trimmed.fastq)R2_001.trimmed.fastq
    samp=$(basename $R1 _R1_001.trimmed.fastq)
    echo $R1 $R2 $samp
    cat >> 05_kallistopseudo_Cborealis_transcriptome.cmds <<EOF
kallisto pseudo -i /scratch/02189/rmharris/Cborealis_ref/Cborealis_transcriptome.idx  -o /scratch/02189/rmharris/SingleNeuronSeq/JA16268//scratch/02189/rmharris/SingleNeuronSeq/JA16268/2016-06-04-05-Cborealis-transcriptome-kallisto_pseudo/${samp} $R1 $R2
EOF
done

## check number of lines in commands file
wc 05_kallistopseudo_Cborealis_transcriptome.cmds

## now this makes a new file. to execute the follow command from bin
## edit the 05_kallistopseudo_launcher.slurm script  then launch
# sbatch 05_kallistopseudo_launcher.slurm  






