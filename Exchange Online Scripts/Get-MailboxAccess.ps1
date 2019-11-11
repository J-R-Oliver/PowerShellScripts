#Start office365 session
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential admin@garbuttelliott.onmicrosoft.com -Authentication Basic -AllowRedirection
Import-PSSession $Session

#script
Get-Mailbox | 
Get-MailboxPermission | 
where {$_.user.tostring() -ne "NT AUTHORITY\SELF" -and $_.user.tostring() -and $_.IsInherited -eq $false} |
Select @{Name="Mailbox";Expression={$_.Identity}}, User, AccessRights |
export-CSV \\GE-FILESVR\share\IT\James\MailboxAccess.CSV -NoTypeInformation 


