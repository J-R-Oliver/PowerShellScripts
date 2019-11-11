#Get all users set to disabled inside of St Anne's Users OU. ResultSetSize limits the number of users.
$ADUserParams = @{ 
    Filter = ‘Enabled -eq $false’
    SearchBase = 'OU=St Annes Users,DC=st-annes,DC=org,DC=uk'
    Properties = @( 'whenChanged', 'DistinguishedName' )
    ResultSetSize = 250
}
$SelectParams = @{
    Property = 'Name', 
               'SamAccountName', 
               @{Name='WhenDisabled';Expression={$_.whenChanged.ToshortDatestring()}}, 
               'DistinguishedName', 
               'AD Account Status', 
               'AAD Account Status', 
               'Stripped Licenses'
}
$DisabledUsers = Get-ADUser $ADUserParams | Select-Object $SelectParams

#Moves users, hides from address book and adds disabled description.
foreach ( $User in $DisabledUsers ){
    Set-ADUser -Identity $User.SamAccountName -Replace @{msExchHideFromAddressLists="TRUE"} -Description "Disabled on $($User.WhenDisabled)"
    Move-ADObject -Identity $User.DistinguishedName -TargetPath 'OU=DisabledAccounts,DC=st-annes,DC=org,DC=uk' 
    Write-Host "$($User.name)'s AD user account has been moved to disabled OU"
    $User.'AD Account Status' = 'Disabled'
}

#Export csv 
$TodaysDate = (Get-Date -Format "MM/dd/yyyy HH:mm").Replace(':','.').Replace('/','.')
$Path = Join-Path -Path ([Environment]::GetFolderPath("Desktop")) -ChildPath "Disabled User Report ($TodaysDate).csv"
$DisabledUsers | Export-Csv -NoTypeInformation -Path $Path
