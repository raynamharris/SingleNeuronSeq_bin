#!/bin/bash

## this script creates a list of top hat commands to execute fore every file in the folder
## the outhput is a .cmds file that will be called in the 05_kallistoquant_launcher.slurm

## make output directory on scratch
#mkdir /scratch/02189/rmharris/SingleNeuronSeq/results/05_kallistoquant_ERCC92_2016-03-25
#mkdir /scratch/02189/rmharris/SingleNeuronSeq/results/05_kallistoquant_MusUCSD_2016-03-25

mkdir /scratch/02189/rmharris/SingleNeuronSeq/JA16268/2016-06-03-05-Cborealis-cds-kallisto
#mkdir /scratch/02189/rmharris/SingleNeuronSeq/JA16268/2016-06-02-05-Cborealis-transcriptome-kallisto


## the $WORKING_DIRECTORY
cd /scratch/02189/rmharris/SingleNeuronSeq/JA16268/2016-05-24-trimmedreads


## in case there is an older version, let's delete the file, so we don't append to it
#rm 05_kallistoquant_ERCC92.cmds
#rm 05_kallistoquant_MusUCSD.cmds
rm 05_kallistoquant_Cborealis_cds.cmds
rm 05_kallistoquant_Cborealis_transcriptome.cmds


## now, create 05_kallistoquant_Cborealis.cmds with all a kallisto quant command for each sample

## this for loop will append a kallistoquant command for sample to 05_kallistoquant_Cborealis_cds.cmds

for R1 in PD*R1_001.trimmed.fastq GM*R1_001.trimmed.fastq; do
    R2=$(basename $R1 R1_001.trimmed.fastq)R2_001.trimmed.fastq
    samp=$(basename $R1 _R1_001.trimmed.fastq)
    echo $R1 $R2 $samp
    cat >> 05_kallistoquant_Cborealis_cds.cmds <<EOF
kallisto quant -b 100 -i /scratch/02189/rmharris/Cborealis_ref/Cborealis_candidategenes.idx  -o /scratch/02189/rmharris/SingleNeuronSeq/JA16268/2016-06-03-05-Cborealis-cds-kallisto/${samp} $R1 $R2
EOF
done

## this for loop will append a kallisto quant command for sample to 05_kallistoquant_Cborealis_transcriptome.cmds
for R1 in PD*R1_001.trimmed.fastq GM*R1_001.trimmed.fastq; do
    R2=$(basename $R1 R1_001.trimmed.fastq)R2_001.trimmed.fastq
    samp=$(basename $R1 _R1_001.trimmed.fastq)
    echo $R1 $R2 $samp
    cat >> 05_kallistoquant_Cborealis_transcriptome.cmds <<EOF
kallisto quant -b 100 -i /scratch/02189/rmharris/Cborealis_ref/Cborealis_transcriptome.idx  -o /scratch/02189/rmharris/SingleNeuronSeq/JA16268/2016-06-02-05-Cborealis-transcriptome-kallisto/${samp} $R1 $R2
EOF
done

## check number of lines in commands file
wc 05_kallistoquant_Cborealis_cds.cmds
wc 05_kallistoquant_Cborealis_transcriptome.cmds 

## now this makes a new file. to execute the follow command from bin
## edit the 05_kallistoquant_launcher.slurm script  then launch
# sbatch 05_kallistoquant_launcher.slurm  






