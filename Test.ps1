#Prepare Script
$ErrorActionPreference = "Continue"$Output=@()$Records=Import-CSV C:ScriptsOui.csv
# Ping Search
$IPs = 1..254 | ForEach -Process {WmiObject -Class Win32_PingStatus -Filter ("Address='192.168.0." + $_ + "'")}$DevicesOnly = $IPs | Where-Object{$_.StatusCode -eq 0}
#Extract DataForEach($Device in $DevicesOnly){            $Address = $Device.ProtocolAddress
$MAC = arp -a $Address | Select-String '([0-9a-f]{2}-){5}[0-9a-f]{2}' | Select-Object -Expand Matches | Select-Object -Expand Value 
$PCMAC = $MAC.SubString(0,8)+' '
#Write Data to Object
$Systems=New-Object -TypeName PSObject$Systems | Add-Member -Type NoteProperty -Name IP -Value $Address$Systems | Add-Member -Type NoteProperty -Name MAC -Value $Mac$Systems | Add-Member -Type NoteProperty -Name Hostname -Value $HostName$Systems | Add-Member -Type NoteProperty -Name Vendor -Value $Vendor$Output += $Systems
#Write Output
$Output | Select-Object Hostname, IP, MAC, Vendor | Format-Table