function Get-AuthToken {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][String]$UserPrincipalName
    )
    $Tenant = $UserPrincipalName.Split('@',2)[1]
    $ClientID = 'd1ddf0e4-d672-4dae-b554-9d5bdfd93547'
    $RedirectURI = 'urn:ietf:wg:oauth:2.0:oob'
    $ResourceAppIdURI = 'https://graph.microsoft.com'
    $Authority = "https://login.microsoftonline.com/$Tenant"
    #$Authority = 'https://login.microsoftonline.com/common'
}

New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext" -ArgumentList https://login.microsoftonline.com/common
function Get-DeviceConfigurationPolicy {
    
    [CmdletBinding()]
    param (
        [string]$GraphAPIVersion = 'v1.0'
    )
    $URI = "https://graph.microsoft.com/$GraphAPIVersion/deviceManagement/deviceConfigurations"
    Invoke-RestMethod -Uri $URI -Token $AuthToken -Method Get
}

function Write-HelloWorld {
    [CmdletBinding()]
    param (
        [string]$P1 = 'Hello',
        [string]$P2 = 'World'
    )
    Write-Host -Object "$P1 $P2"
}

<#
NOTES

https://docs.microsoft.com/en-us/graph/api/intune-deviceconfig-windows10customconfiguration-list?view=graph-rest-1.0

https://docs.microsoft.com/en-us/graph/auth-v2-user?view=graph-rest-1.0

https://github.com/microsoftgraph/powershell-intune-samples/blob/master/DeviceConfiguration/DeviceConfiguration_Export.ps1

https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-restmethod?view=powershell-6

https://docs.microsoft.com/en-gb/azure/active-directory/develop/v1-protocols-oauth-code

#>