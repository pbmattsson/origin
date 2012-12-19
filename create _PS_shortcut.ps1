$shell = New-Object -ComObject WScript.Shell   

$lnk = $shell.CreateShortcut("$([System.Environment]::GetFolderPath('Desktop'))\MyPS.lnk")

$lnk.TargetPath = (Get-Process -Id $pid).Path

$lnk.Save()