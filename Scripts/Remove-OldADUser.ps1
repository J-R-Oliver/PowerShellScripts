$UserAccounts = Import-Csv -Path (Join-Path -Path ([Environment]::GetFolderPath("Desktop")) -ChildPath "UserAccounts.csv") 

foreach ( $User in $UserAccounts ){

    try {
        Remove-ADUser -Identity ( $User."User Principal Name" -replace "@st-annes.org.uk","" ) -ErrorAction Stop

        $User."Account Deleted" = 'True'
    }
    catch {
        $User."Account Deleted" = 'False'
        
    }
}