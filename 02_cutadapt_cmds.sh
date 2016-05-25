# move to file with reads to be trimmed
cd /scratch/02189/rmharris/SingleNeuronSeq/JA16268/2016-05-24-raw-reads

# Use a loop and basename to create the cutadapt command for trimmed TRUseq adapter from R1 and R2 files

for R1 in *R1_001.fastq.gz 
do
     	trimmedR1="$(basename $R1 .fastq.gz).trimmed.fastq"
     	echo $R1 $trimmedR1
     	R2="$(basename $R1 R1_001.fastq.gz)R2_001.fastq.gz"
     	trimmedR2="$(basename $R2 .fastq.gz).trimmed.fastq"
     	echo $R2 $trimmedR2
     	cat >> 02_cutadapt_cmds.cmds <<EOF
cutadapt -a GATCGGAAGAGCACACGTCTGAACTCCAGTCACACAGTGATCTCGTATGC -A CGGCGACCACCGAGATCTACACTCTTTCCCTACACGACGCTCTTCCGATC -m 22 -o  $trimmedR1 -p $trimmedR2 $R1 $R2 
EOF
done


## move cmds file to bin
mv 02_cutadapt_cmds.cmds /work/02189/rmharris/SingleNeuronSeq/bin/

## create a symbolic link to the cmd file in the folder with the data
ln -s -f /work/02189/rmharris/SingleNeuronSeq/bin/02_cutadapt_cmds.cmds







       
            
            
            
            