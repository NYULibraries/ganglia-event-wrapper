#!/bin/bash
# Adds an event to Ganglia when ArcServe backup agent executes a backup job
# Created by: bs122
# Modified: 2013-04-03

# Get passed arguments and set default if not passed
summary_text=$1
if [ -z "$summary_text" ]; then
    summary_text="Unknown Event"
fi

# Clean up passed parameters for file and safe URL
temp_name=${summary_text// /_}

# Get user temp directory
temp_dir="/tmp"

# Define temp filename
temp_file="ganglia_${temp_name}_begin.txt"

# Grab data from temp file and set as variable
data=$(cat $temp_dir/$temp_file)

regex='.*\"status\":\"([a-zA-Z]*)\".*\"event_id\":\"([0-9a-f]*)\".*'

if [ -f "$temp_dir/$temp_file" ]; then
    if [[ $data =~ $regex ]]; then
        status=${BASH_REMATCH[1]}
        event_id=${BASH_REMATCH[2]}
        if [[ $status == "ok" ]]; then
            curl "http://ganglia.library.nyu.edu/api/events.php?action=edit&event_id=$event_id&end_time=now"
        fi
    fi
fi