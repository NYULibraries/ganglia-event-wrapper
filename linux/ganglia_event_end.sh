#!/bin/bash
################################################################################
# ganglia_event_end.sh                                                         #
# Ends an event to Ganglia when a generic job completes                        #
# Readme can be found at https://github.com/bswinnerton/ganglia-event-wrapper  #
# Created by: bs122 @ New York University                                      #
# Modified: 2013-04-04                                                         #
################################################################################

### Change variables below as needed

# Ganglia host (the only thing you should need to change)
ganglia_host="ganglia.library.nyu.edu"

# Get user temp directory
temp_dir="/tmp"

### End variable assignment




# Get passed arguments and set default if not passed
summary_text=$1
if [ -z "$summary_text" ]; then
    summary_text="Unknown Event"
fi

# Clean up passed parameters for file and safe URL
temp_name=${summary_text// /_}

# Define temp filename
temp_file="ganglia_${temp_name}_begin.txt"

# Grab data from temp file and set as variable
data=$(cat $temp_dir/$temp_file)

# Define the regular expression to parse the event id from ganglia_event_begin
regex='.*\"status\":\"([a-zA-Z]*)\".*\"event_id\":\"([0-9a-f]*)\".*'

# Execute API call if all looks good (or don't if the temp file doesn't exist)
if [ -f "$temp_dir/$temp_file" ]; then
    if [[ $data =~ $regex ]]; then
        status=${BASH_REMATCH[1]}
        event_id=${BASH_REMATCH[2]}
        if [[ $status == "ok" ]]; then
            curl "http://$ganglia_host/api/events.php?action=edit&event_id=$event_id&end_time=now"
        fi
    fi
fi