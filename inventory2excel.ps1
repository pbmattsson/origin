#$erroractionpreference = $null
#"SilentlyContinue"
$rackfilepath = "\\eswki02inst.eld.ki.sw.ericsson.se\ranrack$\admin\scripts\rackfiles\"
$a = New-Object -comobject Excel.Application
$a.visible = $True

$b = $a.Workbooks.Add()
$c = $b.Worksheets.Item(1)

$c.Cells.Item(1,1) = "Domain"
$c.Cells.Item(1,2) = "Server Name"
$c.Cells.Item(1,3) = "Operating System"
$c.Cells.Item(1,4) = "IP Address"
$c.Cells.Item(1,5) = "Service Packs"
$c.Cells.Item(1,6) = "System Type"
$c.Cells.Item(1,7) = "Manufacturer"
$c.Cells.Item(1,8) = "Model"
$c.Cells.Item(1,9) = "Serial Number"
$c.Cells.Item(1,10) = "Number of Processors"
$c.Cells.Item(1,11) = "Processor Speed"
$c.Cells.Item(1,12) = "Total Phsyical Memory (GB)"
$c.Cells.Item(1,13) = "Report Time Stamp"

$d = $c.UsedRange
$d.Interior.ColorIndex = 19
$d.Font.ColorIndex = 11
$d.Font.Bold = $True

$intRow = 2


foreach($item in $args)

{
	if (Test-Path $rackfilepath$item".txt")

		{
    		$rackfilepath+$item+".txt"+" File found" 
			$colComputers += (Get-content $rackfilepath$item".txt")
			#$computers = Get-content $rackfilepath$item".txt" 
		}
	else

	{
    $rackfilepath+$item+".txt"+"  Does not exist"
	}
}
foreach($strComputer in $colComputers)
{
clear-variable -name os
clear-variable -name computer
clear-variable -name bios
clear-variable -name processor
#test-connection -count 1 -ComputerName $computername -TimeToLive 15 -asJob -ThrottleLimit 100 |

$OS = get-wmiobject Win32_OperatingSystem -computername $strComputer -asJob
$Computer = Get-WmiObject Win32_computerSystem -computername $strComputer
$Bios = Get-WmiObject win32_bios -computername $strComputer
$processor = get-wmiobject win32_processor -computername $strcomputer |
select-object -first 1 name
$IP = get-wmiobject win32_ip -computername $strcomputer

$c.Cells.Item($intRow,1) = $computer.Domain
$c.Cells.Item($intRow,2) = $strComputer.Toupper()
$c.Cells.Item($intRow,3) = $OS.Caption
$c.Cells.Item($intRow,4) = $IP.IPaddress[0]
$c.Cells.Item($intRow,5) = $OS.CSDVersion
$c.Cells.Item($intRow,6) = $Computer.SystemType
$c.Cells.Item($intRow,7) = $Computer.Manufacturer
$c.Cells.Item($intRow,8) = $Computer.Model
$c.Cells.Item($intRow,9) = $Bios.serialnumber
$c.Cells.Item($intRow,10) = $Computer.NumberOfProcessors
$c.Cells.Item($intRow,11) = $processor.name
$c.Cells.Item($intRow,12) = $computer.TotalPhysicalMemory
$c.Cells.Item($intRow,13) = Get-date

$intRow = $intRow + 1

$d.EntireColumn.AutoFit()

}