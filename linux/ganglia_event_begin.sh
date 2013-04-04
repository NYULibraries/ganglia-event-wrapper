#!/bin/bash
################################################################################
# ganglia_event_begin.sh                                                       #
# Adds an event to Ganglia when a generic job begins                           #
# Readme can be found at https://github.com/bswinnerton/ganglia-event-wrapper  #
# Created by: bs122 @ New York University                                      #
# Modified: 2013-04-04                                                         #
################################################################################

### Change variables below as needed

# Ganglia host (the only thing you should need to change)
ganglia_host="ganglia.library.nyu.edu"

# Temporary folder path to store ganglia event id
temp_dir="/tmp"

# Dynamically set the hostname
server_name=$(hostname)

### End variable assignment




# Get passed arguments and set default if not passed
summary_text=$1
if [ -z "$summary_text" ]; then
    summary_text="Unknown Event"
fi

# Clean up passed parameters for file and safe URL
temp_name=${summary_text// /_}
summary_text=${summary_text// /%20}

# Define temp filename
temp_file="ganglia_${temp_name}_begin.txt"

# Remove temp file if it already exists
if [[ -f $temp_dir/$temp_file ]]; then
    rm $temp_dir/$temp_file
fi

# Execute API call
curl "http://$ganglia_host/api/events.php?action=add&start_time=now&summary=${summary_text}&host_regex=${server_name}" > "$temp_dir/$temp_file"