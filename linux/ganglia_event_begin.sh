#!/bin/bash
# Adds an event to Ganglia when a generic job begins
# Created by: bs122
# Modified: 2013-04-04

# Get passed arguments and set default if not passed
summary_text=$1
if [ -z "$summary_text" ]; then
    summary_text="Unknown Event"
fi

# Clean up passed parameters for file and safe URL
temp_name=${summary_text// /_}
summary_text=${summary_text// /%20}

# Get user temp directory
temp_dir="/tmp"

# Define temp filename
temp_file="ganglia_${temp_name}_begin.txt"

# Remove temp file if it already exists
if [[ -f $temp_dir/$temp_file ]]; then
    rm $temp_dir/$temp_file
fi

# Get server name
server_name=$(hostname)

# Execute API call
curl "http://ganglia.library.nyu.edu/api/events.php?action=add&start_time=now&summary=${summary_text}&host_regex=${server_name}" > "$temp_dir/$temp_file"