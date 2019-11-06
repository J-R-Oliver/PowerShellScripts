<#
Imports CSV file containting user data. CVS must be formated like below:

firstname,lastname,department,job title,manager,city
Jamie,Oliver,Payroll,Payroll Executive,Julie Gunnel,York

#>

#Creates arrays containg the group memberships based on departments. 

$AccountsMemberships    = @('DL_All Users','DL_GE','Drive-lockdown','ge-gatewayaccess','SEC_GE_ALLNONADMINS','SEC_GE_ALLUSERS','SEC_GE_AUDIT','SEC_GE_BUSSERV','SEC_GE_TAX','TAXMAN','Terminal Server Group Policy')
$AdminMemberships       = @('DL_All Users','DL_GE','Drive-lockdown','ge-gatewayaccess','SEC_GE_ADMIN','SEC_GE_ALLNONADMINS','SEC_GE_ALLUSERS','Terminal Server Group Policy')
$CharitiesMemberships   = @('DL_All Users','DL_GE','Drive-lockdown','ge-gatewayaccess','SEC_GE_ALLNONADMINS','SEC_GE_ALLUSERS','SEC_GE_BUSSERV','SEC_GE_CHARITY','SEC_GE_TAX','Terminal Server Group Policy')
$CorporateMemberships   = @('DL_All Users','DL_Corp Fin Advisor','DL_GE','Drive-lockdown','SEC_GE_ALLNONADMINS','SEC_GE_ALLUSERS','SEC_GE_CORPFIN','SEC_GE_FORECAST5','Terminal Server Group Policy')
$GEWMMemberships        = @('DL_All Users','DL_GEWM','SEC_GE_ALLNONADMINS','SEC_GE_ALLUSERS','SEC_GE_WEALTHMAN','SEC_GE_WEALTHMAN_COMPLIANCE','SEC_GE_WM_HolidayRead','Terminal Server Group Policy')
$HRMemberships          = @('DL_All Users','DL_EngaG+E','DL_GE','ge-gatewayaccess','SEC_GE_ALLNONADMINS','SEC_GE_ALLUSERS','SEC_GE_ENGAGE','SEC_GE_HR','SEC_GE_PAs','SEC_GE_SECRETARIES')
$MarketingMemberships   = @('DL_All Users','DL_GE','DL_York BD Marketing','Drive-lockdown','SEC_GE_ALLNONADMINS','SEC_GE_MARKETING')
$PartnersMemberships    = @('DL_All Users','DL_GE','DL_Partners','DL_Website Profiles','Drive-lockdown','KPI_Info','SEC_GE_ALLNONADMINS','SEC_GE_ALLUSERS','SEC_GE_PARTNERS','SEC_GE_PROJECT_BOARD','Terminal Server Group Policy')
$PayrollMemberships     = @('DL_All Users','DL_GE','DL_Payroll','DL_York Office','SEC_GE_ALLNONADMINS','SEC_GE_ALLUSERS','SEC_GE_PAYROLL','SEC_GE_YORK')
$PrivateMemberships     = @('Alphatax Users','DL_All Users','DL_Tax Software','DL_Tax-Trust','SEC_GE_ALLNONADMINS','SEC_GE_ALLUSERS','SEC_GE_TAX','TAXMAN','Terminal Server Group Policy')
$SecretariesMemberships = @('DL_All Users','DL_GE','Meeting Room Admins','SEC_GE_ALLNONADMINS','SEC_GE_ALLUSERS','SEC_GE_PAs','SEC_GE_SECRETARIES','Terminal Server Group Policy')
$TaxMemberships         = @('DL_All Users','DL_GE','DL_Tax-Team','ge-gatewayaccess','SEC_GE_ALLNONADMINS','SEC_GE_ALLUSERS','SEC_GE_TAX','Terminal Server Group Policy')

#Imports CVS file

