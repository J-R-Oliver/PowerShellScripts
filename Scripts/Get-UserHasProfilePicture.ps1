#Create remote session

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential admin@garbuttelliott.onmicrosoft.com -Authentication Basic -AllowRedirection
Import-PSSession $Session

#command 

$Result=@()
$allUsers = Get-Mailbox -RecipientTypeDetails UserMailbox -ResultSize Unlimited
$totalusers = $allUsers.Count
$i = 1 
$allUsers | ForEach-Object {
$user = $_
Write-Progress -activity "Processing $user" -status "$i out of $totalusers completed"
$photoObj = Get-Userphoto -identity $user.UserPrincipalName -ErrorAction SilentlyContinue
$hasPhoto = $false
if ($photoObj.PictureData -ne $null)
{
$hasPhoto = $true
}
$Result += New-Object PSObject -property @{ 
UserName = $user.DisplayName
UserPrincipalName = $user.UserPrincipalName
HasProfilePicture = $hasPhoto
}
$i++
}
$Result | Export-CSV \\GE-FILESVR\share\IT\James\UsersPhotoStatus.csv -NoTypeInformation 

#Instructions
#link = https://www.morgantechspace.com/2018/05/export-office-365-users-profile-picture-status-powershell.html