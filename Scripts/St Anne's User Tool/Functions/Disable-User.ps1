#Create sessions
Connect-MsolService
Connect-AzureAD

#Todays date
$TodaysDate = Get-Date -Format "dd/MM/yyyy"

$UserPrincipalName = Read-Host -Prompt 'Enter the user principal name e.g. john.smith@st-annes.org.uk'

#AD 
$ADUserAccount = @(Get-AdUser -Filter "UserPrincipalName -eq '$UserPrincipalName'")

If ( $ADUserAccount.Count -eq 1 ){
    Set-ADUser -Identity $ADUserAccount.SamAccountName -Add @{msExchHideFromAddressLists="TRUE"} -Description "Disabled on $TodaysDate"                       
    Disable-ADAccount -Identity $ADUserAccount.SamAccountName
    Move-ADObject -Identity $ADUserAccount.DistinguishedName -TargetPath 'OU=DisabledAccounts,DC=st-annes,DC=org,DC=uk' 
    Write-Host "$($ADUserAccount.name)'s AD user account has been Disabled" 
}
Else {
    Write-Host "Unable to find AD user for $UserPrincipalName"
}

#AAD
$AADUserAccount = @(Get-MsolUser -UserPrincipalName $UserPrincipalName)
        
If ( $AADUserAccount.Count -eq 1 ){
        
    #Add to VEEAM_ExcludedUsers
    $UserObjectId = (Get-AzureADUser -ObjectId $UserPrincipalName).ObjectId
    Add-AzureADGroupMember -ObjectId '522017b3-6721-4e29-ae69-2bdee2821687' -RefObjectId $UserObjectId

    #Create licenses string for Output 
    $licenseArray = $AADUserAccount.Licenses | foreach-Object {$_.AccountSkuId}
    If( $licenseArray.Count -eq 0 ){
        Write-Host "$($AADUserAccount.DisplayName)'s account is already unlicensed."
    
    } 
    Else {
        $licenseString = $licenseArray -join ", "
        Write-Host "$($AADUserAccount.DisplayName)'s account had the following licenses: $licenseString" 

        #Remove licenses
        Set-MsolUserLicense -UserPrincipalName $UserPrincipalName -RemoveLicense $licenseArray
    }
}
Else {
    Write-Host "Unable to find AAD user for $UserPrincipalName"
}