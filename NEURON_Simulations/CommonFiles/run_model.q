#!/bin/bash
#SBATCH --mem-per-cpu=4G
#SBATCH -p wmglab
#SBATCH -t 3-00:00:00
#SBATCH --array=1-25
#SBATCH --ntasks=400
#SBATCH --cpus-per-task=1
#SBATCH --requeue
module load OpenMPI/4.0.5-rhel8

marker_dir="markers/${base_amp_nA}_${disc_amp_nA}_nA"
marker="${marker_dir}/cell_${SLURM_ARRAY_TASK_ID}.done"

mkdir -p "$marker_dir"

if [[ -f "$marker" ]]; then
    echo "Task $SLURM_ARRAY_TASK_ID already complete, skipping."
    exit 0
fi

mpirun -np $SLURM_NTASKS /opt/apps/rhel8/nrn-7.6/x86_64/bin/nrniv -NSTACK 100000 -NFRAME 20000 -Py_NoSiteFlag -nobanner -c -mpi "cell_id=$SLURM_ARRAY_TASK_ID" -c "base_amp_nA=$base_amp_nA" -c "disc_amp_nA=$disc_amp_nA" init_icms.hoc
mpirun_exit=$?

if [[ $mpirun_exit -ne 0 ]]; then
    echo "Task $SLURM_ARRAY_TASK_ID failed (exit $mpirun_exit), not marking done."
    exit 1
fi

touch "$marker"