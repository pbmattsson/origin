$adbpath = "$env:ProgramFiles\adb"
$appfilename = "AutoDroid_R7N.apk"
# Alias for ADB.EXE (Android debug bridge)  
if (-not (test-path "$env:ProgramFiles\adb\adb.exe")) {throw "$env:ProgramFiles\adb\adb.exe needed"}  
set-alias adb "$env:ProgramFiles\adb\adb.exe"  


#$cmd = 'C:\users\administrator\desktop\SuperOneClickv2.3.3\adb\adb.exe'
$UeList= adb devices 			# read in connected UEs from ADB
$null, $UeList = $UeList		#remove the first header-line from the array

foreach ($Ue in $UeList)		#run command on connected UEs
{
$UE=$Ue.TrimEnd('	device')		#remove the 'device' from each element
$Ue
adb -s "$Ue" uninstall com.ericsson.autotest.autodroid

}
