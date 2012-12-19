#System Administrators may find this script helpful for pulling System Uptime information for a list of hosts. Again we are using the list-processing template posted previously on this site to handle any number of hostnames and then using the WMI Win32_OperatingSystem class for our boot-time data to calculate system uptime. Note that WMI stores date/time information a bit differently so we need to do a quick conversion in the WMIDateStringToDate function. Further refinements to this script that will be addressed in a future posting will include handling of offline systems and unresponsive WMI calls.

#?[Copy to clipboard]View Code POWERSHELL
$psScriptName = "Get-Uptime.ps1"
$psScriptAuth = "Kahuna at PoshTips.com"
$psScriptDate = "11/23/2009"
##############################################################################
## Get-Uptime.ps1 - powershell script template
##
## Original Script by Kahuna at PoshTips.com - 11/23/2009
##
## Maintenance (most recent updates at top):
## Date        By   Comments
## ----------  ---  ----------------------------------------------------------
## 11/23/2009  KPS  new script
##
##############################################################################
$scriptUsage = @"
==============================================================================
 SCRIPT  : $psScriptName
 AUTHOR  : $psScriptAuth
 VERSION : $psScriptDate
==============================================================================
 PURPOSE:
    powershell script to retrieve system uptime from a host or list of hosts
    Uptime is displayed as : (days) hours:minutes
 
 USAGE:
 
    Get-Uptime [hostname(s) | filename(s)]
 
    - From the PowerShell command-line, invoke the script, passing any combination
      of hostnames and filenames (text file(s) containing a hostname listing
    - Any combinations and number of arguments can be used
    - if an argument is a filename:
         - each line in the file will processed as a hostname
         - any lines starting with `# will be treated as comments and ignored
    - if an argument is not a filename:
         - the argument will processed as a hostname
 
  EXAMPLES:
              ./Get-Uptime server1 hostlist.txt server2 server3 
 
              ./Get-Uptime host1 host2 host2 
 
==============================================================================
"@
 
Set-PSDebug -Trace 0
$script:recCount = 0
 
function ShowUsage([string]$message="")
    {
    $message
    $scriptUsage
    exit
    }
 
function WMIDateStringToDate($Bootup)
    {
    [System.Management.ManagementDateTimeconverter]::ToDateTime($Bootup)
    }    
 
function QueryWMI([string]$hostname)
    {
    Trap {continue;}
 
    $computers = Get-WMIObject -class Win32_OperatingSystem -ComputerName $hostname
    if ($computers)
        {
        # There had better only be one object returned, but...
        foreach ($system in $computers)
            {
            # work out uptime
            $Bootup = $system.LastBootUpTime
            $LastBootUpTime = WMIDateStringToDate($Bootup)
            $now = Get-Date
            $Uptime = $now - $lastBootUpTime
            $d = $Uptime.Days
            $h = $Uptime.Hours
            $m = $uptime.Minutes
            $ms= $uptime.Milliseconds
            # Display uptime
            $retval = [string]::format("({0}){1}:{2}", $d,$h,$m)
	    return($retval)
            }
        }
        "ERROR"
    }
 
function ProcessHost([string]$hostname)
    {
    ++$script:recCount; $d1 = ""; $d2 = ""
    $d1 = QueryWMI($hostname)
    [string]::Format("{0},{1},{2}", $script:recCount,$hostname,$d1)
    }  
 
######################################################
## MAIN
######################################################
if ($args.count)
    {
    # Process command-line flags
    foreach ($item in $args)
        {
        if ($item -like "-*")
            {
            ShowUsage "ERROR: $item is invalid! This script does not accept any options";
            }
        }
    # Write the CSV header
    "LN,HostName,Uptime"
 
    # Process non-flag arguments
    foreach ($item in $args)
        {
        if ($item -notlike "-*")
            {
            # if argument is filename: process file contents
            if (test-path($item))
                {
                foreach ($hostname in get-content $item)
                    {
                    $hostname = $hostname.trim()
                    if ($hostname -notlike "#*")
                        {
                        ProcessHost $hostname
                        }
                    }
                }
            # else treat as hostname
            else
                {
                ProcessHost($item)
                }
            }
        }
    }
else
  {
  ShowUsage
  } 
