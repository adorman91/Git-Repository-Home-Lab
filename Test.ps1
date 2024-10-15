#requires -Module ActiveDirectory
[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [string]$FirstName,

    [Parameter(Mandatory)]
    [string]$LastName,
    
    [Parameter(Mandatory)]
    [string]$JobTitle,

    [Parameter(Mandatory)]
    [int]$Department,

    [Parameter(Mandatory)]
    [int]$Company

)
try {
    #Creates 'SamAccountName' (CPY username) from first and last name. If username already exists, add an integer to the last name and try again.
    $userName = $FirstName + '.' +  $LastName
    (Get-ADUser -Filter "samAccountName -eq '$userName'") -and ($userName -notlike "$FirstName*")
    $i = 2
    while ((Get-ADUser -Filter "samAccountName -eq '$UserName'") -and ($userName -notlike "$FirstName*")) {
        Write-Warning -Message "The username [$($userName)] already exists. Trying another..."
        $userName = $userName, $i
        Start-Sleep -Seconds 1
        $i++
    }

    #Checks if the given department exists; this will be used to automatically assign a user to a group. 
    if (-not ($ou = Get-ADOrganizationalUnit -Filter "Name -eq '$Department'")) {
        throw "The Active Directory OU for department [$($Department)] could not be found."
    } elseif (-not (Get-ADGroup -Filter "Name -eq '$Department")) {
        throw "The group [$($Department)] does not exist."
    }

    #Generate a random password based on CPY domain password policy.
    Add-Type -AssemblyName 'System.Web'
    $password = [System.Web.Security.Membership]::GeneratePassword(
        (Get-Random Minimum 7), 3)
    $secPw = ConvertTo-SecureString -String $password -AsPlainText -Force
    $newUserParams = @{
        FirstName = $FirstName
        LastName = $LastName
        JobTitle = $JobTitle
        Department = $Department
        Company = $Company
        AccountPassword = $secPw
        ChangePasswordAtLogin = $true
        Enabled = $true
        Path = $ou.DistinguishedName
        Confirm = $false
    }
    New-ADUser @newUserParams
    Add-ADGroupMember -Identity $Department -Members $userName
} catch {
    Write-Error -Message $_.Exception.Message
}