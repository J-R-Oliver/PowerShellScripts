#Create file browser
Add-Type -AssemblyName System.Windows.Forms
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
    InitialDirectory = [Environment]::GetFolderPath('Desktop')
    Filter = 'CSV (Comma delimited) (*csv) |*.csv'
}
$FileBrowser.ShowDialog()

#Load csv 
$UsersToDisable = Import-Csv -Path $FileBrowser.FileName

$TodaysDate = Get-Date -Format "dd/MM/yyyy"

foreach ( $User in $UsersToDisable ){
    UserAccount = Get-AdUser -Filter "UserPrincipalName -eq '$($User.UserPrincipalName)'"
    Set-ADUser -Identity $UserAccount -Add @{msExchHideFromAddressLists="TRUE"} -Description "Disabled on $TodaysDate"                       
    Disable-ADAccount -Identity $UserAccount
    Move-ADObject -Identity $UserAccount -TargetPath 'OU=DisabledAccounts,DC=st-annes,DC=org,DC=uk' 
    $User."Account Deleted" = 'Disabled'
}

#Exports array to spreadsheet 
$UsersToDisable | Export-Csv -NoTypeInformation -Path (Join-Path -Path ([Environment]::GetFolderPath("Desktop")) `
                             -ChildPath "VEEAMExcludedUserAccounts.csv")