# Kallisto: Quantifying RNA Transcript Abundances

To quantify transcripts, we first need to have a reference genome or transciptome to which the reads can be mapped. 

## Set Stampede environment  variables

For each new project or new batch of samples, we can reset these variables and then all the code will work below, with out having to recode all the project specific file names.

~~~ {.bash}
## set the enviornment variables 
RNAseqProject=BehavEphyRNAseq
RNAseqJob=JA16444
~~~ 

## Download a reference transcriptome

Download mouse transcriptome from https://www.gencodegenes.org/mouse_releases/current.html

~~~ {.bash}
# make a directory the reference transcriptome and index
mkdir $SCRATCH/$RNAseqProject/refs
cd $SCRATCH/$RNAseqProject/refs
# download mouse transcriptome, version M11, from Gencode
curl -O ftp.sanger.ac.uk/pub/gencode/Gencode_mouse/release_M11/gencode.vM11.pc_transcripts.fa.gz
~~~

## 04_kallistoindex

The kallisto index only needs to be built once for each. The manual for running kallisto can be found [here](https://pachterlab.github.io/kallisto/manual)

~~~ {.bash}
# create the commands file
echo "kallisto index -i gencode.vM11.pc_transcripts_kallisto.idx $SCRATCH/BehavEphyRNAseq/refs/gencode.vM11.pc_transcripts.fa.gz" > 04_kallisto_index.cmds
cat 04_kallisto_index.cmds
~~~

Then create the launcher script. Kallisto is not a TACC supported module, so we must use the version of Kallisto that was build by TACC user "wallen" and stored in his public directory. 

~~~ {.bash}
launcher_creator.py -t 0:30:00 -j 04_kallisto_index.cmds -n kallistoindex -l kallisto_index.slurm -A NeuroEthoEvoDevo -m 'module use -a /work/03439/wallen/public/modulefiles; module load gcc/4.9.1; module load hdf5/1.8.15; module load zlib/1.2.8; module load kallisto/0.42.3'
sbatch 04_kallisto_index.slurm
~~~

## 04_kallistoquant

Now, let's quantify our transcripts

Navigate to the directory with the processed reads and make a directory where the output can be stored. 

~~~ {.bash}
cd $SCRATCH/$RNAseqProject/$RNAseqJob/02_filtrimmedreads
mkdir ../04_kallistoquant
~~~

Now, we will use the `kallistoquant` function to quantify reads! Again, we use a for loop to create the commands file. The output for each pair of samples will be stored in a subdirectory.  

~~~ {.bash}
rm 04_kallistoquant.cmds
for R1 in *R1_001.filtrim.fastq.gz
do
    R2=$(basename $R1 R1_001.filtrim.fastq.gz)R2_001.filtrim.fastq.gz
    samp=$(basename $R1 _R1_001.filtrim.fastq.gz)
    echo $R1 $R2 $samp
    echo "kallisto quant -b 100 -i ../../refs/gencode.vM11.pc_transcripts_kallisto.idx  -o ../05_kallistoquant/${samp} $R1 $R2" >> 04_kallistoquant.cmds
done
~~~

Now launch the job. Here, we have to use kallisto stored in someone's personal directory. 

~~~ {.bash}
launcher_creator.py -t 1:00:00 -j 04_kallistoquant.cmds -n 04_kallistoquant -l 04_kallistoquant.slurm -A NeuroEthoEvoDevo -q largemem -m 'module use -a /work/03439/wallen/public/modulefiles; module load gcc/4.9.1; module load hdf5/1.8.15; module load zlib/1.2.8; module load kallisto/0.42.3'
sbatch 04_kallistoquant.slurm
~~~

Note: The largemem node has compute limitations. If you have two many samples, the job may need to be split in two. One can use the lane identifiers (like L002 and L003) to subset the data. 


## Now, save the data locally

In a new terminal window:

~~~ {.bash}
## navigate to an appropriate folder on your personal computer
scp <username>@stampede.tacc.utexas.edu:$SCRATCH/$RNAseqProject/$RNAseqJob/03_fastqc/*html .
~~~

~~~ {.bash}
## navigate to an appropriate folder on your personal computer
cd $RNAseqProject/$RNAseqJob
scp -r <username>@stampede.tacc.utexas.edu:$SCRATCH/$RNAseqProject/$RNAseqJob/04_kallistoquant .
~~~

## Optional

You may need to remove the uninformative bits of the "sample name" so they match up with the actual sample name. 

~~~ {.bash}
for file in *
do
    sample=${file//_S*/}
    echo $file $sample
    mv $file $sample
done
~~~

Then, replace the `_` with `-`

~~~ {.bash}
for file in *
do
    sample=${file//_/-}
    echo $file $sample
    mv $file $sample
done
~~~

## References
Kallisto: https://pachterlab.github.io/kallisto/