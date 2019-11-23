#Check if module is installed 
if (!(Get-Command Get-SPOUser -ErrorAction SilentlyContinue)) {
    Write-Output 'SharePoint Online Management Shell tools required. Download from https://www.microsoft.com/en-us/download/details.aspx?id=35588' 
    Exit 1
  }

#Creates connection to SPOService
Connect-SPOService -Url https://stannescommunityservices-admin.sharepoint.com/

#Script
$Site = Read-Host -Prompt 'Please enter site name e.g. https://stannescommunityservices-my.sharepoint.com/personal/john_smith_sniggs_com/'
$UserPrincipalName = Read-Host -Prompt 'Please enter the User Principal Name of the account you wish to grant access e.g. John.Smith@sniggs.com'
Set-SPOUser -Site $Site -LoginName $UserPrincipalName -IsSiteCollectionAdmin $true

#Disconnects from SPOService
Disconnect-SPOService
