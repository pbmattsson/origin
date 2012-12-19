Set-PSDebug -Trace 0
$rackfilepath = "\\eswki02inst.eld.ki.sw.ericsson.se\ranrack$\admin\scripts\rackfiles\"
$ping = New-Object System.Net.NetworkInformation.Ping
$computers = $null
$pingedOK = $null

function WMIDateStringToDate($Bootup)
    {
    [System.Management.ManagementDateTimeconverter]::ToDateTime($Bootup)
    }    

foreach($item in $args)

{if (Test-Path $rackfilepath$item".txt")

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
ForEach ($item in $computers) {if ($ping.Send($item))
{
$systems = Get-WMIObject -class Win32_OperatingSystem -ComputerName $item

Write-Host $item "pinged ok"
 $Bootup = $systems.LastBootUpTime
$LastBootUpTime = WMIDateStringToDate($Bootup)
Write-Host "System uptime = " $LastBootUpTime}
get-wmiobject "Win32_POTSModem" -computername $item|
Where-Object  {$_.Status -ne "OK"} |Select-Object SystemName,Name,AttachedTo,Status,StatusInfo,DriverDate |Format-table

}
#$computers | ForEach-Object {$ping.Send($_)}
#$pingedOK | ForEach-Object {get-wmiobject "Win32_POTSModem" -computername $_.address}|
#Where-Object  {$_.Status -ne "OK"} |Select-Object SystemName,Name,AttachedTo,Status,StatusInfo,DriverDate |Format-table


