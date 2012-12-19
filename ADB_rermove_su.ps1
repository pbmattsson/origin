$adbpath = "$env:ProgramFiles\adb"
$appfilename = "AutoDroid_R7H01.apk"
$shellcmd = " -c /system/xbin/busybox mount -o rw,remount /system > /data/local/tmp/output 2>&1"
# Alias for ADB.EXE (Android debug bridge)  
if (-not (test-path "$env:ProgramFiles\adb\adb.exe")) {throw "$env:ProgramFiles\adb\adb.exe needed"}  
set-alias adb "$env:ProgramFiles\adb\adb.exe"  


#$cmd = 'C:\users\administrator\desktop\SuperOneClickv2.3.3\adb\adb.exe'
$UeList= adb devices 			# read in connected UEs from ADB
$null, $UeList = $UeList		#remove the first header-line from the array

foreach ($Ue in $UeList)		#run command on connected UEs
{
$UE=$Ue.TrimEnd('	device')		#remove the text 'device' from each element
$Ue
#adb -s "$Ue" "$shellcmd"
#adb -s "$Ue" shell "su -c '/system/xbin/busybox mount -o rw,remount /system'" 
#adb -s 43423531315438325742 shell su -c `"/system/xbin/busybox mount -o rw,remount /system`"
adb -s "$Ue" shell su -c `""/system/xbin/busybox mount -o rw,remount /system`""
adb -s "$Ue" shell su -c `""/system/xbin/busybox rm /system/xbin/su`""
adb -s "$Ue" shell su -c `""/system/xbin/busybox mount -o ro,remount /system`""

#"$adbpath\$appfilename"
}
