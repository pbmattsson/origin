$ping = New-Object System.Net.NetworkInformation.Ping
$computers = Get-content "\\eswki02inst\ranrack$\utilities\powershell\UErack_4.csv" |
ForEach-Object {$ping.Send($_)} |Where-Object {$_.status -eq "Success"}
$computers |Select-Object address,status,roundtriptime |Format-Table
