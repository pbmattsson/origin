function Get-WindowsLaunch {

  $filter = @{

    logname='Microsoft-Windows-Diagnostics-Performance/Operational'

    id=100

  }

 

  Get-WinEvent -FilterHashtable $filter |

  ForEach-Object {

    $info = 1 | Select-Object Date, Startduration, Autostarts, Logonduration

    $info.Date = $_.Properties[1].Value

    $info.Startduration = $_.Properties[5].Value

    $info.Autostarts = $_.Properties[18].Value

    $info.Logonduration = $_.Properties[43].Value

    $info

  }

}

Get-WindowsLaunch 
