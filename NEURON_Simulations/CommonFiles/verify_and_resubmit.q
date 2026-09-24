#!/bin/bash
#SBATCH -p wmglab
#SBATCH -t 3-00:00:00
#SBATCH --ntasks=1

expected=25
max_retries=10
attempt=0

while [[ $attempt -lt $max_retries ]]; do
    missing=()
    for i in $(seq 1 $expected); do
        [[ -f "markers/${base_amp_nA}_${disc_amp_nA}_nA/cell_${i}.done" ]] || missing+=($i)
    done

    if [[ ${#missing[@]} -eq 0 ]]; then
        echo "All $expected cells complete."
        exit 0
    fi

    echo "Missing cells: ${missing[*]} — resubmitting."
    ids=$(IFS=,; echo "${missing[*]}")
    rerun_id=$(sbatch --array=$ids --export=base_amp_nA=$base_amp_nA,disc_amp_nA=$disc_amp_nA run_model.q | awk '{print $NF}')
    sbatch --wait --dependency=afterany:$rerun_id --export=base_amp_nA=$base_amp_nA,disc_amp_nA=$disc_amp_nA --wrap="exit 0" > /dev/null

    ((attempt++))
done

echo "ERROR: still missing cells after $max_retries attempts: ${missing[*]}"
exit 1