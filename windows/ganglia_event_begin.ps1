# Adds an event to Ganglia when a generic job begins
# Script can take one argument, which is the name of the summary text assigned
#  in ganglia
# Created by: rdf6
# Modified: 2013-03-26 @ bs122

# Get passed arguments and set default if not passed
$summary_text=$args[0]
if ($summary_text -eq $null)
{
    $summary_text = "Unknown Event"
}

# Clean up passed parameters for file and safe URL
$temp_name = $summary_text.Replace(" ", "_")
$summary_text = $summary_text.Replace(" ", "%20")

# Get user temp directory
$temp_dir = $env:temp

# Define temp filename
$temp_file = "ganglia_${temp_name}_begin.txt"

# Remove temp file if it already exists
if (Test-Path -path $temp_dir\$temp_file)
{
	Remove-Item $temp_dir\$temp_file
}

#Get server name
$server_name = hostname

#Convert server name to lowercase (required by Ganglia)
$server_name = $server_name.toLower()

#Add backup event start time to Ganglia
(new-object net.webclient).DownloadString("http://ganglia.library.nyu.edu/api/events.php?action=add&start_time=now&summary=$summary_text&host_regex=$server_name") > $temp_dir\$temp_file