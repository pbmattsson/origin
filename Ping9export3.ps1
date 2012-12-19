Set-PSDebug -Trace 0
$erroractionpreference = "SilentlyContinue"
$rackfilepath = "\\eswki02inst.eld.ki.sw.ericsson.se\ranrack$\admin\scripts\rackfiles\"
$resultdir = "\\eswki02inst.eld.ki.sw.ericsson.se\ranrack$\admin\scripts\resultfiles\" #Directory for accessed files
$ping = New-Object System.Net.NetworkInformation.Ping
$computers = $null
$pingedOK = $null
$Bootup = $null
$LastBootUpTime =$null
$Uptime = $null
$item = $null


function WMIDateStringToDate($Bootup)
    {
    [System.Management.ManagementDateTimeconverter]::ToDateTime($Bootup)
    }    

foreach($rack in $args)

{
	if (Test-Path $rackfilepath$rack".txt")

		{
    		$rackfilepath+$rack+".txt"+" File found" 
			$computers += (Get-content $rackfilepath$rack".txt")
			#$computers = Get-content $rackfilepath$item".txt" 
		}
	else
{
    $rackfilepath+$rack+".txt"+"  Does not exist"
}}
Write-Host
Write-Host "Now pinging" $computers -ForegroundColor Green
Write-Host
#ForEach-Object {$ping.Send($_)}
ForEach ($item in $computers) 
	{
	$pingresult = $ping.Send($item)
	if ($pingresult.status –eq “Success”)
	#if ($ping.Send($item))
		{
			$systems = Get-WMIObject -class Win32_OperatingSystem -ComputerName $item

			$Bootup = $systems.LastBootUpTime
			$LastBootUpTime = WMIDateStringToDate($Bootup)
			$now = Get-Date
            $Uptime = $now - $lastBootUpTime
            $d = $Uptime.Days
            $h = $Uptime.Hours
            $m = $uptime.Minutes
            # Display uptime
            $retval = [string]::format("{0} Days {1} Hours {2} Minutes", $d,$h,$m)
			Write-Host $item "pinged OK" "System uptime = " $retval -ForegroundColor Green
			Write-Host
			Write-Host "Retreiving modem status from" $item -ForegroundColor Blue
			
	get-wmiobject "Win32_POTSModem" -computername $item|Where-Object  {$_.Status -ne "OK"} |
	Select-Object SystemName,Name,AttachedTo,Status,StatusInfo, @{Name="DriverDate";Expression={$_.DriverDate.Substring(0,8)
		}}|Export-csv c:\$rack.csv -Append
		Get-Content c:\$rack.csv | ForEach-Object { $_.replace(',', "`t") }|Out-File $resultdir$rack.csv
#Format-table -AutoSize |
	
		
	#	@{Name="DriverDate";Expression={$_.Substring(0,8)
} 
else 
		{	
			Write-Host $item "Not available" -ForegroundColor Red
		}
	}
	get-content $resultdir$rack.csv | group | Where-Object {$_.count -gt 10} | ForEach-Object {$_.group}
Clear-Variable *

#$computers | ForEach-Object {$ping.Send($_)}
#$pingedOK | ForEach-Object {get-wmiobject "Win32_POTSModem" -computername $_.address}|
#Where-Object  {$_.Status -ne "OK"} |Select-Object SystemName,Name,AttachedTo,Status,StatusInfo,DriverDate |Format-table

