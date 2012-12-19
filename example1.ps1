$ping = New-Object System.Net.NetworkInformation.Ping
$computers = Get-content "\\eswki02inst\ranrack$\utilities\powershell\UErack_4.csv" |
ForEach-Object {$ping.Send($_)} |Where-Object {$_.status.tostring -ne "Success"}
$pingedOK = $computers where $_.status.tostring () -eq "Success"

if ($computers[1].status.tostring() -eq "Success") {

$computers[1].status.tostring()
$computers |Select-Object address,status,roundtriptime
{write-host $_.status.tostring }

Write-Host "$_"}