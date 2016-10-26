# move to file with reads to be checked
cd /scratch/02189/rmharris/SingleNeuronSeq/JA16268/2016-05-24-raw-reads

# create a file called 01_fastqc_cmds.cmds
for file in *.fastq.gz
do
     echo $file 
     cat >> 01_fastqc_cmds.cmds <<EOF
fastqc $file
EOF
done

## move cmds file to bin
mv 01_fastqc_cmds.cmds /work/02189/rmharris/SingleNeuronSeq/bin/

## create a symbolic link to the 01_fastqc_cmds.cmds in /scratch/02189/rmharris/SingleNeuronSeq/JA16268/2016-05-24-raw-reads
ln -s -f /work/02189/rmharris/SingleNeuronSeq/bin/01_fastqc_cmds.cmds




