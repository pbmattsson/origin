<#
ALZDBA 2011-12-27
Run a given set of telnet commands agaings given ipaddresses ( and wait for the device to reboot if needed )

#>
function readResponse {
	while($stream.DataAvailable)  {  
	      $read = $stream.Read($buffer, 0, 1024)    
	      write-verbose $encoding.GetString($buffer, 0, $read)
	   } 
	}

function Invoke-RunTelnetScript { 
    [CmdletBinding()] 
    param( 
    [Parameter(Position=0, Mandatory=$true)] [string]$remoteHost, 
    [Parameter(Position=1, Mandatory=$true)] [string]$Hostname,
	[Parameter(ParameterSetName='Command2BExecuted', Position=2, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
		[ValidateNotNullOrEmpty()]
		[System.String[]]
		$Command2BExecuted ,
	[Parameter(Position=3, Mandatory=$false)] [boolean]$Wait4Reboot = 0  #should it monitor a reboot ?
	) 
<#
Run a given set of telnet commands agaings given ipaddresses ( and wait for the device to reboot if needed )
#>
	if ($remoteHost -eq "" -or $Hostname -eq "" ) {
		"Please specify the $remoteHost and $Hostname" 
		return; }

	$port = 10001 
	$socket = new-object System.Net.Sockets.TcpClient($remoteHost, $port) 
	$socket.SendTimeout = 10
	$socket.ReceiveTimeout = 10

	if($socket -eq $null) { return; } 

	$stream = $socket.GetStream() 
	$writer = new-object System.IO.StreamWriter($stream) 
	$buffer = new-object System.Byte[] 1024 
	$encoding = new-object System.Text.AsciiEncoding 
	readResponse($stream)
	foreach ( $cmd in $Command2BExecuted ) {
		write-verbose $cmd
		$writer.WriteLine($cmd) 
		$writer.Flush()
		#wait 500 miliseconds
		start-sleep -m 500 
		readResponse($stream)
		}

	#If indicated reboot is needed we will use ping to figure out reboot sequence
	if ( $Wait4Reboot -eq $true ) {
		$bln = $false 
		$flipflop = $false
		$ping = new-object System.Net.NetworkInformation.Ping
		while ( $bln -eq $false ) {
			#session will loose connection because of reboot. Just ping after 60 seconds to see if it is alive ( restarted )
			$pReply = $ping.send($remoteHost)
			if ( $pReply.Status -eq 'Success' ){
					if ( $flipflop -eq $true ) {
						#reboot ended
						$bln = $true 
						write-verbose 'Back Online'
						}
					else {
						write-verbose "Still Online - $hostname" 
						start-sleep -s 4
						}
				}
			else {
				'Offline'
				if ( $flipflop -eq $false ) {
					#first offline is reboot ongoing
					$flipflop = $true 
					}
			}
		}
	}

	$writer.Close() 
	$stream.Close() 

	Write-Host 'End of Telnet command set processing'

}

# -------------- Begin execution ---------------------
clear-host

$colInputParams = '10.51.4.199,Mrup1' , '10.51.4.200,Mrup2'

$InputTelnetCommandSet = get-content \\eswki02inst.eld.ki.sw.ericsson.se\ranrack$\Utilities\Scripts\telnet.txt
#just show all commands in the set on a grid-view --> to be commented at runtime
$InputTelnetCommandSet | Out-GridView 

foreach ($strParams in $colInputParams){
 $strComputer =$strParams.Substring( 0, $strParams.LastIndexOf(',') )
 $strHostname =$strParams.Substring( $strParams.LastIndexOf(',') + 1  )
 $strComputer
 $strHostname
 Invoke-RunTelnetScript -remoteHost $strComputer -Hostname $strHostname -Command2BExecuted $InputTelnetCommandSet -Wait4Reboot $false

}



<# C:\temp\Telnet_Script.txt contains these records
mytelnetlogin
mytelnetpwd
en
anotherpwd
conf t
max-vlans 15
end
write mem
#>