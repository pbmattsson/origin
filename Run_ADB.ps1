$UeList = .\adb devices
$a = $UeList.Replace(" List of devices attached,", "")
#foreach ($Ue in $UeList)
#	{$_.Trim('List of devices attached,')}
#	".\adb -s $_.Substring(20)"}