$iplist = "10.10.10.1", "10.10.10.3", "10.10.10.230"

 

"Not sorted correctly:"

$iplist |
Sort-Object

 

"Sorted correctly:"

$iplist |
ForEach-Object { [System.Version] $_ } |
Sort-Object |
ForEach-Object { $_.toString() }