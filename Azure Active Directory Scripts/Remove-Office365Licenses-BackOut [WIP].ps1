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
$UserAccounts = Import-Csv -Path (Join-Path -Path ([Environment]::GetFolderPath("Desktop")) `
                        -ChildPath "VEEAMExcludedUserAccounts.csv") 

#Adds licenses and removes user from group
foreach ( $User in $UserAccounts ){
    try {
        if ( $User."Assigned Products" -ne $null -or$User."Assigned Products" -ne "" ) {
            Set-MsolUserLicense -UserPrincipalName $user."User Principal Name" -RemoveLicense $User."Assigned Products"

        } 

        $MemberId = (Get-AzureADUser -ObjectId $User."User principal name").ObjectId

        Remove-AzureADGroupMember -ObjectId '522017b3-6721-4e29-ae69-2bdee2821687' -MemberId $MemberId

        $User."License Removed" = 'False'
    }
    catch {
        $User."License Removed" = 'Error'
    }
}

#Exports array to spreadsheet 
$UserAccounts | Export-Csv -NoTypeInformation `
                -Path (Join-Path -Path ([Environment]::GetFolderPath("Desktop")) -ChildPath "VEEAMExcludedUserAccounts.csv")

