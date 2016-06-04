#!/bin/bash

## this script should be run after 02_cutadapt_launcher.slurm to clean up our file system

## go to folder with trimmrd files
cd /scratch/02189/rmharris/SingleNeuronSeq/JA16268/2016-05-24-raw-reads

## then move all fastqc files to a separate directory
mkdir /scratch/02189/rmharris/SingleNeuronSeq/JA16268/2016-05-24-trimmedreads
mv /scratch/02189/rmharris/SingleNeuronSeq/JA16268/2016-05-24-raw-reads/*trimmed.fastq/scratch/02189/rmharris/SingleNeuronSeq/JA16268/2016-05-24-trimmedreads

