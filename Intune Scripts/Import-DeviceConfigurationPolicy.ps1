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

    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.IdentityModel.Clients.ActiveDirectory.dll") #LoadWithPartialName method has been deprecated.
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.IdentityModel.Clients.ActiveDirectory.Platform.dll") #LoadWithPartialName method has been deprecated.

    $PlatformParameters = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.PlatformParameters" -ArgumentList "Auto"
    $UserId = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.UserIdentifier" -ArgumentList ($UserPrincipalName, "OptionalDisplayableId")
    $AuthContext = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext" -ArgumentList $Authority
    $AuthResult = $AuthContext.AcquireTokenAsync($ResourceAppIdURI,$ClientId,$RedirectURI,$PlatformParameters,$UserId).Result

    $authHeader = @{
        'Content-Type' = 'application/json'
        'Authorization' = $AuthResult.AccessTokenType + ' ' + $AuthResult.AccessToken
        'ExpiresOn'= $AuthResult.ExpiresOn
        }
    
    Return $authHeader
    
}

function Set-DeviceConfigurationPolicy {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]$AuthenticationToken,
        [Parameter(Mandatory=$true)]$Configuration,
        [string]$GraphAPIVersion = 'v1.0'
    )
    $URI = "https://graph.microsoft.com/$GraphAPIVersion/deviceManagement/deviceConfigurations"
    Invoke-RestMethod -Uri $URI -Token $AuthenticationToken -Method Post -Body $Configuration -ContentType "application/json"
}

function Import-JSON {
    [CmdletBinding()]
    param (

    )
    Add-Type -AssemblyName System.Windows.Forms
    $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
        InitialDirectory = [Environment]::GetFolderPath('Desktop')
        Filter = 'JSON (*.json) |*.json'
    }
    $FileBrowser.ShowDialog()
    $JSON = Import-Csv -Path $FileBrowser.FileName
    Return $JSON
}
######### The above needs to be convertered to JSON. CSV form kept below to update other scripts
# Should also have a process block and return the appropriate type of object 

$UserName = Read-Host -Prompt 'Please enter User Principal Name'
$Configuration = Import-JSON 
Write-Host -Object "`nThe following settings will be uploaded to Intune."
$Configuration 
$Check = Read-Host -Prompt "`nPlease enter 'Y' to continue" 

if ( $Check -eq 'Y' ){
    Set-DeviceConfigurationPolicy -AuthenticationToken ( Get-AuthToken -UserPrincipalName $UserName )  -Configuration $Configuration
}
else {
    Write-Host -Object "`nExiting without uploading policy"
}

#Notes: https://github.com/microsoftgraph/powershell-intune-samples/blob/master/DeviceConfiguration/DeviceConfiguration_Import_FromJSON.ps1
#Notes: https://docs.microsoft.com/en-us/graph/api/intune-deviceconfig-windows10customconfiguration-list?view=graph-rest-1.0
<#
function Import-CsvForm {
    [CmdletBinding()]
    param (

    )
    Add-Type -AssemblyName System.Windows.Forms
    $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
        InitialDirectory = [Environment]::GetFolderPath('Desktop')
        Filter = 'CSV (Comma delimited) (*csv) |*.csv'
    }
    $FileBrowser.ShowDialog()
    $Csv = Import-Csv -Path $FileBrowser.FileName
    Return $Csv 
}
#>