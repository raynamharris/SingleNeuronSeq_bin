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
* **00_rawdata:** Includes the commands need to download the data to scratch on Stampede with `00_gsaf_download`, save a copy on Corral with `00_storeoncorral`, and retrieve the data from coral with `00_getfromcorral`. 
* **01_fastqc:** Includes the commands needed to evaluate the quality of the reads using the program FastQC.
* **02_filtrimreads:** Includes the commands needed to filter low quality reads and trim adapters using the program cutadapt.
 












