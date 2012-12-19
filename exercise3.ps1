foreach($i in $args) {$i}

$usage = @"
             This script returns the status of modems on remote systems,

		         Syntax: scriptfile.ps1 [host-file] [output-file]
"@
$usage
$ping = New-Object System.Net.NetworkInformation.Ping
$computers = Get-content "\\eswki02inst\ranrack$\utilities\powershell\rack2.txt" |
ForEach-Object {$ping.Send($_)} |Where-Object {$_.status -eq "Success"}
# $computers |Select-Object address,status,roundtriptime |Format-Table

$computers | ForEach-Object  {get-wmiobject "Win32_POTSModem" -computername $_.Address | Select-Object name,AttachedTo,Status,StatusInfo | Format-Table}
