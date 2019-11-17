#Tests for Active Directory module.
Try { Import-Module ActiveDirectory -ErrorAction Stop }
Catch { Write-Warning "Unable to load Active Directory module because $($Error[0])"; Exit }

#Create file browser
Add-Type -AssemblyName System.Windows.Forms
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
    InitialDirectory = [Environment]::GetFolderPath('Desktop')
    Filter = 'CSV (Comma delimited) (*csv) |*.csv'
}
$FileBrowser.ShowDialog()

#Script
$UserAccounts = Import-Csv -Path $FileBrowser.FileName
foreach ( $User in $UserAccounts ){
    try {
        Remove-ADUser -Identity ( $User.UserPrincipalName -Replace "@st-annes.org.uk","" ) -ErrorAction Stop
        $User."Account Deleted" = 'True'
    }
    catch {
        $User."Account Deleted" = 'False'  
    }
}
