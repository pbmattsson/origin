$rackfilepath = "\\eswki02inst\ranrack$\admin\scripts\rackfiles\"
$usage = @"
             This script returns the status of modems on remote systems,

		         Syntax: .\scriptfile.ps1 host-file [output-file]
				 
				 Example: .\get_modem_status.ps1 rack7 rack8 7and8.csv
"@

$computers = $null
#############
##MAIN
#############

if ($args.count)
{
	
foreach($item in $args) 
	{
	if (test-path -path($item))
	
{

$ping = New-Object System.Net.NetworkInformation.Ping
$computers += Get-content $rackfilepath$item".txt" |
ForEach-Object {$ping.Send($_)} |Where-Object {$_.status -eq "Success"}
# $computers |Select-Object address,status,roundtriptime |Format-Table

$computers | ForEach-Object  {get-wmiobject "Win32_POTSModem" -computername $_.Address |
Where-Object  {$_.Status -ne "OK"}|
Select-Object SystemName,Name,AttachedTo,Status,StatusInfo,DriverDate | Format-Table -AutoSize}
}}}
#|Select-Object Name,AttachedTo,Status,StatusInfo,DriverDate | Format-Table}
