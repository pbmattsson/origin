﻿1..255 | Foreach-Object { "137.58.205.$_" } | Foreach-Object { $ip = $_; [System.Net.DNS]::GetHostByAddress($_) }		