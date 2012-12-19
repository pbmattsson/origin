function Show-DriverDialog {
    param(
        $ComputerName = $env:computername
    )   
    driverquery.exe /S $ComputerName /FO CSV  |
      ConvertFrom-Csv |
      Out-GridView -Title "Driver on \\$ComputerName"
}
Show-DriverDialog