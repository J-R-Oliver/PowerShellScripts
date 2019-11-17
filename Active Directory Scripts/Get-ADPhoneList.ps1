#Import AD Module 
Try { Import-Module ActiveDirectory -ErrorAction Stop }
Catch { Write-Warning "Unable to load Active Directory module because $($Error[0])"; Exit }

#Script
$ADUserParams = @{
    Filter = {$_.DistinguishedName -notlike '*OU=Other,*'}
    SearchBase = 'OU=Users,DC=sniggs,DC=corp'
    Properties = 'displayname,office,officephone,mobile,department,title,EmailAddress'
}
$SelectParams = @{
    Property = @{ Name = "Name"; Expression = { $_.displayname }},
               @{ Name = "Extension"; Expression = { $_.office }},
               @{ Name = "Landline"; Expression = { $_.officephone }},
               @{ Name = "Mobile"; Expression = { $_.mobile }},
               @{ Name = "Department"; Expression = { $_.department }},
               @{ Name = "Job Title"; Expression = { $_.title }},
               @{ Name = "Email Address"; Expression = { $_.EmailAddress }}
}
$Path = Join-Path -Path ([Environment]::GetFolderPath("Desktop")) -ChildPath 'ADTelephoneDirectory.csv'
Get-ADuser $ADUserParams |
Select-Object $SelectParams |
Sort-Object -Property Name |
Export-Csv -NoTypeInformation -Path $Path
