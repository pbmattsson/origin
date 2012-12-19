$strComputer = "137.58.205.212"

$colItems = get-wmiobject -class "Win32_POTSModem" -namespace "root\CIMV2" `
-computername $strComputer

foreach ($objItem in $colItems) {
    Select-Object name,AttachedTo,StatusInfo | Export-Console  

}

