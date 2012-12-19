$strComputer = "137.58.205.212"

$colItems = get-wmiobject -class "Win32_POTSModem" -namespace "root\CIMV2" `
-computername $strComputer

foreach ($objItem in $colItems) {
      
      write-host "Name: " $objItem.Name
	  write-host "Attached To: " $objItem.AttachedTo
      write-host "Status: " $objItem.Status
      write-host "Status Information: " $objItem.StatusInfo
      write-host 
}

