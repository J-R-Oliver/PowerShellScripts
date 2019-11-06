#Creates local variable for command
$command = {

#Import AD Module 
Import-Module ActiveDirectory 

#Gets users, sorts by firstname, selects attributes, exports as csv
Get-ADUser -Filter * -SearchBase "OU=York,DC=garbutt-elliott,DC=lan"-Properties displayname,office,officephone,mobile,department,title,EmailAddress | 
Where-Object {$_.DistinguishedName -notlike '*OU=Other,*'} |
Sort -Property displayname |
Select @{Name="Name";Expression={$_.displayname}},@{Name="Extension";Expression={$_.office}},@{Name="Landline";Expression={$_.officephone}},@{Name="Mobile";Expression={$_.mobile}}`
,@{Name="Department";Expression={$_.department}},@{Name="Job Title";Expression={$_.title}},@{Name="Email Address";Expression={$_.EmailAddress}} | 
export-CSV \\GE-FILESVR\share\IT\TelephoneDirectory.CSV -NoTypeInformation 
}

#Runs command on GE-DC-YORK2
Invoke-Command -ComputerName GE-DC-YORK2 -ScriptBlock $command