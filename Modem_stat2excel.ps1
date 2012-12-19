Set-PSDebug -Trace 0
$erroractionpreference = "SilentlyContinue"
$rackfilepath = "\\eswki02inst.eld.ki.sw.ericsson.se\ranrack$\admin\scripts\rackfiles\"
$ping = New-Object System.Net.NetworkInformation.Ping
$computers = $null
$pingedOK = $null
$Bootup = $null
$LastBootUpTime =$null
$Uptime = $null

#setup excel sheet
$a = New-Object -comobject Excel.Application
$a.visible = $True

$b = $a.Workbooks.Add()
$c = $b.Worksheets.Item(1)

$c.Cells.Item(1,1) = "SystemName"
$c.Cells.Item(1,2) = "ModemName"
$c.Cells.Item(1,3) = "AttachedTo"
$c.Cells.Item(1,4) = "Status"
$c.Cells.Item(1,5) = "StatusInfo"
$c.Cells.Item(1,6) = "NumberOfFaults"
$c.Cells.Item(1,7) = "Driverdate"
$intRow = 2
function WMIDateStringToDate($Bootup)
    {
    [System.Management.ManagementDateTimeconverter]::ToDateTime($Bootup)
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
			
	get-wmiobject "Win32_POTSModem" -computername $item|
	#Where-Object  {$_.Status -ne "OK"} |
	Select-Object SystemName,Name,AttachedTo,Status,StatusInfo, @{Name="DriverDate";Expression={$_.DriverDate.Substring(0,8)
		}}|Export-Csv .\test.csv
		Get-Content test1.csv | ForEach-Object { $_.replace(',', "`t") }|Out-File test2.csv
		.\test2.csv

		#Format-table -AutoSize 
		
	#	@{Name="DriverDate";Expression={$_.Substring(0,8)
	$c.Cells.Item($intRow,1) = Get-Date
	$c.Cells.Item($intRow,2) = $_.Name
	$c.Cells.Item($intRow,3) = $_.AttachedTo
	$c.Cells.Item($intRow,4) = $_.Status
	$c.Cells.Item($intRow,5) = $_.StatusInfo
	$c.Cells.Item($intRow,6) = $_.DriverDate.Substring(0,8)
	$c.Cells.Item($intRow,7) = $Computer.Manufacturer
	$intRow = $intRow + 1

$d.EntireColumn.AutoFit()

} 
else 
		{	
			Write-Host $item "Not available" -ForegroundColor Red
#			$c.Cells.Item($intRow,1) = $item "Not available"
			$intRow = $intRow + 1
		}
	}
#Clear-Variable *

#$computers | ForEach-Object {$ping.Send($_)}
#$pingedOK | ForEach-Object {get-wmiobject "Win32_POTSModem" -computername $_.address}|
#Where-Object  {$_.Status -ne "OK"} |Select-Object SystemName,Name,AttachedTo,Status,StatusInfo,DriverDate |Format-table

