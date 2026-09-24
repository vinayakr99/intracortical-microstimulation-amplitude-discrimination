#!/bin/bash
#
#SBATCH -p wmglab
#SBATCH -t 3-00:00:00

export SLURM_EXPORT_ENV=ALL

prev_job_id=""

# Stim Amps
base_amps_nA=(3000 3000 3000 3000 3000 3500 3500 3500 3500 4000 4000 4000 4000)
disc_amps_nA=(200 400 500 700 1200 200 500 900 1500 200 600 1100 1800)

total_stim=${#base_amps_nA[@]}

# Loop through stims and run simulations
for stim in $(seq 1 $total_stim); do

    base_amp_nA=${base_amps_nA[$((stim-1))]}
    disc_amp_nA=${disc_amps_nA[$((stim-1))]}

    echo "=========================================="
    echo "Stim $stim / $total_stim"
    echo "Base amplitude: $base_amp_nA nA"
    echo "Discrimination amplitude: $disc_amp_nA nA"
    echo "=========================================="

    # Create data folders for this stim
    dep=""
    if [[ $stim -ne 1 ]]; then
        dep="--dependency=afterok:$prev_job_id"
    fi
    job_id=$(sbatch $dep --export=base_amp_nA=$base_amp_nA,disc_amp_nA=$disc_amp_nA run_create_data_folders.q | awk '{print $NF}')
    prev_job_id=$job_id

    # Run the neuron simulations for this stim
    job_id=$(sbatch --dependency=afterok:$prev_job_id --export=base_amp_nA=$base_amp_nA,disc_amp_nA=$disc_amp_nA run_model.q | awk '{print $NF}')
    prev_job_id=$job_id

    # Block here until every cell for this amp is confirmed complete (or retries exhausted)
    sbatch --wait --dependency=afterany:$prev_job_id --export=base_amp_nA=$base_amp_nA,disc_amp_nA=$disc_amp_nA verify_and_resubmit.q
    if [[ $? -ne 0 ]]; then
        echo "Stim $stim (amp $base_amp_nA $disc_amp_nA) failed verification after retries — aborting chain."
        exit 1
    fi

    # Run extract spike times for this stim
    job_id=$(sbatch --export=base_amp_nA=$base_amp_nA,disc_amp_nA=$disc_amp_nA run_extract_spike_times.q | awk '{print $NF}')
    prev_job_id=$job_id
done