#!/bin/csh
#
# Simple slurm script for submitting multiple serial jobs (e.g. parametric studies) using a script wrapper to launch the jobs.
#
# To use, 
# 1. build the launcher executable and commmands file and place them in your bin.  
# 2. Set the CONTROL_FILE to be the commands file
# 3. Then, set the WORKING_DIRECTORY to be the directory with the files
# 4. submit job
#-------------------------------------------------------
#-------------------------------------------------------
# 
#         <------ Setup Parameters ------>
#
#SBATCH -J qualityfilterlauncher      # Job name
#SBATCH -n 112                 # Total number of tasks
#SBATCH -p normal              # Queue name
#SBATCH -t 01:00:00            # Run time (hh:mm:ss)
#SBATCH -A NeuroEthoEvoDevo    # sets the allocation if you have multiple to chose from
#SBATCH --mail-user rayna.harris@utexas.edu
#SBATCH --mail-type END        # to get email when the job is complete
#------------------------------------------------------

module load launcher
setenv EXECUTABLE    $TACC_LAUNCHER_DIR/init_launcher 
setenv CONTROL_FILE  03_qualityfilter_cmds.cmds
setenv WORKDIR /work/02189/rmharris/SingleNeuronSeq/results/02_trimmedreads_2016-02-29/
# 
# Variable description:
#
#  EXECUTABLE     = full path to the job launcher executable
#  CONTROL_FILE   = text input file which specifies
#                   executable for each process
#                   (should be located in WORKDIR)
#  WORKDIR        = location of working directory with files
#
#      <------ End Setup Parameters ------>
#--------------------------------------------------------
#--------------------------------------------------------

#----------------
# Error Checking
#----------------

if ( ! -e $WORKDIR ) then
        echo " "
	echo "Error: unable to change to working directory."
	echo "       $WORKDIR"
	echo " "
	echo "Job not submitted."
	exit
endif

if ( ! -f $EXECUTABLE ) then
	echo " "
	echo "Error: unable to find launcher executable $EXECUTABLE."
	echo " "
	echo "Job not submitted."
	exit
endif

if ( ! -f $WORKDIR/$CONTROL_FILE ) then
	echo " "
	echo "Error: unable to find input control file $CONTROL_FILE."
	echo " "
	echo "Job not submitted."
	exit
endif


#----------------
# Job Submission
#----------------

cd $WORKDIR/
echo " WORKING DIR:   $WORKDIR/"

module load fastqc
module load fastx_toolkit

$TACC_LAUNCHER_DIR/paramrun $EXECUTABLE $CONTROL_FILE

echo " "
echo " 03_qualityfliter_launcher.slurm Job Complete"
echo " "
