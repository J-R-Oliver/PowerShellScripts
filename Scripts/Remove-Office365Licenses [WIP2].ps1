#Imports user information and creates array
$UserAccounts = Import-Csv -Path (Join-Path -Path ([Environment]::GetFolderPath("Desktop")) -ChildPath "UserAccounts.csv") |
                Select-Object 'User Principal Name', 'DISPLAYNAME', 'LEAVEDATE', 'Assigned Products', 'License Removed', 'Account Deleted'

#Removes licenses and adds user to exlusion group 
foreach ( $User in $UserAccounts ){
        $license = Get-MsolUser -UserPrincipalName $user."User Principal Name" | Select-Object -ExpandProperty licenses
        
        Set-MsolUserLicense -UserPrincipalName $user."User Principal Name" -RemoveLicense $license.AccountSkuId
        $User."Assigned Products" = $license.AccountSkuId

        $ObjectId = (Get-AzureADUser -ObjectId $User."User principal name").ObjectId

        Add-AzureADGroupMember -ObjectId '522017b3-6721-4e29-ae69-2bdee2821687' -RefObjectId $ObjectId

        $User."License Removed" = 'True'
 
    }


#Exports array to spreadsheet 
$UserAccounts | Export-Csv -NoTypeInformation -Path (Join-Path -Path ([Environment]::GetFolderPath("Desktop")) `
                           -ChildPath "VEEAMExcludedUserAccounts.csv")

