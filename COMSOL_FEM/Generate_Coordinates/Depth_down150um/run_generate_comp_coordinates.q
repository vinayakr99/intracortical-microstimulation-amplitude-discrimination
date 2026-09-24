#!/bin/bash
#
#SBATCH --mem-per-cpu=50G
#SBATCH -p wmglab
#SBATCH --array=1-25
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
/opt/apps/rhel8/matlabR2022b/bin/matlab -nodisplay -r "generate_comp_coordinates($SLURM_ARRAY_TASK_ID); exit;"
