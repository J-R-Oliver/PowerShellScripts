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
Write-Output 'Please select csv of users'
$ListofUsers = Import-Csv -Path $FileBrowser.FileName
$ListofPasswordExpired = @()
ForEach ( $User in $ListofUsers ){
    $ListofPasswordExpired += Get-ADUser -Filter "UserPrincipalName -Like '$($User.User)'" -Properties "PasswordExpired" |
                              Select-Object Name,UserPrincipalName,PasswordExpired 
}
$TodaysDate = Get-Date -Format 'MM/dd/yyyy'
$Path = Join-Path -Path ([Environment]::GetFolderPath("Desktop")) -ChildPath "ExpiredPasswords$($TodaysDate.Replace('/','.')).csv"
$ListofPasswordExpired | Export-Csv -Path $Path