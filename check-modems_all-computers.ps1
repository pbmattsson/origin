$host.UI.RawUI.BackgroundColor = 'Blue'
$computers = Get-content "\\eswki02inst\ranrack$\utilities\powershell\ip_list.csv"
foreach ($computer in $computers){Write-Host $_.name}


($pinged = New-Object System.Net.NetworkInformation.Ping)$pinged.send}

|Write-Host $computer

} |Write-Host $computer





Get-WmiObject -Class Win32_PingStatus -Filter "Address='137.58.205.100'"
$ping = New-Object System.Net.NetworkInformation.Ping


{Get-WmiObject -Class where Win32_PingStatus= {write-Host $i}
$computers | get-member
$ping = New-Object System.Net.NetworkInformation.Ping
$computers = Get-content "\\eswki02inst\ranrack$\utilities\powershell\UErack_4.csv" |
ForEach-Object {$ping.Send($_)}
{write-host $_.status.tostring }

Write-Host "$_"}