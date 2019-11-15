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
$MailboxIdentity = Read-Host -Prompt 'Please enter Mailbox Identity such as name, email address or user principal name'
Set-Mailbox -Identity $MailboxIdentity -HiddenFromAddressListsEnabled $true
$SelectParams = @{
    Property = 'DisplayName',
               'UserPrincipalName',
               'PrimarySmtpAddress',
               'HiddenFromAddressListsEnabled'
}
$MailboxSettings = Get-Mailbox -Identity $MailboxIdentity | Select-Object @SelectParams
Write-Host -Object "`n $MailboxIdentity has been hidden from the address list. The current mailbox settings are:"
$MailboxSettings

#Close Exchange Session 
Remove-PSSession ( Get-PSSession )