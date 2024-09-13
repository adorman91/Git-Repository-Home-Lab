#This script will install any Brother printer that utilizes BR-Script (PostScript language emulation).
#Paste the code below into admin-run Powershell to execute. Printer IP Address needs to be known and 'Drive Store' folder needs to be included in 'C:/IT_Files'. Folder is in AD's GitHub.
#MFC-9330CDW, HL-L3280, MFC-L3770CDW are supported. 
#Full list of supported printers @: https://support.brother.com/g/b/faqend.aspx?c=us&lang=en&prod=mfcl3770cdw_us_eu_as&ftype3=2037&faqid=faq00002747_000 
$hostName = $env:COMPUTERNAME
$ipAddress = Read-Host "What is your printer's IP Address?"
pnputil /add-driver "C:\IT_FILES\Drive Store\universalDriverBR-Script\brupsb0a.INF"
Add-PrinterDriver -Name "Brother Universal Printer (BR-Script3)" -InfPath 'C:\Windows\System32\DriverStore\FileRepository\brupsb0a.inf_amd64_18a5605c544df2e2\brupsb0a.INF'
Add-PrinterPort -Name "Printer Port" -PrinterHostAddress $ipAddress
Add-Printer -DriverName "Brother Universal Printer (BR-Script3)" -Name "Brother Universal Printer" -PortName "Printer Port"
Get-Printer | Format-Table
Invoke-CimMethod -MethodName printtestpage -InputObject (Get-CimInstance win32_printer -Filter "name LIKE 'Brother Universal Printer'")
$test = "0"
If ($LASTEXITCODE -eq $test) {
    ECHO "Print Job Successful"
}
    else {ECHO "Print Job Unsuccessful"
}