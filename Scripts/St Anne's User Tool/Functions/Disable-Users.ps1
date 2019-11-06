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
$UsersToDisable = Import-Csv -Path $FileBrowser.FileName | Select-Object Name, FLM, UserPrincipalName, 'AD Account Status', 'AAD Account Status', 'Stripped Licenses' #Collumn names to add 

#Loop through spreadsheet and disables users
foreach ( $User in $UsersToDisable ){

        #Create userprincipalname from name
        $User.UserPrincipalName = $User.Name.Trim().Replace(" ",".") + "@st-annes.org.uk"

        #AD 
        $ADUserAccount = Get-AdUser -Filter "UserPrincipalName -eq '$($User.UserPrincipalName)'"

        If ( $ADUserAccount.Count -eq 1 ){
            Set-ADUser -Identity $ADUserAccount -Add @{msExchHideFromAddressLists="TRUE"} -Description "Disabled on $TodaysDate"                       
            Disable-ADAccount -Identity $ADUserAccount
            Move-ADObject -Identity $ADUserAccount -TargetPath 'OU=DisabledAccounts,DC=st-annes,DC=org,DC=uk' 
            $User.'Account Status' = 'Disabled'
        }
        Else {
            $User.'AD Account Status' = 'Unable to find user'
        }

        #AAD
        $AADUserAccount = Get-MsolUser -UserPrincipalName $user.UserPrincipalName
        
        If ( $AADUserAccount.Count -eq 1 ){
        
            #Add to VEEAMExclusionGroup ############### Get proper group name 
            $UserObjectId = (Get-AzureADUser -ObjectId $user.UserPrincipalName).ObjectId
            Add-AzureADGroupMember -ObjectId '522017b3-6721-4e29-ae69-2bdee2821687' -RefObjectId $UserObjectId

            #Create licenses string for Output 
            $licenseArray = $AADUserAccount.Licenses | foreach-Object {$_.AccountSkuId}
            If( $licenseArray.Count -eq 0 ){
                $User.'Stripped Licenses' = 'Unlicensed'
            } 
            Else {
                $licenseString = $licenseArray -join ", "
                $User.'Stripped Licenses' = $licenseString

                #Remove licenses
                Set-MsolUserLicense -UserPrincipalName $user.UserPrincipalName -RemoveLicense $licenseArray
            }
            
            $User.'AAD Account Status' = 'Unlicensed & VEEAM excluded'
        }
        Else {
            $User.'AAD Account Status' = 'Unable to find user'
        }
}

#Export disabled user report to desktop

$UsersToDisable | Export-Csv -NoTypeInformation -Path `
                    (Join-Path -Path ([Environment]::GetFolderPath("Desktop")) -ChildPath "Disabled User Report ($TodaysDate).csv")