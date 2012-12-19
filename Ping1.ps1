$rackfilepath = "\\eswki02inst\ranrack$\admin\scripts\rackfiles\"
$ping = New-Object System.Net.NetworkInformation.Ping
$computers = $null
foreach($item in $args)

{if (Test-Path $rackfilepath$item".txt")

{
    $rackfilepath+$item+".txt"+" File found" 
	$computers += (Get-content $rackfilepath$item".txt")
	
}
else
{
    $rackfilepath+$item+".txt"+"  Does not exist"
}}
Write-Host
Write-Host "Now pinging" $computers -ForegroundColor Green
Write-Host
#ForEach-Object {$ping.Send($_)}
#ForEach ($item in $computers) {$ping.Send($_)}
$computers | ForEach-Object {$ping.Send($_)}