#!/bin/bash

## parallelizing tophat
cd ../results/02_trimmedreads_2016-02-29/temp

## creating the header for our slurm job
echo '#!/bin/bash' > 05_tophat_parallel.slurm 
echo "#SBATCH -p 'normal'" >> 05_tophat_parallel.slurm   
echo '#SBATCH -t 24:00:00' >> 05_tophat_parallel.slurm 
echo '#SBATCH -J tophat' >> 05_tophat_parallel.slurm 
echo '#SBATCH -o tophat.out%j' >> 05_tophat_parallel.slurm 
echo '#SBATCH -e tophat.error%j' >> 05_tophat_parallel.slurm  
echo '#SBATCH -t 12:00:00' >> 05_tophat_parallel.slurm 
echo '#SBATCH -n 2' >> 05_tophat_parallel.slurm 
echo '#SBATCH -N 1' >> 05_tophat_parallel.slurm 
echo '#SBATCH --mail-user rayna.harris@utexas.edu' >> 05_tophat_parallel.slurm 
echo '#SBATCH --mail-type END -A NeuroEthoEvoDevo' >> 05_tophat_parallel.slurm 

## this for loop will append a tophat command for sample to 05_tophat_parallel.slurm
for R1 in *R1_001.trimmed.fastq; do
    R2=$(basename $R1 R1_001.trimmed.fastq)R2_001.trimmed.fastq
    samp=$(basename $R1 _R1_001.trimmed.fastq)
    echo $R1 $R2 $samp
    cat >> 05_tophat_parallel.slurm <<EOF
tophat -G /work/02189/rmharris/SingleNeuronSeq/data/reference_genomes/Mus_musculus/UCSC/mm10/Annotation/Genes/genes.gtf -o sample${samp}/ /work/02189/rmharris/SingleNeuronSeq/data/reference_genomes/Mus_musculus/UCSC/mm10/Sequence/Bowtie2Index/ $R1 $R2
EOF
done

sbatch 05_tophat_parallel.slurm  












