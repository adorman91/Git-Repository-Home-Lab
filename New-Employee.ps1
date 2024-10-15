#requires -Module ActiveDirectory
[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [string]$FirstName,

    [Parameter(Mandatory)]
    [string]$LastName,
    
    [Parameter(Mandatory)]
    [string]$Department,

    [Parameter(Mandatory)]
    [int]$EmployeeNumber
)
try {
    #Lines 18-19 concatenate a given $FirstName and adds it to the front of $LastName.
    #If the newly created $
    $userName = '{0}{1}' -f $FirstName.Substring(0,1), $LastName
    (Get-ADUser -Filter "samAccountName -eq '$userName'") -and ($userName -notlike "$FirstName*")
    $i = 2
    while ((Get-ADUser -Filter "samAccountName -eq '$UserName'") -and ($userName -notlike "$FirstName*")) {
        Write-Warning -Message "The username [$($userName)] already exists. Trying another..."
        $userName = '{0}{1}' -f $FirstName.Substring(0,$i), $LastName
        Start-Sleep -Seconds 1
        $i++
    }
    if (-not ($ou = Get-ADOrganizationalUnit -Filter "Name -eq '$Department'")) {
        throw "The Active Directory OU for department [$($Department)] could not be found."
    } elseif (-not (Get-ADGroup -Filter "Name -eq '$Department")) {
        throw "The group [$($Department)] does not exist."
    }
    Add-Type -AssemblyName 'System.Web'
    $password = [System.Web.Security.Membership]::GeneratePassword(
        (Get-Random Minimum 20 -Maximum 32), 3)
    $secPw = ConvertTo-SecureString -String $password -AsPlainText -Force
    $newUserParams = @{
        GivenName = $FirstName
        EmployeeNumber = $EmployeeNumber
        Surname = $LastName
        Name = $userName
        AccountPassword = $secPw
        ChangePasswordAtLogin = $true
        Enabled = $true
        Department = $Department
        Path = $ou.DistinguishedName
        Confirm = $false
    }
    New-ADUser @newUserParams
    Add-ADGroupMember -Identity $Department -Members $userName
} catch {
    Write-Error -Message $_.Exception.Message
}