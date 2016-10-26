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


## 00_gsaf_download

The first step in the bioinformatics pipeline is to download the data. To do so, I:
1. **Setup project directories:** I created a "SingleNeuronSeq" project directory in the WORK file system on Stampede at TACC and created subdirectory for each job "JA15597" and "JA16033"
2. **Copy script to download data:** Save a script to download the data (called "00_gsaf_download.sh") in each subdirector. 
3. **Download the data using TACC:** For this three-part step I created a commands file (called "00_gsaf_download.cmd") with the command to execute the download script,  created a launcher script to execute the commands file to execute the launcher script (I know, sounds like a lot of steps, but this is so I use TACC's compute power not my own), and launched the job on TACC.
4. **Repeat steps 2 and 3 for all RNAseq jobs**. Repeat. 
5. **Long-term storage:**Copied the data to Corral for long-term storage (which gives users the ability to copy the data to their own WORK directory

### Setup project directories 

Login to TACC using ssh with your password and authentication credentials. Replace "<username>" with your TACC user name. 

~~~ {.bash}
ssh <username>@stampede.tacc.utexas.edu
~~~

On scrate, create the project directory (SingleNeuronSeq), with a subdirectory for each job (in this case JA15597 and JA16033) and subsubdirectory called 00_rawdata. The argument `-p` will create the parent and subdirectories if they do not already exist.

~~~ {.bash}
mkdir -p $SCRATCH/SingleNeuronSeq/JA15597/00_rawdata
mkdir -p $SCRATCH/SingleNeuronSeq/JA16033/00_rawdata
~~~

### Copy script to download data 

Copy the gsaf download script found here:  https://wikis.utexas.edu/display/GSAF/How+to+download+your+data 

Navigate to one of the subjectories. Let's start with JA15597. Use the program nano to open a text file.  I use the program nano to open a new text file. Paste the script and save it as `00_gsaf_download.sh`.

~~~ {.bash}
cd $SCRATCH/SingleNeuronSeq/JA15597/00_rawdata
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
launcher_creator.py -t 2:00:00 -n 00_gsaf_download -j 00_gsaf_download.cmds -l 00_gsaf_download.slurm -A NeuroEthoEvoDevo
sbatch 00_gsaf_download.slurm
~~~

### Repeat for all jobs. 
The great thing about using TACC for this is that you can go about doing other things while the files are download. Let's repeat the two above steps for job JA16033. 

However, we are going to make two changes:
1. this time let's copy the 00_gsaf_download.sh from out sister directory rather than creating it fresh from scratch using the `cp` command.
2. We need to use a different cluster (the "normal" cluster rather than the default "development" cluster , so we will modify the launcher command `-q normal`.

~~~ {.bash}
cd $SCRATCH/SingleNeuronSeq/JA16033/00_rawdata
cp $SCRATCH/SingleNeuronSeq/JA15597/00_rawdata/00_gsaf_download.sh .
echo '00_gsaf_download.sh "http://gsaf.s3.amazonaws.com/JA16033.SA16020.html?AWSAccessKeyId=AKIAIVYXWYWNPBNEDIAQ&Expires=1478300951&Signature=ThvGlG6pvx9rzMxXCNmFyjhSYkw%3D" ' > 00_gsaf_download.cmds
launcher_creator.py -t 2:00:00 -n 00_gsaf_download -j 00_gsaf_download.cmds -l 00_gsaf_download.slurm -A NeuroEthoEvoDevo -q normal
sbatch 00_gsaf_download.slurm
~~~ 











