#Remove user data from VEEAM

$UserName = Read-Host -Prompt 'Please enter name of user. E.G. John Smith'

$UserPrincipalName = Read-Host -Prompt 'Please enter name of user principal name. E.G. john.smith@st-annes.org.uk'

$repositoryOneDrive = Get-VBORepository -Name "OneDrive Snapshots"
$repositoryVeeamBackups = Get-VBORepository -Name "Veeam Backups"

$userOneDrive = Get-VBOEntityData -Type User -Repository $repositoryOneDrive -Name $UserName
$userVeeamBackups = Get-VBOEntityData -Type User -Repository $repositoryVeeamBackups -Name $UserName

Remove-VBOEntityData -Repository $repositoryOneDrive -User $userOneDrive -Mailbox -ArchiveMailbox -OneDrive -Sites
Remove-VBOEntityData -Repository $repositoryVeeamBackups -User $userVeeamBackups -Mailbox -ArchiveMailbox -OneDrive -Sites

#Remove license from user

$org = Get-VBOOrganization -Name "StAnnesCommunityServices.onmicrosoft.com"

$licensedUser = Get-VBOLicensedUser -Organization $org -Name $UserPrincipalName

Remove-VBOLicensedUser -User $licensedUser

<# Documentation regarding Office365 VEEAM cmdlets = https://helpcenter.veeam.com/docs/vbo365/powershell/getting_started.html?ver=30 #>