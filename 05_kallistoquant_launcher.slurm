#!/bin/csh
#
# Simple slurm script for submitting multiple serial
# jobs (e.g. parametric studies) using a script wrapper
# to launch the jobs.
#
# To use, build the launcher executable and your
# serial application(s) and place them in your WORKDIR
# directory.  Then, edit the CONTROL_FILE to specify 
# each executable per process.
#-------------------------------------------------------
#-------------------------------------------------------
# 
#         <------ Setup Parameters ------>
#
#SBATCH -J kallistolauncher     # Job name
#SBATCH -n 56                   # Total number of tasks
#SBATCH -p normal              # Queue name
#SBATCH -t 2:00:00             # Run time (hh:mm:ss)
#SBATCH --mail-user rayna.harris@utexas.edu     
#SBATCH --mail-type END # when to notify email
#SBATCH -A NeuroEthoEvoDevo    # sets the allocation if you have mutiple to chose from
#------------------------------------------------------

module load launcher
setenv EXECUTABLE     $TACC_LAUNCHER_DIR/init_launcher 
setenv CONTROL_FILE   05_kallistoquant_cmds.cmds
setenv WORKDIR        /work/02189/rmharris/SingleNeuronSeq/results/03_trimmedreads_filtered_2016-03-02
# 
# Variable description:
#
#  EXECUTABLE     = full path to the job launcher executable
#  CONTROL_FILE   = text input file which specifies
#                   executable for each process
#                   (should be located in WORKDIR)
#  WORKDIR        = location of working directory
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

module use /work/03439/wallen/public/modulefiles
module swap intel gcc/4.9.1
module load hdf5/1.8.15
module load zlib/1.2.8
module load gcc/4.9.1
module load kallisto

$TACC_LAUNCHER_DIR/paramrun $EXECUTABLE $CONTROL_FILE

echo " "
echo " 05_kallisto_launcher.slurm Job Complete"
echo " "
