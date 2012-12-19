function out-duplicates ($rack, $fails=10)
#reads files and displays duplicates
# $ackfile = name of file with ackumulated modem status
#$fails = number of failed detections default
#$resultdir = "\\eswki02inst.eld.ki.sw.ericsson.se\ranrack$\admin\scripts\resultfiles\" #Directory for accessed files
{
get-content $resultdir$rack".csv" | group | Where-Object {$_.count -gt $fails} | ForEach-Object {$_.group}
}

out-duplicates 