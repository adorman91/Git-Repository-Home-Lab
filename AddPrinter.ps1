#Script to install a printer. Needs to start from Powershell 
#To-Do: create a folder that can simulate a "driver store" that stores multiple Brother drivers.
#To-Do: add command to move printer drivers to driver store
#To-Do: add command to identify network printer to be installed
#To-Do: add command to choose driver to be installed based on network printer
$hostName = $env:COMPUTERNAME
$ipAddress = Read-Host "What is your printer's IP Address?"
pnputil /add-driver "C:\IT FILES\Drive Store\gdi\BROHL22A.INF"
Add-PrinterDriver -Name "$hostname" -InfPath "C:\Windows\System32\DriverStore\FileRepository\brohl22a.inf_amd64_3aa7b3980f60ed76\BROHL22A.INF"
Add-PrinterPort -Name "Printer Port" -PrinterHostAddress $ipAddress
Add-Printer -DriverName "Brother HL-L2460DW Printer" -Name "Brother HL-L2460DW" -PortName "Printer Port"
Get-Printer | Format-Table