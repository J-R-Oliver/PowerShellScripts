#Imports MSOnline module if it's not installed already.
If( $null -eq ( Get-InstalledModule `
                -Name "MSOnline" `
                -ErrorAction SilentlyContinue)){
    
    Install-Module MSOnline -Force

}

#Opens session to AzureAD / Msol
Connect-AzureAD

Connect-MsolService

#Imports user information and creates array
$UserAccounts = Import-Csv -Path (Join-Path -Path ([Environment]::GetFolderPath("Desktop")) -ChildPath "UserAccounts.csv") |
                Select-Object 'User Principal Name', 'Display Name', 'Last Acvitiy',`
                               'Assigned Products', 'License Removed', 'Account Deleted'

#Removes licenses and adds user to exlusion group 
foreach ( $User in $UserAccounts ){
    try {
        $license = Get-MsolUser -UserPrincipalName $user."User Principal Name" | Select-Object -ExpandProperty licenses
        
        if ( $User."Assigned Products" -ne $null -or$User."Assigned Products" -ne "" ) {
            Set-MsolUserLicense -UserPrincipalName $user."User Principal Name" -RemoveLicense $license.AccountSkuId
            $User."Assigned Products" = $license.AccountSkuId
        } 
        
        $ObjectId = (Get-AzureADUser -ObjectId $User."User principal name").ObjectId

        Add-AzureADGroupMember -ObjectId '522017b3-6721-4e29-ae69-2bdee2821687' -RefObjectId $ObjectId

        $User."License Removed" = 'True'
        
    }
    catch {
        $User."License Removed" = 'Error'

    }
}

#Exports array to spreadsheet 
$UserAccounts | Export-Csv -NoTypeInformation -Path (Join-Path -Path ([Environment]::GetFolderPath("Desktop")) `
                           -ChildPath "VEEAMExcludedUserAccounts.csv")

