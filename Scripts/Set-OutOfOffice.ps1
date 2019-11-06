$exchangeSession = New-PSSession `
    –ConfigurationName Microsoft.Exchange `
    –ConnectionUri https://ps.outlook.com/powershell `
    -Credential (Get-Credential james.oliver@st-annes.org.uk) `
    -Authentication "Basic" `
    -AllowRedirection

Import-PSSession $exchangeSession

$UserMailbox = Read-Host -Prompt 'Enter the name of the mailbox you wish to set the out of office'
$InternalMessage = Read-Host -Prompt 'Enter the message for internal response'
$ExternalMessage = Read-Host -Prompt 'Enter the message for external response'

Set-MailboxAutoReplyConfiguration `
    -Identity $UserMailbox `
    -AutoReplyState enabled `
    -ExternalAudience all `
    -InternalMessage $InternalMessage `
    -ExternalMessage $ExternalMessage