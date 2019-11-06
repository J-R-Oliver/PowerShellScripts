#Start Exchange Session
$SessionParams = @{
    ConfigurationName = 'Microsoft.Exchange'
    ConnectionUri = 'https://outlook.office365.com/powershell-liveid/'
    Credential = ( Get-Credential )
    Authentication = 'Basic'
    AllowRedirection = $true

}
Import-PSSession ( New-PSSession @SessionParams )

#Script
$Inbox = Read-Host -Prompt "Enter mailbox name"
$User = Read-Host -Prompt "Enter user to give full access"
add-mailboxpermission -Identity $Inbox -User $User -AccessRights FullAccess 

#Close Exchange Session 
Remove-PSSession ( Get-PSSession )