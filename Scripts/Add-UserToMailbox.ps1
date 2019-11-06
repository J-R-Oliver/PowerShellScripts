#Script to add user to shared mailbox

#start office365 session
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential admin@garbuttelliott.onmicrosoft.com -Authentication Basic -AllowRedirection
Import-PSSession $Session

$Inbox = Read-Host -Prompt "Enter mailbox name"
$User = Read-Host -Prompt "Enter user to give full access"

add-mailboxpermission -Identity $Inbox -User $User -AccessRights FullAccess 