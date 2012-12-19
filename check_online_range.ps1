function Check-Online {

       param(

              $computername

       )

 

       test-connection -count 1 -ComputerName $computername -TimeToLive 15 -asJob -ThrottleLimit 100 |

       Wait-Job |

       Receive-Job |

       Where-Object { $_.StatusCode -eq 0 } |

       Select-Object -ExpandProperty Address

}

 

$ips = 1..254 | ForEach-Object { "137.58.205.$_" }

$online = Check-Online -computername $ips

$online|sort