Set-PSDebug -Trace 0
$erroractionpreference = "SilentlyContinue"
$rackfilepath = "\\eswki02inst.eld.ki.sw.ericsson.se\ranrack$\admin\scripts\rackfiles\"
$ping = New-Object System.Net.NetworkInformation.Ping
$computers = $null
$pingedOK = $null
$computername = $null

function WMIDateStringToDate($Bootup)
    {
    [System.Management.ManagementDateTimeconverter]::ToDateTime($Bootup)
    }    

function Check-Online {

       param(

              $computername

       )

 

       test-connection -count 1 -ComputerName $computername -TimeToLive 15 -asJob -ThrottleLimit 100 |

       Wait-Job |

       Receive-Job |

       Where-Object { $_.StatusCode -eq 0 } |

       Select-Object -ExpandProperty Address

}
foreach($item in $args)

{
	if (Test-Path $rackfilepath$item".txt")

		{
    		$rackfilepath+$item+".txt"+" File found" 
			$computers += (Get-content $rackfilepath$item".txt")
			#$computers = Get-content $rackfilepath$item".txt" 
		}
	else
{
    $rackfilepath+$item+".txt"+"  Does not exist"
}}
Write-Host
Write-Host "Now pinging" $computers -ForegroundColor Green
Write-Host
#ForEach-Object {$ping.Send($_)}

$online = Check-Online -computername $computers

$online |sort





ForEach ($computername in $online) 
	{
	$pingresult = $ping.Send($computername)
	if ($pingresult.status –eq “Success”)
	#if ($ping.Send($item))
		{
			$systems = Get-WMIObject -class Win32_OperatingSystem -ComputerName $computername

			$Bootup = $systems.LastBootUpTime
			$LastBootUpTime = WMIDateStringToDate($Bootup)
			$now = Get-Date
            $Uptime = $now - $lastBootUpTime
            $d = $Uptime.Days
            $h = $Uptime.Hours
            $m = $uptime.Minutes
            # Display uptime
            $retval = [string]::format("{0} Days {1} Hours {2} Minutes", $d,$h,$m)
			Write-Host $computername "pinged OK" "System uptime = " $retval -ForegroundColor Green
			Write-Host
			Write-Host "Retreiving modem status from" $computername -ForegroundColor Blue
			
	get-wmiobject "Win32_POTSModem" -computername $computername|
	Where-Object  {$_.Status -ne "OK"} |Select-Object SystemName,Name,AttachedTo,Status,StatusInfo, @{Name="DriverDate";Expression={$_.DriverDate.Substring(0,8)
		}}|Format-table -AutoSize
		
	#	@{Name="DriverDate";Expression={$_.Substring(0,8)
} 
else 
		{	
			Write-Host $computername "Not available" -ForegroundColor Red
		}
	}

#$computers | ForEach-Object {$ping.Send($_)}
#$pingedOK | ForEach-Object {get-wmiobject "Win32_POTSModem" -computername $_.address}|
#Where-Object  {$_.Status -ne "OK"} |Select-Object SystemName,Name,AttachedTo,Status,StatusInfo,DriverDate |Format-table


