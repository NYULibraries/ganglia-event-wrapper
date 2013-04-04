################################################################################
# ganglia_event_end.ps1                                                        #
# Ends an event to Ganglia when a generic job completes                        #
# Readme can be found at https://github.com/bswinnerton/ganglia-event-wrapper  #
# Created by: rdf6 @ New York University                                       #
# Modified: 2013-04-04 @ bs122                                                 #
################################################################################

### Change variables below as needed

# Ganglia host (the only thing you should need to change)
$ganglia_host = "ganglia.library.nyu.edu"

# Temporary folder path to store ganglia event id
$temp_dir = $env:temp

### End variable assignment




# Get passed arguments and set default if not passed
$summary_text=$args[0]
if ($summary_text -eq $null)
{
    $summary_text = "Unknown Event"
}

# Clean up passed parameters for safe URL and file
$temp_name = $summary_text.Replace(" ", "_")

# Define temp filename
$temp_file = "ganglia_${temp_name}_begin.txt"

# Grab data from temp file and set as variable
$data = Get-Content $temp_dir\$temp_file

# Execute API call if all looks good (or don't if the temp file doesn't exist)
if (Test-Path -path $temp_dir\$temp_file)
{
	# Use regex to grab the status code
    $status = ([regex]'.*\"status\":\"([a-zA-Z]*)\".*\"event_id\":\"([0-9a-f]*)\".*').match($data).groups[1].value
    
	if ($status -eq "ok")
	{
		# Parse resulting line for event id
        $event_id = ([regex]'.*\"status\":\"([a-zA-Z]*)\".*\"event_id\":\"([0-9a-f]*)\".*').match($data).groups[2].value
		
		# Add backup event end time to Ganglia
		(new-object net.webclient).DownloadString("http://ganglia.library.nyu.edu/api/events.php?action=edit&event_id=$event_id&end_time=now")
    }
}