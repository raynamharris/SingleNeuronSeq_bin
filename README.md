# SingleNeuronSeq
Rayna M Harris  
Last edited Feb 18, 2016

This git repository contains only the scripts used for read processing and analysis. The data and results are stored elsewhere. 

For this project, I sequenced **56 samples**, so I had to write a lot of for loops and learn how to launch many jobs at once. 

To keep track of when I did things, I implemented a **naming system**. All scripts start with a number (i.e. 01 or 05) to indicate where in the pipeline they occur. The output directories also start with this same number and end with the date. 

Below is the workflow that worked for me with a breif(ish) description. 

## Read Processing

#### 1. Download raw data from the cloud
	01_gsaf_download.sh

The [Genomic Sequencing Analysis Facility (GSAF)](https://wikis.utexas.edu/display/GSAF/Home+Page) uses Amazon Web Services to deliver sequencing. Documentation for downloading data can be found [here](https://wikis.utexas.edu/display/GSAF/How+to+download+your+data).

### 2. Trim adapters with **Cutadapt**
	02_trimreads.slurm

### 3. Quality filter reads with **Fastx Toolkit**
	03_qualityfilter_cmds.sh   
	03_qualityfilter_launcher.sbatch 
	03_qualityfilter_launcher_cleanup.sh 

To submit a job to filter the reads for all my samples at the same time, I came up with this approach. The order of opperations is as follows:   
1. `03_qualityfilter_cmds.sh` loops through the raw read directory and creates a fastq_quality_filter command file `03_qualityfilter_cmds.cmds` with a fastq_quality_filter command for every read that in that directory. The output command file is saved in the directory with all the reads. 
2. `03_qualityfilter_launcher.sbatch` was created by modifying TACC's `launcher_creator.sbatch` script. The modifications include: adjusting the number of tasks, job allocation, time, and email; adding the path to the working directory with files and the direcotory with the genome and gene annotation files; adding the modules that need to be loaded.
3. `03_qualityfilter_launcher_cleanup.sh` is a script that moves all the newly-created filtered read files and the job output files to a new directory in results. 

## Mapping and Counting Reads with the **Tuxedo Suite**  

4. Downloading the Mouse Botwie Index
	`04_bowtie_index.slurm`

5. Mapping with TopHat
	`05_tophat_cmds.sh.sh`
	`05_tophat_launcher.slurm`
	`05_tophat_launcher_cleanup`

## Mapping and Counting Reads with **Kallisto**

4. Creating the Kallisto Index from a Mouse genome
	`04_kallisto.index.slurm`

5.  Pseudomapping reads with Kallisto
	`05_run_kallisto.slurm`

6.  Gathering all the data from separate .tsv files into 1 dataframe
	`06_kallisto_gather.R`

7. 	Kallisto Data Wrangling
	`07_dplyrmutate.R`

8. 	ERCC Analysis
	`08_ERCC_counts.R`

9.  Quanitfying Gene expression
	`09_DESeq.R`





**04_kallisto.index.slurm**
Building a reference index from an exising reference genome

**05_run_kallisto.slurm**
Pseudomapping reads to the kallisto index

**06_kallisto_gather.R**
Gathing the data from individual abundance.tsv files into a single counts fie

**07_dplyrmutate.R**
Wrangling the data

**08_ERCC_counts.R**
Checking the quality of reads by way of our ERCC counts

**09_DESeq.R**
Analyzing differential gene expression