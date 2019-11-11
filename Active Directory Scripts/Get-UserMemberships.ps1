#Creates local variable for command
$command = {

Import-Module ActiveDirectory

#Get all groups filterd by searchbase
$Groups = Get-ADGroup -Properties * -Filter * -SearchBase "OU=SecurityGroups,DC=garbutt-elliott,DC=lan"

$Table = @()

$Record = [ordered]@{
"Group Name" = ""
"Name" = ""
"Username" = ""
}

Foreach ($Group in $Groups)
{

$Arrayofmembers = Get-ADGroupMember -identity $Group | select name,samaccountname

foreach ($Member in $Arrayofmembers)
{
$Record."Group Name" = $Group.name
$Record."Name" = $Member.name
$Record."UserName" = $Member.samaccountname
$objRecord = New-Object PSObject -property $Record
$Table += $objrecord
}

}

#Exports table to excel 
$Table | export-CSV \\GE-FILESVR\share\IT\James\UserGroupMatrix.CSV -NoTypeInformation 

}

#Runs command on GE-DC-YORK2
Invoke-Command -ComputerName GE-DC-YORK2 -ScriptBlock $command