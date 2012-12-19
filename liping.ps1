#$erroractionpreference = "SilentlyContinue"
$a = New-Object -comobject Excel.Application
$a.visible = $True

$b = $a.Workbooks.Add()
$c = $b.Worksheets.Item(1)

$c.Cells.Item(1,1) = "Machine Name"
$c.Cells.Item(1,2) = "Ping Status"

$d = $c.UsedRange
$d.Interior.ColorIndex = 19
$d.Font.ColorIndex = 11
$d.Font.Bold = $True
$d.EntireColumn.AutoFit($True)

$intRow = 2

$colComputers = get-content \\eswki02inst.eld.ki.sw.ericsson.se\ranrack$\admin\scripts\rackfiles\rack38.txt
foreach ($strComputer in $colComputers)
{
$c.Cells.Item($intRow, 1) = $strComputer.ToUpper()

# This is the key part

$ping = new-object System.Net.NetworkInformation.Ping
$Reply = $ping.send($strComputer)
if ($Reply.status –eq “Success”)
{
$c.Cells.Item($intRow, 2) = “Online”
}
else
{
$c.Cells.Item($intRow, 2) = "Offline"
}
$Reply = ""


$intRow = $intRow + 1

}
$d.EntireColumn.AutoFit()