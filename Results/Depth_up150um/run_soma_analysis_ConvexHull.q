#!/bin/bash
#
#SBATCH --mem-per-cpu=10G
#SBATCH -p wmglab
#SBATCH --array=1-54
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
/opt/apps/rhel7/matlabR2020a/bin/matlab -nodisplay -r "soma_analysis_ConvexHull($SLURM_ARRAY_TASK_ID); exit;"
