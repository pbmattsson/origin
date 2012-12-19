$socket = New-Object System.Net.Sockets.Socket ([System.Net.Sockets.AddressFamily]::InterNetwork, [System.Net.Sockets.SocketType]::Stream, [System.Net.Sockets.ProtocolType]::Tcp)
$socket.connect('hse-ny-metr-01', 2003)
$message = "system.HSE-NYC-DT-188.CPULOAD 28 " + /n
$ASCIIEncoder = New-Object System.Text.ASCIIEncoding
$Socket.Send($ASCIIEncoder.GetBytes("$message"))