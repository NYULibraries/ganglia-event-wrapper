################################################################################
# ganglia_event_begin.ps1                                                      #
# Adds an event to Ganglia when a generic job begins                           #
# Readme can be found at https://github.com/bswinnerton/ganglia-event-wrapper  #
# Created by: rdf6 @ New York University                                       #
# Modified: 2013-04-04 @ bs122                                                 #
################################################################################

### Change variables below as needed

# Ganglia host (the only thing you should need to change)
$ganglia_host = "ganglia.library.nyu.edu"

# Temporary folder path to store ganglia event id
$temp_dir = $env:temp

# Dynamically set the hostname
$server_name = hostname

### End variable assignment




# Get passed arguments and set default if not passed
$summary_text=$args[0]
if ($summary_text -eq $null)
{
    $summary_text = "Unknown Event"
}

# Clean up passed parameters for file and safe URL
$temp_name = $summary_text.Replace(" ", "_")
$summary_text = $summary_text.Replace(" ", "%20")

# Define temp filename
$temp_file = "ganglia_${temp_name}_begin.txt"

# Remove temp file if it already exists
if (Test-Path -path $temp_dir\$temp_file)
{
	Remove-Item $temp_dir\$temp_file
}

# Convert server name to lowercase (ganglia will have a hissyfit otherwise)
$server_name = $server_name.toLower()

# Exectute API call
(new-object net.webclient).DownloadString("http://$ganglia_host/api/events.php?action=add&start_time=now&summary=$summary_text&host_regex=$server_name") > $temp_dir\$temp_file