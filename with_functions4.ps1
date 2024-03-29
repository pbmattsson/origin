﻿$computername = $NULL # Computers tested by Check-Online
$computers = $NULL # Computers read in from files
$online = $null #Computers that are online
$rackfilepath = "\\eswki02inst.eld.ki.sw.ericsson.se\ranrack$\admin\scripts\rackfiles\"
$script:activecomputers = $NULL # Computers that has an uptime of less than 2 days 
$script:activecomputers = @()
function Check-Online {

       param( $computername)

       test-connection -count 1 -ComputerName $computername -TimeToLive 15 -asJob -ThrottleLimit 100 |

       Wait-Job |

       Receive-Job |

       Where-Object { $_.StatusCode -eq 0 } |

       Select-Object -ExpandProperty Address
#Write-Host ($_.OnlineStatus)
}

function Get-PCUptime {

	param($computername)

	$lastboottime = (Get-WmiObject -Class Win32_OperatingSystem -computername $computername).LastBootUpTime

	$sysuptime = (Get-Date) – [System.Management.ManagementDateTimeconverter]::ToDateTime($lastboottime)
	#if ($_.Statuscode -eq 0)
	#{Write-Host $computer" is not online"}
	#else
	$_ |add-member  -membertype noteproperty -name UptimeStatus -value $sysuptime.days
	
	if ($_.uptimestatus -lt 15)
		{
		

		$script:activecomputers += ($_)
		}

	Write-Host $computername" has been up for: ” $sysuptime.days “days” $sysuptime.hours `
	“hrs” $sysuptime.minutes “min” $sysuptime.seconds “sec”

}

foreach($rack in $args)

{
	if (Test-Path $rackfilepath$rack".txt")

		{
    		$rackfilepath+$rack+".txt"+" File found" 
			$computers += (Get-content $rackfilepath$rack".txt")
			
		}
	else
{
    $rackfilepath+$rack+".txt"+"  Does not exist"
}}

$online = (Check-Online -computername $computers)
# Adding a new property:
	#$computername |add-member -membertype noteproperty -name OnlineStatus -value NotSet
#$online | sort | foreach-object {Get-PCuptime -computer ($_ )}|Where-Object {$_.uptimestatus -lt 15}
$online | sort | foreach-object {Get-PCuptime -computer ($_ )}

ForEach ($item in $script:activecomputers )
	{get-wmiobject "Win32_POTSModem" -computername $item|Where-Object  {$_.Status -ne "OK"} |
		Select-Object SystemName,Name,AttachedTo,Status,StatusInfo, @{Name="DriverDate";Expression={$_.DriverDate.Substring(0,8)
		}}|Export-csv c:\$rack.csv -Append
		}