#!/bin/bash

## parallelizing tophat
cd ../results/03_trimmed_filtered_2016-03-01_temp

## creating the header for our slurm job
echo '#!/bin/bash' > 05_tophat_parallel.slurm 
echo "#SBATCH -p 'normal'" >> 05_tophat_parallel.slurm   
echo '#SBATCH -t 10:00:00' >> 05_tophat_parallel.slurm 
echo '#SBATCH -J tophat' >> 05_tophat_parallel.slurm 
echo '#SBATCH -t 08:00:00' >> 05_tophat_parallel.slurm 
echo '#SBATCH -n 2' >> 05_tophat_parallel.slurm 
echo '#SBATCH --mail-user rayna.harris@utexas.edu' >> 05_tophat_parallel.slurm 
echo '#SBATCH --mail-type END -A NeuroEthoEvoDevo' >> 05_tophat_parallel.slurm 
echo 'module load bowtie/2.2.5' >> 05_tophat_parallel.slurm
echo 'module load tophat/2.0.13' >> 05_tophat_parallel.slurm
echo 'cd ../results/03_trimmed_filtered_2016-03-01_temp' >> 05_tophat_parallel.slurm

## this for loop will append a tophat command for sample to 05_tophat_parallel.slurm
for R1 in *R1_001.trimmed_filtered.fastq.gz; do
    R2=$(basename $R1 R1_001.trimmed_filtered.fastq.gz)R2_001.trimmed_filtered.fastq.gz
    samp=$(basename $R1 _R1_001.trimmed_filtered.fastq.gz)
    echo $R1 $R2 $samp
    cat >> 05_tophat_parallel.slurm <<EOF
tophat -G /work/02189/rmharris/SingleNeuronSeq/data/reference_genomes/Mus_musculus/UCSC/mm10/Annotation/Genes/genes.gtf -o sample${samp}/ /work/02189/rmharris/SingleNeuronSeq/data/reference_genomes/Mus_musculus/UCSC/mm10/Sequence/Bowtie2Index/genome $R1 $R2
EOF
done

## now for some clean up
echo 'mkdir 05_trimmedreads_filtered_mapped_2016-03-01/' >> 05_tophat_parallel.slurm
echo 'mv -sample* 05_trimmedreads_filtered_mapped_2016-03-01/' >> 05_tophat_parallel.slurm
echo 'mv tophat* 05_trimmedreads_filtered_mapped_2016-03-01/' >> 05_tophat_parallel.slurm
echo 'mv 05_trimmedreads_filtered_mapped_2016-03-01 ..' >> 05_tophat_parallel.slurm

mv 05_tophat_parallel.slurm /work/02189/rmharris/SingleNeuronSeq/bin/

## now this makes a new file. to execute the follow command from bin
#sbatch 05_tophat_parallel.slurm  






