# Adds an event to Ganglia when a generic job ends
# Script can take one argument, which is the name of the summary text assigned
#  in ganglia
# Created by: rdf6
# Modified: 2013-04-04 @ bs122

# Get passed arguments and set default if not passed
$summary_text=$args[0]
if ($summary_text -eq $null)
{
    $summary_text = "Unknown Event"
}

# Clean up passed parameters for safe URL and file
$temp_name = $summary_text.Replace(" ", "_")

# Get user temp directory
$temp_dir = $env:temp

# Define temp filename
$temp_file = "ganglia_${temp_name}_begin.txt"

# Grab data from temp file and set as variable
$data = Get-Content $temp_dir\$temp_file

# Check if temp file exists, if not assume event was never added and do nothing
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