#Tests for Active Directory module.
Try { Import-Module ActiveDirectory -ErrorAction Stop }
Catch { Write-Warning "Unable to load Active Directory module because $($Error[0])"; Exit }

#Get all users inside of DisabledAccounts OU. ResultSetSize limits the number of users.
$DisabledUsers = Get-ADUser -Filter * -SearchBase 'OU=DisabledAccounts,DC=st-annes,DC=org,DC=uk' -ResultSetSize $null
#Removes users from group
Remove-ADGroupMember -Identity 'AllEmps' -Members $DisabledUsers