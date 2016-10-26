# RNAseq Pipeline for analysis of a Single Neuron Project
By Rayna M Harris with Cherish Taylor
October 25, 2016

## Project Design
All data data in this directory is from a collaboration with Boris Zemelman and the Genomic Sequencing and Analysis Facility. I will add the details later

## The data
The data for this project were processed as part of two sequencing runs.

| RNAseq Job | Data | Job Info | No. Samples |
| :--- | :---: | :---: | :--- |
JA15597 | May 24, 2016 | NextSeq 500, PE 2x150 |21 samples: serial dilutions of neurons & tissues, controls |
JA16033 | Jan 18, 2016 | NextSeq 500, PE 2x75 |17 samples: single neurons, pooled neurons, tissue samples, controls |

## The pipeline
* **00_rawdata:** Download the data to scratch on Stampede with `00_gsaf_download` and save a copy on Corral with `00_storeoncorral`  

## 00_gsaf_download and 00_storeoncorral

The first step in the bioinformatics pipeline is to download the data. To do so, I:
1. Setup project directories:* I created a "SingleNeuronSeq" project directory in the WORK file system on Stampede at TACC and created subdirectory for each job "JA15597" and "JA16033"  
2. Copy script to download data: Save a script to download the data (called "00_gsaf_download.sh") in each subdirector  
3. Download the data using TACC: For this three-part step I created a commands file (called "00_gsaf_download.cmd") with the command to execute the download script,  created a launcher script to execute the commands file to execute the launcher script (I know, sounds like a lot of steps, but this is so I use TACC's compute power not my own), and launched the job on TACC  
4. Repeat steps 2 and 3 for all RNAseq jobs: Repeat  
5. Long-term storage: Copied the data to Corral for long-term storage (which gives users the ability to copy the data to their own WORK directory  

### Setup project and RNAseq job directories 

Login to TACC using ssh with your password and authentication credentials. Replace "<username>" with your TACC user name. 

~~~ {.bash}
ssh <username>@stampede.tacc.utexas.edu
~~~

Raw data from separate jobs need to be processed as separate jobs. Later, the read counts can be combined, but original processing must be done by job. So, let's create a an environment variable called `RNAseqJob` so that the scripts can easily be co-opted for each new RNAseq job. 

~~~ {.bash}
## set the enviornment variables 
RNAseqProject=SingleNeuronSeq
RNAseqJob=JA16033
~~~

On scratch, create the project directory (SingleNeuronSeq), with a subdirectory for each job (in this case JA15597 and JA16033) and subsubdirectory called 00_rawdata. The argument `-p` will create the parent and subdirectories if they do not already exist.


~~~ {.bash}
mkdir -p $SCRATCH/$RNAseqProject/$RNAseqJob/00_rawdata
~~~

### Copy script to download data 

Copy the gsaf download script found here:  https://wikis.utexas.edu/display/GSAF/How+to+download+your+data 

Navigate to one of the subjectories. Use the program nano to open a text file.  I use the program nano to open a new text file. Paste the script and save it as `00_gsaf_download.sh`.

~~~ {.bash}
cd $SCRATCH/$RNAseqProject/$RNAseqJob/00_rawdata
nano
~~~ 

Now, you should have one file called `00_gsaf_download.sh`. Check with `ls`

~~~ {.bash}
ls
~~~ 

### Download the data using TACC
Technically, you can download the data with one command using your own comptuer's compute power, but I prefer to have TACC do it. So, instead of type the command which will do just that in the command line, I will save it to a script, like so. (Note: the webaddress provided was sent by secure email to the person who submitted the samples to GSAF). Then, you must make the bash script executable with `chmod`.

~~~ {.bash}
echo '00_gsaf_download.sh "http://gsaf.s3.amazonaws.com/JA15597.SA15231.html?AWSAccessKeyId=AKIAIVYXWYWNPBNEDIAQ&Expires=1478303430&Signature=yFqA%2FQ54MsBIfp%2Fuv1RbMewBulU%3D" ' > 00_gsaf_download.cmds
chmod a+x 00_gsaf_download.sh
~~~

Now, I use `launcher_creator.py` to create a launcher script that will tell how to launch this job on TACC. The arguments are defined clearly on this website: https://wikis.utexas.edu/display/bioiteam/launcher_creator.py. Then I will use `sbatch 00_gsaf_download.slurm` to launch the job.

~~~ {.bash}
launcher_creator.py -t 12:00:00 -n 00_gsaf_download -j 00_gsaf_download.cmds -l 00_gsaf_download.slurm -A NeuroEthoEvoDevo -q normal
sbatch 00_gsaf_download.slurm
~~~

### Repeat for all jobs. 
The great thing about using TACC for this is that you can go about doing other things while the files are download. Change the environment variable above `RNAseqJob` to repeat for other jobs.

 

### Save to Coral for long term storage

This will be a three-step process. 

**In the first step,** I'll create the directories on coral where the data will be stored. In a new terminal window, login to Coral, navigate to the Hofmann lab repository, and create repos to store the raw data. 

~~~ {.bash}
## set the enviornment variables 
RNAseqProject=SingleNeuronSeq
RNAseqJob=JA0000
~~~

~~~ {.bash}
ssh <username>@corral.tacc.utexas.edu
cd /corral-tacc/utexas/NeuroEthoEvoDevo
mkdir -p $RNAseqProject/$RNAseqJob/00_rawdata
mkdir -p $RNAseqProject/$RNAseqJob/00_rawdata
~~~ 

**In the second step**, I return to my scratch directory and use a for loop to create a commands file `00_storeoncorral.cmds` that will copy each read (*.fastq.gz) to corral. 

~~~ {.bash}
cd $SCRATCH/SingleNeuronSeq/JA15597/00_rawdata
for file in *.fastq.gz
do
echo $file
echo "cp $file /corral-tacc/utexas/NeuroEthoEvoDevo/$RNAseqProject/$RNAseqJob/00_rawdata" >> 00_storeoncorral.cmds
done
~~~

**In the third step**, I'll create and launch a launcher script `00_storeonecorral.slurm` that copies the data to corral. 

~~~ {.bash}
launcher_creator.py -t 01:00:00 -n 00_storeoncorral -j 00_storeoncorral.cmds -l 00_storeoncorral.slurm -A NeuroEthoEvoDevo -q normal
sbatch 00_storeoncorral.slurm
~~~ 












