#Tests for Active Directory module.
Try { Import-Module ActiveDirectory -ErrorAction Stop }
Catch { Write-Warning "Unable to load Active Directory module because $($Error[0])"; Exit }

#Get all groups filterd by searchbase, and then creates a list of members. 
$ADGroups = Get-ADGroup -Properties * -Filter * -SearchBase "OU=SecurityGroups,DC=sniggsDC=corp"
$Table = @()
$Record = [ordered] @{
"Group Name" = ""
"Name" = ""
"Username" = ""
}
foreach ($Group in $ADGroups){
    $Arrayofmembers = Get-ADGroupMember -identity $Group | Select-Object name,samaccountname
    foreach ($Member in $Arrayofmembers){
        $Record."Group Name" = $Group.name
        $Record."Name" = $Member.name
        $Record."UserName" = $Member.samaccountname
        $objRecord = New-Object PSObject -property $Record
        $Table += $objrecord
    }
}

#Exports table to excel 
$Table | export-CSV \\GE-FILESVR\share\IT\James\UserGroupMatrix.CSV -NoTypeInformation 
