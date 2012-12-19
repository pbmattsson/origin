read-host Prompt 

$machine1 = Get-Service –ComputerName epsil-r32p1.eld.ki.sw.ericsson.se

$machine2 = Get-Service –ComputerName epsil-r32p2.eld.ki.sw.ericsson.se

Compare-Object –ReferenceObject $machine1 –DifferenceObject $machine2 –Property Name,Status –passThru | Sort-Object Name | Select-Object Name, Status, MachineName