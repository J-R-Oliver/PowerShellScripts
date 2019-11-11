#Creates local variable for command
$Command = {
#Import AD Module 
Import-Module ActiveDirectory 
#Script
$ADUserParams = @{
    Filter = {$_.DistinguishedName -notlike '*OU=Other,*'}
    SearchBase = 'OU=York,DC=garbutt-elliott,DC=lan'
    Properties = 'displayname,office,officephone,mobile,department,title,EmailAddress'
}
$SelectParams = @{
    Property = @{Name="Name";Expression={$_.displayname}},
               @{Name="Extension";Expression={$_.office}},
               @{Name="Landline";Expression={$_.officephone}},
               @{Name="Mobile";Expression={$_.mobile}},
               @{Name="Department";Expression={$_.department}},
               @{Name="Job Title";Expression={$_.title}},
               @{Name="Email Address";Expression={$_.EmailAddress}}
}
Get-ADuser $ADUserParams |
Select-Object $SelectParams |
Sort-Object -Property Name |
Export-Csv -NoTypeInformation -Path '\\GE-FILESVR\share\IT\TelephoneDirectory.CSV'
#Runs command on GE-DC-YORK2
Invoke-Command -ComputerName 'GE-DC-YORK2' -ScriptBlock $Command
