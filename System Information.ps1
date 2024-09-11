#This is a script to show that you can pull system information from a log.
$Records=Import-CSV C:Oui.csv
$PCMAC='00-01-C8 'ForEach ($Record in $Records)
{    
    If ($Record.MAC -eq $PCMAC)
    {            
        $Vendor=$Record.Vendor                    
        Write-Host $Vendor
    }            
}   