$ADUsers = Import-csv -Path (Read-Host -Prompt "Enter file path to new user CSV. EG C:\users\James\Desktop\newuser.CSV")
Write-Host -Object "Importing CSV..."

$TotalUsers = $ADUsers.Count
$i         = 1

#Runs through each user in the CSV file.

foreach ($User in $ADUsers)
{
  #User variable are defined here.

  $Username        = $User.firstname.ToLower().Substring(0,1)+$User.lastname.ToLower()
  $Password        = 'train123@'
  $Firstname       = $User.firstname
  $Lastname        = $User.lastname
  $Jobtitle        = $User.jobtitle
  $Department      = $User.department 
  $OU              = "OU=$($User.department),OU=York,DC=garbutt-elliott,DC=lan"
  $Manager         = Get-ADUser -filter  "name -like '$($User.manager)'"  | Select-Object SamAccountName
  $City            = $User.city
  switch ($User.city) {
    York  { $DL = 'DL_York Office'  }
    Leeds { $DL = 'DL_Leeds Office' }
  }

   #Writes progress

   Write-Progress -activity "Processing $Username" -status "$i out of $totalusers completed"

   #Sets email domain and company based upon department.

    if ($department -eq 'GEWM') 
    {
      $emaildomain = 'ge-wm.co.uk'
      $Company = 'G&E Wealth Management'   
    }
       
    else 
    {
      $emaildomain = 'garbutt-elliott.co.uk'
      $Company = 'Garbutt + Elliott'
    }
    
    #Check if the user account already exists in AD
       
    if (Get-ADUser -Filter {SamAccountName -eq $Username})
    {
      #If user does exist, output a warning message

      Write-Warning "A user account $Username already exists in Active Directory."
    }
    else
    {
    #If a user does not exist then create a new user account. The user will be placed in the OU based upon department. 
              
    New-ADUser `
      -SamAccountName $Username `
      -UserPrincipalName $Username"@"$emaildomain `
      -EmailAddress $Username"@"$emaildomain `
      -Name "$Firstname $Lastname" `
      -DisplayName "$Firstname $Lastname" `
      -GivenName $Firstname `
      -Surname $Lastname `
      -City $City `
      -Department $Department `
      -Title $Jobtitle `
      -Company $Company `
      -OtherAttributes @{'proxyAddresses'="SMTP:$Username@$emaildomain","smtp:$Username@GarbuttElliott.onmicrosoft.com"} `
      -Path $OU `
      -AccountPassword (convertto-securestring $Password -AsPlainText -Force) `
      -ChangePasswordAtLogon $True `
      -Enabled $True `
      -Manager $Manager 
      
       #Switch decides which array of groups to assign to user. 

      switch ($Department) 
      {
        'Accounts and Audit'    { $Memberships = $AccountsMemberships }
        'Admin'                 { $Memberships = $AdminMemberships }
        'Charities'             { $Memberships = $CharitiesMemberships }
        'Corporate Finance'     { $Memberships = $CorporateMemberships }
        'GEWM'                  { $Memberships = $GEWMMemberships }
        'HR and Operations'     { $Memberships = $HRMemberships }
        'Marketing'             { $Memberships = $MarketingMemberships }
        'Partners'              { $Memberships = $PartnersMemberships }
        'payrolL'               { $Memberships = $PayrollMemberships }
        'Private Clients'       { $Memberships = $PrivateMemberships }
        'Secretaries and PAs'   { $Memberships = $SecretariesMemberships }
        'Tax'                   { $Memberships = $TaxMemberships }
      } 
      
      #Adds newly created user to all groups in the array.

      Add-ADPrincipalGroupMembership `
      -Identity $Username `
      -MemberOf $Memberships

      #Adds user to the correct DL for their office.

      Add-ADPrincipalGroupMembership `
      -Identity $Username `
      -MemberOf $DL
      
      Write-Host -Object "Account $Username has been created."

    }
}

Write-Host -Object "Script has  completed"