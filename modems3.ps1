$strComputer = "137.58.205.212"

$colItems = get-wmiobject -class "Win32_POTSModem" -namespace "root\CIMV2" -computername $strComputer | Select-Object name,AttachedTo,Status,StatusInfo | Export-CSV modemlist.csv


   



