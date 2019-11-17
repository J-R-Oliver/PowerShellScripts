#Imports MSOnline module if it's not installed already.
If( $null -eq ( Get-InstalledModule `
                -Name "MSOnline" `
                -ErrorAction SilentlyContinue)){
    
    Install-Module MSOnline -Force

}

#Import AD Module 
Try { Import-Module MSOnline -ErrorAction Stop }
Catch { Write-Warning "Unable to load Active Directory module because $($Error[0])"; Exit }

#Opens session to AzureAD / Msol
Connect-AzureAD

Connect-MsolService

#Imports user information and creates array

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
               'LastAcvitiy',
               'AssignedProducts',
               'LicenseRemoved',
               'AccountDeleted'
}

$UserAccounts = Import-Csv -Path $FileBrowser.FileName | Select-Object @SelectParams 

#Removes licenses and adds user to exlusion group 
foreach ( $User in $UserAccounts ){
    try {
        $Licenses = Get-MsolUser -UserPrincipalName $User.UserPrincipalName | Select-Object -ExpandProperty licenses
        if ( $User.AssignedProducts ) {
            Set-MsolUserLicense -UserPrincipalName $user.UserPrincipalName -RemoveLicense $Licenses.AccountSkuId
            $User.AssignedProducts = $license.AccountSkuId
        } 
        $ObjectId = ( Get-AzureADUser -ObjectId $User.Userprincipalname ).ObjectId
        Add-AzureADGroupMember -ObjectId '522017b3-6721-4e29-ae69-2bdee2821687' -RefObjectId $ObjectId
        $User.LicenseRemoved = 'True'
    }
    catch {
        $User.LicenseRemoved = 'Error'
    }
}

#Exports array to spreadsheet 
$UserAccounts | Export-Csv -NoTypeInformation -Path (Join-Path -Path ([Environment]::GetFolderPath("Desktop")) `
                           -ChildPath "VEEAMExcludedUserAccounts.csv")

<#
NOTES

https://community.spiceworks.com/topic/1982283-office-365-remove-all-licenses-from-a-user

https://docs.microsoft.com/en-gb/office365/enterprise/powershell/disable-access-to-services-with-office-365-powershell?redirectedfrom=MSDN

https://o365reports.com/2018/12/14/export-office-365-user-license-report-powershell/

#>