#Create sessions
Connect-MsolService


#Todays date
$TodaysDate = Get-Date -Format "dd/MM/yyyy"

#Create file explorer object 
Add-Type -AssemblyName System.Windows.Forms
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
    InitialDirectory = [Environment]::GetFolderPath('Desktop')
    Filter = 'CSV (Comma delimited) (*csv) |*.csv'
}

#Import csv of users
$FileBrowser.ShowDialog()
$UsersToEnable = Import-Csv -Path $FileBrowser.FileName

#Loop through spreadsheet and disables users
foreach ( $User in $UsersToEnable ){

        #AD 
        $ADUserAccount = Get-AdUser -Filter "UserPrincipalName -eq '$($User.UserPrincipalName)'"

        If ( $ADUserAccount.Count -eq 1 ){
            Set-ADUser -Identity $ADUserAccount -Add @{msExchHideFromAddressLists="Not Set"} -Description "Re-enabled on $TodaysDate"                       
            Enable-ADAccount -Identity $ADUserAccount
            Move-ADObject -Identity $ADUserAccount -TargetPath 'OU=st-annes users,DC=st-annes,DC=org,DC=uk' #Check that target path is correct
            $User.'Account Status' = 'Enabled'
        }
        Else {
            $User.'AD Account Status' = 'Unable to find user'
        }

        #AAD
        $AADUserAccount = Get-MsolUser -UserPrincipalName $user.UserPrincipalName
        
        If ( $AADUserAccount.Count -eq 1 ){
        
            #Remove from VEEAMExclusionGroup ############### Get proper group name 
            $UserObjectId = (Get-AzureADUser -ObjectId $user.UserPrincipalName).ObjectId
            Remove-AzureADGroupMember -ObjectId '522017b3-6721-4e29-ae69-2bdee2821687' -RefObjectId $UserObjectId

            #Add licenses to user
            Set-MsolUserLicense -UserPrincipalName $user.UserPrincipalName -AddLicenses $User.'Stripped Licenses'
            $User.'AAD Account Status' = 'Licensed & VEEAM included'
        }
        Else {
            $User.'AAD Account Status' = 'Unable to find user'
        }
}

#Export disabled user report to desktop

$UsersToEnable | Export-Csv -NoTypeInformation -Path `
                    (Join-Path -Path ([Environment]::GetFolderPath("Desktop")) -ChildPath "Disabled User Report ($TodaysDate).csv")