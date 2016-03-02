# move to directory with rad data
cd ../results/02_trimmedreads_2016-02-29/

## creating the header for our slurm job
echo '#!/bin/bash' > 03_qualityfilter.slurm 
echo "#SBATCH -p 'normal'" >> 03_qualityfilter.slurm   
echo '#SBATCH -J qualityfilter' >> 03_qualityfilter.slurm 
echo '#SBATCH -o qualityfilter.out.%j' >> 03_qualityfilter.slurm 
echo '#SBATCH -e qualityfilter.error.%j' >> 03_qualityfilter.slurm  
echo '#SBATCH -t 03:00:00' >> 03_qualityfilter.slurm 
echo '#SBATCH -n 112' >> 03_qualityfilter.slurm 
echo '#SBATCH --mail-user rayna.harris@utexas.edu' >> 03_qualityfilter.slurm 
echo '#SBATCH --mail-type END' >> 03_qualityfilter.slurm 
echo '#SBATCH -A NeuroEthoEvoDevo' >> 03_qualityfilter.slurm 
echo 'module load fastqc' >> 03_qualityfilter.slurm
echo 'module load fastx_toolkit' >> 03_qualityfilter.slurm
echo 'cd '../results/02_trimmedreads_2016-02-29/ >> 03_qualityfilter.slurm

## These are the fastq quality filter flags
## -Q for Illumina Data
## -q min quality score to keep
## -p Minimum percent of bases that must have -q quality
## -z compress the output
### Find help here with this documentation
### http://hannonlab.cshl.edu/fastx_toolkit/commandline.html#fastq_quality_filter_usage


#this will trim using the fastx toolkit on R1 and then the R2 reads
# I'm using basename function to create a new filename for the reads after filtering
for R1 in *R1_001.trimmed.fastq
do
     filteredR1="$(basename $R1 .fastq)_filtered.fastq.gz"
     echo $R1 $filteredR1
     cat >> 03_qualityfilter.slurm <<EOF
fastq_quality_filter -Q 33 -q 20 -p 80 -z -i $R1 -o $filteredR1
EOF
done

for R2 in *R2_001.trimmed.fastq
do
     filteredR2="$(basename $R2 .fastq)_filtered.fastq.gz"
     echo $R2 $filteredR2
     cat >> 03_qualityfilter.slurm <<EOF
fastq_quality_filter -Q 33 -q 20 -p 50 -z -i $R2 -o $filteredR2
EOF
done

#now for some clean
echo 'mkdir 03_trimmedreads_filtered_2016-03-01/' >> 03_qualityfilter.slurm
echo 'mv *.filtered.fastq.gz 03_trimmedreads_filtered_2016-03-01/' >> 03_qualityfilter.slurm
echo 'mv -03_trimmedreads_filtered_2016-03-01/ ..' >> 03_qualityfilter.slurm

## now move the script to the bin sow it can be exectuted with sbatch
mv 03_qualityfilter.slurm /work/02189/rmharris/SingleNeuronSeq/bin/







	
