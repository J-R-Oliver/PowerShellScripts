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
$TodaysDate = ( Get-Date -Format 'dd/MM/yyyy' ).Replace( '/' , '-' )
$Path = Join-Path -Path ([Environment]::GetFolderPath("Desktop")) -ChildPath "UserPhotoStatus ($TodaysDate).csv"
Get-Mailbox -RecipientTypeDetails UserMailbox -ResultSize Unlimited |
Select-Object 'DisplayName', 'UserPrincipalName', 'HasPicture' |
Export-Csv -Path $Path -NoTypeInformation 

#Close Exchange Session 
Remove-PSSession ( Get-PSSession )
