#Set repository / organisation variables
$TodaysDate = Get-Date -Format "dd/MM/yyyy"
$repositoryOneDrive = Get-VBORepository -Name "OneDrive Snapshots"
$repositoryVeeamBackups = Get-VBORepository -Name "Veeam Backups"
$organisation = Get-VBOOrganization -Name "StAnnesCommunityServices.onmicrosoft.com"

#Create / Open import csv window 
Add-Type -AssemblyName System.Windows.Forms
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
    InitialDirectory = [Environment]::GetFolderPath('Desktop')
    Filter = 'CSV (Comma delimited) (*csv) |*.csv'
}
$FileBrowser.ShowDialog()

#Load csv 
$Users = Import-Csv -Path $FileBrowser.FileName | Select-Object Name, UserPrincipalName, 'Removed from VEEAM'

foreach ( $user in $users ){
    
    try {
         #Remove user data from VEEAM
         $userOneDrive = Get-VBOEntityData -Type User -Repository $repositoryOneDrive -Name $User.Name
         $userVeeamBackups = Get-VBOEntityData -Type User -Repository $repositoryVeeamBackups -Name $User.Name

         Remove-VBOEntityData -Repository $repositoryOneDrive -User $userOneDrive -Mailbox -ArchiveMailbox -OneDrive -Sites
         Remove-VBOEntityData -Repository $repositoryVeeamBackups -User $userVeeamBackups -Mailbox -ArchiveMailbox -OneDrive -Sites

         #Remove license from user

         $licensedUser = Get-VBOLicensedUser -Organization $organisation -Name $User.UserPrincipalName
         Remove-VBOLicensedUser -User $licensedUser

         $User.'Removed from VEEAM' = 'Success'
    }
    catch {
        $User.'Removed from VEEAM' = 'Fail'
    }

}

$users | Export-Csv -NoTypeInformation -Path `
                    (Join-Path -Path ([Environment]::GetFolderPath("Desktop")) -ChildPath "Removed From VEEAM User Report ($TodaysDate).csv")

<# Documentation regarding Office365 VEEAM cmdlets = https://helpcenter.veeam.com/docs/vbo365/powershell/getting_started.html?ver=30 #>