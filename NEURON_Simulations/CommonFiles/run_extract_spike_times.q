#!/bin/bash
#
#SBATCH --mem-per-cpu=10G
#SBATCH -p wmglab
#SBATCH -t 3-00:00:00
#SBATCH --array=1-25
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1

DONE="flags/spk_times_done_${base_amp_nA}_${disc_amp_nA}_${SLURM_ARRAY_TASK_ID}.flag"
rm -f "$DONE"

# Launch MATLAB in the background
setsid /opt/apps/rhel8/matlabR2022b/bin/matlab -nodisplay -nosplash -batch "extract_spike_times($SLURM_ARRAY_TASK_ID, $base_amp_nA, $disc_amp_nA)" < /dev/null & MPID=$!

MAX_WAIT=3600
elapsed=0
while [ $elapsed -lt $MAX_WAIT ]; do
    if ls -la "$DONE" >/dev/null 2>&1; then
        sleep 1
        break
    fi
    if ! kill -0 $MPID 2>/dev/null; then
        break
    fi
    sleep 2
    elapsed=$((elapsed+2))
done

kill -9 -- -$MPID 2>/dev/null
pkill -9 -P $MPID 2>/dev/null
kill -9 $MPID 2>/dev/null

exit 0
