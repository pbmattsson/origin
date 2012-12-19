function Check-Online {

 param(

 $computername

 )

 

 test-connection -count 1 -ComputerName $computername -TimeToLive 5 -asJob |

 Wait-Job |

 Receive-Job |

 Where-Object { $_.StatusCode -eq 0 } |

 Select-Object -ExpandProperty Address

}

 

$ips = 23..254 | ForEach-Object { "137.58.205.$_" }

$online = Check-Online -computername $ips

 

$online |

Sort-Object |

ForEach-Object {

 $ip = $_

 try {

  [System.Net.Dns]::GetHostByAddress($ip)

 }

 catch {

  "cannot resolve $ip. Reason: $_"

 }

}