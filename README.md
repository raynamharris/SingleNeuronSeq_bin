# SingleNeuronSeq
Rayna M Harris  
Last edited March 2, 2016

This git repository contains only the scripts used for read processing and analysis. The data and results are stored elsewhere. For this project, I sequenced 56 samples, so I had to write a lot of for loops and learn how to launch many jobs at once. I came up with a **three-step solution to pseudo-parallelize** the processing of all my samples rather than one sample at a time. I think it keeps things nice and orderly.

To keep track of when I did things, I implemented a **naming system**. All scripts start with a number (i.e. 01 or 05) to indicate where in the pipeline they occur. The output directories also start with this same number and end with the date. 

Below is the workflow that worked for me with a breif(ish) description. 

## Read Processing

#### 1. Download raw data from the cloud
	01_gsaf_download.sh

The [Genomic Sequencing Analysis Facility (GSAF)](https://wikis.utexas.edu/display/GSAF/Home+Page) uses Amazon Web Services to deliver sequencing. Documentation for downloading data can be found [here](https://wikis.utexas.edu/display/GSAF/How+to+download+your+data).

### 2. Trim adapters with Cutadapt
	02_trimreads.slurm

Documentation for Cutadapt can be found [here](https://cutadapt.readthedocs.org/en/stable/guide.html#basic-usage). I also use some parameders as recommened by my colleague, Dhivya Arrassapan, in this [Intro to RNA-seq course](http://ccbb.biosci.utexas.edu/summerschool.html). I learned how to write these forloops with basename from Titus Brown [here](https://github.com/ngs-docs/2016-adv-begin-shell-genomics).

### 3. Quality filter reads with Fastx Toolkit
	03_qualityfilter_cmds.sh   
	03_qualityfilter_launcher.sbatch 
	03_qualityfilter_launcher_cleanup.sh 

To submit a job to filter the reads for all my samples at the same time, I came up with this approach. The order of opperations is as follows:   

1. `03_qualityfilter_cmds.sh` loops through the trimmed read directory and creates a fastq_quality_filter command file `03_qualityfilter_cmds.cmds` with a fastq_quality_filter command for every read that in that directory. The output command file is saved in the directory with all the reads. 

2. `03_qualityfilter_launcher.sbatch` was created by modifying TACC's `launcher_creator.sbatch` script. The modifications include: adjusting the number of tasks, job allocation, time, and email; adding the path to the working directory with files and the directory with the genome and gene annotation files; adding the modules that need to be loaded.

3. `03_qualityfilter_launcher_cleanup.sh` is a script that moves all the newly-created filtered read files and the job output files to the new directory with the results results.

Documentation for Fastx Quality Filter can be found [here](http://hannonlab.cshl.edu/fastx_toolkit/commandline.html#fastq_quality_filter_usage). I set some parameters based on suggestions by colleagues here [ 


## Mapping and Counting Reads with the Tuxedo Suite  

### 4. Downloading the Mouse Botwie Index
	04_bowtie_index.slurm

The Tuxedo website provides links to a bunch of Illumina genomes [here](https://ccb.jhu.edu/software/tophat/igenomes.shtml). For this project I downloaded both the mouse genome and bowtie indexes from USCD mm10.  

### 5. Mapping with TopHat
	05_tophat_cmds.sh.sh
	05_tophat_launcher.slurm
	05_tophat_launcher_cleanup.sh

## Mapping and Counting Reads with Kallisto

### 4. Creating the Kallisto Index from a Mouse genome
	04_kallisto.index.slurm

### 5.  Pseudomapping reads with Kallisto
	05_kallistoquant_cmds.sh
	05_kallistoquant_launcher.slurm
	05_kallistoquant_launcher_cleanup.sh
	
1. `05_kallistoquant_cmds.sh` loops through the proccessed reads directory and creates a kallisto quant command file `05_kallistoquant_cmds.cmds` for each read pair. The command for each pair looks like `kallisto quant -i index -o output Read1.fastq.gz Read2.fastq.gz`. 

2. `05_kallistoquant_launcher.sbatch` gives Stampede all the necessary details to execute kallisto. Kallisto is only available on Stampede because it is install in someone's public profile there. The command `module use /work/03439/wallen/public/modulefiles` must proceed `module load kallisto` to source the program. Kallisto is super fast! The only downfall I see is that you don't get the intermediate files to view how the reads map, instead the only output is the counts.	

3. `05_kallistoquant_launcher.sh` moves the job output files into the directory with the output.	
	
### 6. Gathering all the data from separate .tsv files into 1 dataframe
	06_kallisto_gather.R
Kallisto outputs three files for every sample into their own sub directories. The `abundance.tsv` file has the count data in terms of raw counts and transcripts per million. My colleague Dennis Whylie wrote this script to "gater" the data into an R dataframe.

### 7. 	Kallisto Data Wrangling
	07_dplyrmutate.R
I wanted to play around with the raw counts for a while before importing into DESeq. I called it dplyrmutate because the main thing this script does is subtract maximumum number of reads of the negative control samples from the number of reads from the real samples. 

### 8. 	ERCC Analysis
	08_ERCC_counts.R
We spiked in ERCCs into our samples before sequencing. This script analyses the ERCC counts for all the samples. 

### 9.  Quanitfying Gene expression
	09_DESeq.R
	
## Other Stuff
I downloaded `launcher.slurm` from TACC. For more info on TACC's launcher program, type 	`module spider launcher` on Stamped or Lonestar 5 and/or visit [this page](https://www.tacc.utexas.edu/research-development/tacc-software/the-launcher)
	