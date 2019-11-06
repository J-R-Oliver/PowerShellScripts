$ListofUsers = Import-Csv -Path (Read-Host -Prompt "Enter path to CSV")

$ListofPasswordExpired = @()

ForEach ($User in $ListofUsers){
    $ListofPasswordExpired +=`
    Get-ADUser -Filter "UserPrincipalName -Like '$($User.User)'" -Properties "PasswordExpired" |
    Select-Object Name,UserPrincipalName,PasswordExpired 
}

$ListofPasswordExpired | Export-Csv -path $env:USERPROFILE\desktop\UserExpiredPasswordStatus.csv -NoTypeInformation