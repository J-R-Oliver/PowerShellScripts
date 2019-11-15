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
$GroupIdentity = Read-Host -Prompt 'Please enter Mailbox Identity such as itoperationsandstrategy'
Set-UnifiedGroup $GroupIdentity -HiddenFromAddressListsEnabled $True
$SelectParams = @{
    Property = 'DisplayName',
               'Alias',
               'HiddenFromAddressListsEnabled',
               'PrimarySmtpAddress'
}
$MailboxSettings = Get-UnifiedGroup $GroupIdentity | Select-Object @SelectParams
Write-Host -Object "`n $GroupIdentity has been hidden from the address list. The current mailbox settings are:"
$MailboxSettings

#Close Exchange Session 
Remove-PSSession ( Get-PSSession )