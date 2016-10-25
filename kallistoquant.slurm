#!/bin/csh
#SBATCH -J kallistoquant     # Job name
#SBATCH -o kallistoquant.%j.out
#SBATCH -e kallistoquant.%j.e
#SBATCH -n 34                  # Total number of tasks
#SBATCH -p normal              # Queue name
#SBATCH -t 4:00:00             # Run time (hh:mm:ss)
#SBATCH --mail-user rayna.harris@utexas.edu     
#SBATCH --mail-type END # when to notify email
#SBATCH -A UT-2015-05-18     		 # Allocation name to charge job against

## See https://pachterlab.github.io/kallisto/manual for detailed use of kallisto

## Paired-end USAGE: 
## kallisto quant -i index -o output pairA_1.fastq pairA_2.fastq pairB_1.fastq pairB_2.fastq

## Single-end USAGE :
## kallisto quant -i index -o output --single -l 200 file1.fastq.gz file2.fastq.gz file3.fastq.gz
## -l, --fragment-length=DOUBLE  Estimated average fragment length
                              

## load kallisto, which is installed in W. Joe Allen's public space.
module use -a /work/03439/wallen/public/modulefiles

## then load other required modules
module load gcc/4.9.1
module load hdf5/1.8.15
module load zlib/1.2.8
module load kallisto/0.42.3

## move to directory with genomes
cd $WORK/IntMolModule/STG/data/references 

## make a results folder
mkdir ../results/{$SLURM_JOB_NAME}-{$SLURM_JOB_ID}

## Quantify reads using kallisto quant
# -i means input -o means output -b means bootstrap $R1 means read 1 $R2 means read 2
kallisto quant -b 100 -i Cborealis-CLEAN4.idx -o ../results/{$SLURM_JOB_NAME}-{$SLURM_JOB_ID}/ $R1 $R2


echo " "
echo " {$SLURM_JOB_NAME} Job Complete"
echo " "


