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

$SelectParams = @{
    Property = 'UserPrincipalName',
               'DisplayName',
               'LicenseRemoved',
               @{ Name = 'AccountSkuId' ; Expression = { $_.AccountSkuId.split(' ') }},
               @{ Name = 'DisabledServices' ; Expression = { $_.DisabledServices.split(' ') }}
}
$Users = Import-Csv -Path $FileBrowser.FileName | Select-Object @SelectParams

foreach ( $User in $Users ){
    try {
        if ( $User.DisabledServices ) {
            $ServicesToDisable = New-MsolLicenseOptions -AccountSkuId $User.AccountSkuId  -DisabledPlans $User.DisabledServices
            Set-MsolUserLicense -UserPrincipalName $User.UserPrincipalName -AddLicenses $User.AccountSkuId -LicenseOptions $ServicesToDisable -ErrorAction Stop
        }
        else {
            Set-MsolUserLicense -UserPrincipalName $User.UserPrincipalName -AddLicenses $User.AccountSkuId -ErrorAction Stop
        } 
        $User.LicenseRemoved = 'Re-enabled'
    }
    catch {
        $User.LicenseRemoved = 'Error'
    }
}

#Exports array to spreadsheet 
$Users | Export-Csv -NoTypeInformation -Path (Join-Path -Path ([Environment]::GetFolderPath("Desktop")) `
                           -ChildPath "LicenseReEnabledUserAccounts.csv")
