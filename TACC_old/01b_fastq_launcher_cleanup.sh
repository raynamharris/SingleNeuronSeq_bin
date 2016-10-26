#!/bin/bash

## this script should be run after 01_fastqc_launcher.slurm to clean up our file system

# first move all fastqc files to a separate directory
mv /scratch/02189/rmharris/SingleNeuronSeq/JA16268/2016-05-24-trimmedreads/*fastqc* /scratch/02189/rmharris/SingleNeuronSeq/JA16268/2016-05-24-fastqc

