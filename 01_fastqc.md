# Fastqc: Quality Control Assessment of Raw Reads

We must check the quality of our reads to see if we need to do any processing to improve the quality. We will use the function called `fastqc` (aka quality control of fastq files).

## Navigate to your working directory on stampede, 

~~~ {.bash}
ssh <username>@stampede.tacc.utexas.edu
cd $SCRATCH/$RNAseqProject/$RNAseqJob
~~~

Note: if the cd command doesn't work, rest the environment variables.

~~~ {.bash}
## set the enviornment variables 
RNAseqProject=<nameofproject>
RNAseqJob=<jobnumber>
~~~

## Write a fastqc commands file 

Create a commands file using a for loop. This will create a file with one command per line for performing the fastqc function on every read in the directory. We use the `>>` function to append the new line to the existing file. In case we made an error and are rerunning the loop, its always good to start with the `rm` command, just incase there is a bad version of this file around.

~~~ {.bash}
rm 01_fastqc.cmds 
for file in *.fastq.gz
do
     echo $file
     echo "fastqc $file" >> 01_fastqc.cmds
done
~~~

Check to see that the commands file looks like it should

~~~ {.bash}
cat 01_fastqc.cmds
~~~

Now, create a launcher script and launch the fastqc job

~~~ {.bash}
launcher_creator.py -t 0:30:00 -n 01_fastqc -j 01_fastqc.cmds -l 01_fastqc.slurm -A NeuroEthoEvoDevo -m 'module load fastqc/0.11.5'
sbatch 01_fastqc.slurm
~~~

Then, I moved all the output files to a separate folder where we will store the fastqc results.

~~~ {.bash}
mkdir ../01_fastqc
mv *.html ../01_fastqc
mv *.zip ../01_fastqc
mv 01_fastqc.e* ../01_fastqc
mv 01_fastqc.o* ../01_fastqc
~~~

## save locallaly

One must save the data locally in order to view the html files. 

In a new terminal window:

~~~ {.bash}
cd <pathtoplaceonyourpersonalpc>
mkdir -p $RNAseqProject/$RNAseqJob
cd $RNAseqProject/$RNAseqJob
scp <username>@stampede.tacc.utexas.edu:$SCRATCH/$RNAseqProject/$RNAseqJob/01_fastqc/*html .
~~~

## References
FastQC: http://www.bioinformatics.babraham.ac.uk/projects/fastqc/
BioITeam Launcher Creator: https://wikis.utexas.edu/display/bioiteam/launcher_creator.py
FastQC Overview: https://wikis.utexas.edu/display/bioiteam/FASTQ+Quality+Assurance+Tools