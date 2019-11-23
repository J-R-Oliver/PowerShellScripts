#Import MSOnline Module 
Try { Import-Module MSOnline -ErrorAction Stop }
Catch { Write-Warning "Unable to load Active Directory module because $($Error[0])"; Exit }

#Opens session to AzureAD / Msol
Connect-MsolService

#Create file browser
Add-Type -AssemblyName System.Windows.Forms
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
    InitialDirectory = [Environment]::GetFolderPath('Desktop')
    Filter = 'CSV (Comma delimited) (*csv) |*.csv'
}
$FileBrowser.ShowDialog()

$UserAccounts = Import-Csv -Path $FileBrowser.FileName | Select-Object 'UserPrincipalName', 'DisplayName', 'LicenseRemoved'
$UserLicenseInfo = @()

#Add licenses and disable services to csv. Remove licenses.
foreach ( $User in $UserAccounts ){
    try {
        $Licenses = Get-MsolUser -UserPrincipalName $User.UserPrincipalName | Select-Object -ExpandProperty licenses
        if ( $Licenses ) {
            foreach ( $License in  $Licenses ){
                $DisabledServices = $License.ServiceStatus | Where-Object { $_. ProvisioningStatus -eq 'Disabled' }
                $UserLicenseInfo += New-Object -TypeName 'PsObject' -Property @{
                    UserPrincipalName = $User.UserPrincipalName
                    AccountSkuId = [string]$License.AccountSkuId
                    DisabledServices = [string]$DisabledServices.ServicePlan.ServiceName
                }
            }
            Set-MsolUserLicense -UserPrincipalName $User.UserPrincipalName -RemoveLicense $Licenses.AccountSkuId -ErrorAction Stop
        }
        $User.LicenseRemoved = 'True'
    }
    catch {
        $User.LicenseRemoved = 'Error'
    }
}

#Exports to spreadsheet 
$UserAccounts | Export-Csv -NoTypeInformation -Path $FileBrowser.FileName
$UserLicenseInfo | Export-Csv -NoTypeInformation -Path (Join-Path -Path ([Environment]::GetFolderPath("Desktop")) `
                           -ChildPath "LicensesRemovedFromUserAccounts.csv")
