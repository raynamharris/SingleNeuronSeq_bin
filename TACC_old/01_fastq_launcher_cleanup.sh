#!/bin/bash

## this script should be run after 01_fastqc_launcher.slurm to clean up our file system

# first move all fastqc files to a separate directory
mkdir /scratch/02189/rmharris/SingleNeuronSeq/JA16268/2016-05-24-fastqc
mv /scratch/02189/rmharris/SingleNeuronSeq/JA16268/2016-05-24-raw-reads/*fastqc* /scratch/02189/rmharris/SingleNeuronSeq/JA16268/2016-05-24-fastqc

