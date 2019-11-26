function Get-AuthToken {
    [CmdletBinding()]
    [OutputType([System.Object])]
    param (
        [Parameter(Mandatory = $true)][String]$UserPrincipalName
    )
    $Tenant = $UserPrincipalName.Split('@', 2)[1]
    $ClientID = 'd1ddf0e4-d672-4dae-b554-9d5bdfd93547'
    $RedirectURI = 'urn:ietf:wg:oauth:2.0:oob'
    $ResourceAppIdURI = 'https://graph.microsoft.com'
    $Authority = "https://login.microsoftonline.com/$Tenant"

    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.IdentityModel.Clients.ActiveDirectory.dll") #LoadWithPartialName method has been deprecated.
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.IdentityModel.Clients.ActiveDirectory.Platform.dll") #LoadWithPartialName method has been deprecated.

    $PlatformParameters = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.PlatformParameters" -ArgumentList "Auto"
    $UserId = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.UserIdentifier" -ArgumentList ($UserPrincipalName, "OptionalDisplayableId")
    $AuthContext = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext" -ArgumentList $Authority
    $AuthResult = $AuthContext.AcquireTokenAsync($ResourceAppIdURI, $ClientId, $RedirectURI, $PlatformParameters, $UserId).Result

    $authHeader = @{
        'Content-Type'  = 'application/json'
        'Authorization' = $AuthResult.AccessTokenType + ' ' + $AuthResult.AccessToken
        'ExpiresOn'     = $AuthResult.ExpiresOn
    }
    
    $authHeader
    
}

function Get-DeviceConfigurationPolicy {
    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]$AuthenticationToken,
        [string]$GraphAPIVersion = 'v1.0'
    )
    $URI = "https://graph.microsoft.com/$GraphAPIVersion/deviceManagement/deviceConfigurations"
    Invoke-RestMethod -Uri $URI -Headers $AuthenticationToken -Method Get
}

$FilePath = "C:\Users\james.oliver\OneDrive - St Anne's Community Services\Desktop"

$UserName = Read-Host -Prompt 'Please enter User Principal Name'
$Policies = Get-DeviceConfigurationPolicy -AuthenticationToken ( Get-AuthToken -UserPrincipalName $UserName )
foreach ( $Policy in $Policies ) {
    ConvertTo-Json -InputObject $Policy -Depth 5 | 
    Set-Content -Path "$FilePath$($Policy.displayName.Replace( '\<|\>|:|"|/|\\|\||\?|\*' , '-' )).json"
}

<#
NOTES

https://docs.microsoft.com/en-us/graph/api/intune-deviceconfig-windows10customconfiguration-list?view=graph-rest-1.0

https://docs.microsoft.com/en-us/graph/auth-v2-user?view=graph-rest-1.0

https://github.com/microsoftgraph/powershell-intune-samples/blob/master/DeviceConfiguration/DeviceConfiguration_Export.ps1

https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-restmethod?view=powershell-6

https://docs.microsoft.com/en-gb/azure/active-directory/develop/v1-protocols-oauth-code

#>