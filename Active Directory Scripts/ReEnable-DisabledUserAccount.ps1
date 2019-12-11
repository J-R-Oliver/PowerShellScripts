#Tests for Active Directory module.
Try { Import-Module ActiveDirectory -ErrorAction Stop }
Catch { Write-Warning "Unable to load Active Directory module because $($Error[0])"; Exit }

#Script
$TodaysDate = Get-Date -Format 'dd/MM/yyyy'
$UserInput = Read-Host -Prompt 'Enter User Principal Name of user to re-enable ie john.smith@st-annes.org.uk'
$UserAccount = Get-AdUser -Filter "UserPrincipalName -eq '$UserInput'"
Set-ADUser -Identity $UserAccount -Replace @{msExchHideFromAddressLists="FALSE"} -Description "Re-enabled on $TodaysDate" 
Add-ADGroupMember -Identity 'AllEmps' -Members $UserAccount                     
Enable-ADAccount -Identity $UserAccount
Move-ADObject -Identity $UserAccount -TargetPath 'OU=St Annes Users,DC=st-annes,DC=org,DC=uk' 
