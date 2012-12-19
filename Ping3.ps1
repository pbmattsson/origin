$rackfilepath = "\\eswki02inst.eld.ki.sw.ericsson.se\ranrack$\admin\scripts\rackfiles\"
$ping = New-Object System.Net.NetworkInformation.Ping
$computers = $null
$pingedOK = $null
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
$boottime = $systems.LastBootUpTime
Write-Host $item "pinged ok"
Write-Host $systems.LastBootUpTime}
get-wmiobject "Win32_POTSModem" -computername $item|
Where-Object  {$_.Status -ne "OK"} |Select-Object SystemName,Name,AttachedTo,Status,StatusInfo,DriverDate |Format-table

}
#$computers | ForEach-Object {$ping.Send($_)}
#$pingedOK | ForEach-Object {get-wmiobject "Win32_POTSModem" -computername $_.address}|
#Where-Object  {$_.Status -ne "OK"} |Select-Object SystemName,Name,AttachedTo,Status,StatusInfo,DriverDate |Format-table

