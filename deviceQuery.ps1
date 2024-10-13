$rows = Import-Csv -Path 'C:\IT_FILES\IPAddresses.csv'
foreach ($row in $rows) {
    try {
        $output = @{
            IPAddress = $row.IPAddress
            Class = $row.Class
            IsOnline = $false
            Hostname = $null
            Error = $null
        }
        if (Test-Connection -ComputerName $row.IPAddress -Count 1  -Quiet) {
            $output.IsOnline = $true
        }
        if ($hostname = (Resolve-DnsName -Name $row.IPAddress -ErrorAction Stop).Name) {
            $output.Hostname = $Hostname
        }
    } catch {
        $output.Error = $_.Exception.Message
    } finally {
        [pscustomobject]$output 
    }
}
[pscustomobject]$output | Export-Csv -Path C:\IT_FILES\MGMT.csv -Append
-NoTypeInformation