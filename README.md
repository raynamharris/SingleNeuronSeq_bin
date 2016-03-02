# SingleNeuronSeq
Rayna M Harris  
Last edited Feb 18, 2016

This directory contains only the scripts used for data analysis. Data and results are  stored elsewhere. 

The workflows with a breif (ish) descirption of each is descibed below 

## Read Processing

### 1. Download raw data from the cloud
	01_gsaf_download.sh
The Genomic Sequencing Analysis Facility (GSAF) uses Amazon We


### 2. Trim adapters with **Cutadapt**
	`02_trimreads.slurm`

### 3. Quality filter reads with **Fastx Toolkit**
	'''03_qualityfilter_cmds.sh   
	03_qualityfilter_launcher.sbatch 
	03_qualityfilter_launcher_cleanup.sh''' 
	
	These three scripts should be executed in the order above. Briefly:  
`03_qualityfilter_cmds.sh` loops through the raw read directory and creates a fastq_quality_filter command file `03_qualityfilter_cmds.cmds` with a fastq_quality_filter command for every read that in that directory. The output command file is saved in the directory with all the reads. 

`03_qualityfilter_launcher.sbatch` was created by modifying TACC's `launcher_creator.sbatch` script. The modifications include: adjusting the number of tasks, job allocation, time, and email; adding the path to the working directory with files and the direcotory with the genome and gene annotation files; adding the modules that need to be loaded.

`03_qualityfilter_launcher_cleanup.sh` is a script that moves all the newly-created filtered read files and the job output files to a new directory in results. 

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