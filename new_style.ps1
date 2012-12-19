function Check-Online {

       param( $computername)

       test-connection -count 1 -ComputerName $computername -TimeToLive 15 -asJob -ThrottleLimit 100 |

       Wait-Job |

       Receive-Job |

       Where-Object { $_.StatusCode -eq 0 } |

       Select-Object -ExpandProperty Address
}

function Get-PCUptime {

	param($computername)

	$lastboottime = (Get-WmiObject -Class Win32_OperatingSystem -computername $computername).LastBootUpTime

	$sysuptime = (Get-Date) – [System.Management.ManagementDateTimeconverter]::ToDateTime($lastboottime)
	
	$computername |add-member  -membertype noteproperty -name UptimeStatus -value $sysuptime.days
	
	if ($_.uptimestatus -lt 15)
		{
				$script:activecomputers += ($_)
		}

	Write-Host $computername" has been up for: ” $sysuptime.days “days” $sysuptime.hours `
	“hrs” $sysuptime.minutes “min” $sysuptime.seconds “sec”

}
function Get-ModemStatus {
	param($computername)
	get-wmiobject "Win32_POTSModem" -computername $computername|Where-Object  {$_.Status -ne "OK"} |
		Select-Object SystemName,Name,AttachedTo,Status,StatusInfo, @{Name="DriverDate";Expression={$_.DriverDate.Substring(0,8)
		}}|Export-csv c:\$rack.csv -Append -Delimiter ";"
		Write-Host Entries added to c:\$rack.csv 
		}
###################		
#     MAIN        #
# by B Mattsson   #
#    2011-02      #
###################
$uptime = "22"
foreach($rack in $args)

{
	if (Test-Path $rackfilepath$rack".txt")

		{
    		$rackfilepath+$rack+".txt"+" File found" 
			$allcomputers = (Get-content $rackfilepath$rack".txt")
			
			foreach ($computer in $allcomputers)
			{
			if (Check-Online $computer)
#			{Write-Host $computer "is online"
			{Get-PCUptime $computer 
	
				if ($computer.uptimestatus -lt $uptime)
				{Write-Host $computer "has an uptime of :" $computer.uptimestatus "days"
				Get-ModemStatus $computer} 
				else 
				{Write-Host $computer "has an uptime that exceeds" $uptime "days, No modem status checked"}}
	
			Else
			{ Write-Host $computer "is not online" -ForegroundColor Red	}
			
			
		}}
	else
{
    $rackfilepath+$rack+".txt"+"  Does not exist" 
}
}

