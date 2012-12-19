cls
$Voice = new-object -com SAPI.SpVoice


function Ping-Host {
BEGIN {}
PROCESS {


$results = gwmi -query "SELECT * FROM Win32_PingStatus WHERE Address = '$computer'"


if ($results.StatusCode -eq 0) { 


Write-Host "$computer is Pingable"
} else {
$Voice.Speak( "Alert Alert Alert $computer is down", 1 )
Write-Host "$computer is not Pingable" -BackgroundColor red 
}
}
END {}
}
$computers = Get-Content "\\eswki02inst.eld.ki.sw.ericsson.se\ranrack$\admin\scripts\rackfiles\rack8.txt"
foreach ($computer in $computers) {
if (Ping-Host $computer) {
}
}
