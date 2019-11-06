#Describes how csv should be formatted 
Write-Host "csv should contain at least the following collumns. If profile to copy is left blank then default permissions will be assigned"
Write-Host "For example...`n"
Write-Host "| Firstname | Lastname | Description | Password  | Profile to copy |"
Write-Host "____________________________________________________________________"
Write-Host "| John      | Smith    | Head Office | Niceday15 | Sarah Smith     |"

#Create file explorer object 
Add-Type -AssemblyName System.Windows.Forms
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
    InitialDirectory = [Environment]::GetFolderPath('Desktop')
    Filter = 'CSV (Comma delimited) (*csv) |*.csv'
}

#Imports CVS file
Write-Host -Object "Importing CSV..."
$FileBrowser.ShowDialog()
$ADUsers = Import-Csv -Path $FileBrowser.FileName | 
            Select-Object 'Firstname', 'Lastname', 'Description', 'Password', 'Profile to copy', 'Account Created', 'Groups Added'
Write-Host -Object "Importing CSV..."

$TotalUsers = $ADUsers.Count
$i         = 1

#Runs through each user in the CSV file.

foreach ($User in $ADUsers){
  #Writes progress

   Write-Progress -activity "Processing $Username" -status "$i out of $TotalUsers completed"

    #Check if the user account already exists in AD
       
    if (Get-ADUser -Filter {SamAccountName -eq $Username})
    {
      #If user does exist, output a warning message

      Write-Warning "A user account $Username already exists in Active Directory."
      User.'Account Created' = 'Account exists' 
    }
    else
    {
    #If a user does not exist then create a new user account. The user will be placed in the OU based upon department. 
    $Username  = $User.firstname.ToLower().Substring(0,1) + $User.lastname.ToLower()

    New-ADUser `
      -SamAccountName $Username `
      -UserPrincipalName $Username'@st-annes.org.uk' `
      -EmailAddress $Username'@st-annes.org.uk' `
      -Name "$Firstname $Lastname" `
      -DisplayName "$Firstname $Lastname" `
      -GivenName $User.firstname `
      -Surname $User.lastname `
      -Company "St Anne's Community Services"`
      -Path 'OU=st-annes users,DC=st-annes,DC=org,DC=uk' #Check that target path is correct `
      -AccountPassword (convertto-securestring $User.password -AsPlainText -Force) `
      -Enabled $True `
      -Description $User.description

      User.'Account Created' = 'Account Created' 
      
       #Switch decides whether to copy another users profile or add basic permissions 

      if ( $User.'Profile to copy' -eq 1 ){
        
        try {

          Add-ADPrincipalGroupMembership `
        -Identity $Username `
        -MemberOf ( Get-ADPrincipalGroupMembership -Identity ( $User.'Profile to copy'.Trim().Replace(" ",".") ) ).SamAccountName

        User.'Groups Added' = 'Profile copied' 
        }
        catch {
          
          Add-ADPrincipalGroupMembership `
        -Identity $Username `
        -MemberOf 'AllEmps','the other group' #####Check groups
        
         User.'Groups Added' = 'Copy failed. Default added' 
        }
        
      } 
      else {
        
        Add-ADPrincipalGroupMembership `
        -Identity $Username `
        -MemberOf 'AllEmps','the other group' #####Check groups
        
        User.'Groups Added' = 'Default added' 
      }
      
      Write-Host -Object "Account $Username has been created."

    }
}

$TodaysDate = Get-Date -Format "dd/MM/yyyy"

$ADUsers | Export-Csv -NoTypeInformation -Path `
            (Join-Path -Path ([Environment]::GetFolderPath("Desktop")) -ChildPath "User Accounts Created ($TodaysDate).csv")

Write-Host -Object "Script has  completed"