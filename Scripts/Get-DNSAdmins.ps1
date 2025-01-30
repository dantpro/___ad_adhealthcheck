<#
    .EXAMPLE 
    .\Get-DNSAdmins.ps1 -OutputPath C:\Tools\Audit -Verbose
    .NOTES
    All rigts reserved to 
    Robert Przybylski 
    www.azureblog.pl 
    2021
#>

[CmdletBinding()] 
param (
    [Parameter(Position = 0, mandatory = $true)]
    [string] $OutputPath
)

#region initial setup
Import-Module ActiveDirectory
$adDomain = Get-ADDomain
$adForest = Get-ADForest
$scriptName = $myInvocation.ScriptName

function Get-ScriptProgress {
    param (
        [string] $Name
    )   
    Write-Host "[$scriptName] Running $name check..." -ForegroundColor Yellow}
#endregion 

#Region Forest Info
Get-ScriptProgress -Name 'DNS Admins'
$admins = @()
Get-ADGroupMember -Identity 'DNSAdmins' | foreach-object {
   $admins += Get-ADUSer -Identity $_ -Properties Name,Enabled,SamAccountName,LastLogonDate
}
if ($($admins.count) -ne 0) {
    $admins | Export-Csv -Path $OutputPath\DNS_Admins_details.csv -NoTypeInformation -Encoding UTF8
} else {
   Write-Host "INFO: DNS Admins group is empty" -ForegroundColor Yellow
}
#endregion 
