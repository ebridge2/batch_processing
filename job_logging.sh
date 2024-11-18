#!/bin/bash

# Start the monitoring in background, using the container's own PID as the log name
(
    while true; do
        echo "$(date '+%Y-%m-%d %H:%M:%S'),$(ps -p 1 -o %cpu,%mem | tail -1),$(df -h / | tail -1 | awk '{print $5}')" >> /batch/resource_usage.log
        sleep 1
    done
) &
MONITOR_PID=$!

cd /code
# Run your actual command
cpac run --pipeline-file=/batch/pipeline_config_batcheffects.yml /data/inputs /data/outputs participant

cd -
# When the command finishes, stop the monitoring
kill $MONITOR_PID
