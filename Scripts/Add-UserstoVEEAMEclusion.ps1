Connect-AzureAD
$UserAccounts = Import-Csv -Path (Join-Path -Path ([Environment]::GetFolderPath("Desktop")) -ChildPath "September_Leavers_2019.csv")
foreach ( $User in $UserAccounts ){
        
        $ObjectId = (Get-AzureADUser -ObjectId $User."Userprincipalname").ObjectId

        Add-AzureADGroupMember -ObjectId '522017b3-6721-4e29-ae69-2bdee2821687' -RefObjectId $ObjectId

}