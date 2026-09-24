#!/bin/bash
#
#SBATCH -p wmglab
#SBATCH -t 3-00:00:00

DONE="flags/create_folder_done_${base_amp_nA}_${disc_amp_nA}.flag"
rm -f "$DONE"

# Launch MATLAB in the background
setsid /opt/apps/rhel8/matlabR2022b/bin/matlab -nodisplay -nosplash -batch "create_data_folders($base_amp_nA,$disc_amp_nA)" < /dev/null & MPID=$!

MAX_WAIT=300
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
