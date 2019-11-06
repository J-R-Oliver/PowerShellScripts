$TodaysDate = (Get-Date -Format "MM/dd/yyyy HH:mm").Replace(':','.').Replace('/','.')

$DisabledUsers = Get-ADUser -filter ‘Enabled -EQ $false’ -SearchBase "OU=St Annes Users,DC=st-annes,DC=org,DC=uk" -Properties whenChanged, DistinguishedName -ResultSetSize 1 |
                    Select-Object 'Name', 'SamAccountName', @{Name='WhenDisabled';Expression={$_.whenChanged.ToshortDatestring()}}, 'DistinguishedName', 'AD Account Status', 'AAD Account Status', 'Stripped Licenses'

ForEach ( $User in $DisabledUsers ){
    Set-ADUser -Identity $User.SamAccountName -Replace @{msExchHideFromAddressLists="TRUE"} -Description "Disabled on $($User.WhenDisabled)"
    Move-ADObject -Identity $User.DistinguishedName -TargetPath 'OU=DisabledAccounts,DC=st-annes,DC=org,DC=uk' 
    Write-Host "$($User.name)'s AD user account has been moved to disabled OU"
    $User.'AD Account Status' = 'Disabled'
}

$DisabledUsers | Export-Csv -NoTypeInformation -Path `
                    (Join-Path -Path ([Environment]::GetFolderPath("Desktop")) -ChildPath "Disabled User Report ($TodaysDate).csv")