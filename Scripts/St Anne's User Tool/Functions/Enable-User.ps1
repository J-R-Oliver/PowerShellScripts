#Create sessions
Connect-MsolService


#Todays date
$TodaysDate = Get-Date -Format "dd/MM/yyyy"

$UserPrincipalName = Read-Host -Prompt 'Enter the user principal name e.g. john.smith@st-annes.org.uk'

#AD 
$ADUserAccount = Get-AdUser -Filter "UserPrincipalName -eq '$UserPrincipalName'"

If ( $ADUserAccount.Count -eq 1 ){
Set-ADUser -Identity $ADUserAccount -Add @{msExchHideFromAddressLists="Not Set"} -Description "Re-enabled on $TodaysDate"                       
Enable-ADAccount -Identity $ADUserAccount
Move-ADObject -Identity $ADUserAccount -TargetPath 'OU=st-annes users,DC=st-annes,DC=org,DC=uk' #Check that target path is correct
Write-Host "$($ADUserAccount.name)'s AD user account has been Re-enabled" #Check object property exists
}
 Else {
    Write-Host "Unable to find AD user for $UserPrincipalName"
}

#AAD
$AADUserAccount = Get-MsolUser -UserPrincipalName $UserPrincipalName
        
If ( $AADUserAccount.Count -eq 1 ){
        
    #Remove from VEEAMExclusionGroup ############### Get proper group name 
    $UserObjectId = (Get-AzureADUser -ObjectId $UserPrincipalName).ObjectId
    Remove-AzureADGroupMember -ObjectId '522017b3-6721-4e29-ae69-2bdee2821687' -RefObjectId $UserObjectId

    #Add licenses to user
    Write-Host "================ Please choose license type ================"
    Write-Host "1: Press '1' for E2 license."
    Write-Host "2: Press '2' for E3 license."
    $LicenseChoice = Read-Host "Please make a selection..."

    switch ( $LicenseChoice) {
        '1' {  
            Write-Host 'Assigning E2 license...'
            $Licenses = licenses 
        }
        '2' { 
            Write-Host 'Assigning E3 license...'
            $Licenses = licenses 
        }
    }

    Set-MsolUserLicense -UserPrincipalName UserPrincipalName -AddLicenses $Licenses 
    Write-Host "$($AADUserAccount.name)'s account has been licensed"
}
Else {
    Write-Host "Unable to find AAD user for $UserPrincipalName"
}
