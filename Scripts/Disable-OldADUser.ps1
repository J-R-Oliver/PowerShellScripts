#Import user account CSV
$UsersToDisable = Import-Csv -Path (Join-Path -Path ([Environment]::GetFolderPath("Desktop")) -ChildPath "VEEAMExcludedUserAccounts.csv") 

$TodaysDate = Get-Date -Format "dd/MM/yyyy"

foreach ( $User in $UsersToDisable ){

        $UserAccount = Get-AdUser -Filter "UserPrincipalName -eq '$($User.UserPrincipalName)'"

        Set-ADUser -Identity $UserAccount -Add @{msExchHideFromAddressLists="TRUE"} -Description "Disabled on $TodaysDate"                       
        Disable-ADAccount -Identity $UserAccount
        Move-ADObject -Identity $UserAccount -TargetPath 'OU=DisabledAccounts,DC=st-annes,DC=org,DC=uk' 

        $User."Account Deleted" = 'Disabled'

}

#Exports array to spreadsheet 
$UsersToDisable | Export-Csv -NoTypeInformation -Path (Join-Path -Path ([Environment]::GetFolderPath("Desktop")) `
                             -ChildPath "VEEAMExcludedUserAccounts.csv")