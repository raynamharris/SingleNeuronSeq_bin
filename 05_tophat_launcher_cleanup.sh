#!/bin/bash

## this script should be run after 05_tophat_launcher.slurm t
## to move all the newly created files to a new directory

## create new directory, move filtered files there, move slurm job output there

mkdir ../results/05_tophat_mapped_2016-03-02
mv ../results/02_trimmedreads_2016-02-29/*trimmed_filtered.fastq.gz ../results/03_trimmedreads_filtered_2016-03-02
mv slurm* ../results/03_trimmedreads_filtered_2016-03-02