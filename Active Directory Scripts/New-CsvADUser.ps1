<#
Imports CSV file containting user data. CVS must be formated like below:

FirstName,LastName,Department,JobTitle, Manager,City, ProfileToCopy, Password
Jamie,Oliver,Payroll,Payroll Executive,John.Smith,York, Sam.Kevin, Goodday17
#>
#Create file browser
Add-Type -AssemblyName System.Windows.Forms
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
    InitialDirectory = [Environment]::GetFolderPath('Desktop')
    Filter = 'CSV (Comma delimited) (*csv) |*.csv'
}
$FileBrowser.ShowDialog()

#Load csv 
$NewUsers = Import-Csv -Path $FileBrowser.FileName 
Write-Host -Object "Importing CSV..."

#Script
$i = 1
foreach ( $User in $NewUsers ){
    #Write progress 
    write-Progress -activity "Processing $($User.FirstName) $($User.LastName)" -status "$i out of $($NewUsers.Count) completed"
    #Check if user already exists. If account exists message is written to terminal. 
    $Username = $User.FirstName + '.' + $User.LastName
    if ( Get-ADUser -Filter "SamAccountName -eq $Username" )
    {
      Write-Warning "A user account $Username already exists in Active Directory."
    }
    else
    {
        #Splat parameters. 
        $NewAdUserParams = @{
            SamAccountName = $Username
            UserPrincipalName = $Username + '@st-annes.org.uk'
            EmailAddress = $Username + '@st-annes.org.uk'
            Name = $User.FirstName + ' ' + $User.LastName
            DisplayName = $User.FirstName + ' ' + $User.LastName
            GivenName = $User.FirstName
            Surname = $User.LastName
            City = $User.City
            Department = $User.Department
            Title = $User.JobTitle
            Company = $User.Company
            AccountPassword = ConvertTo-SecureString $User.Password -AsPlainText -Force
            ChangePasswordAtLogon = $true
            Enabled = $true
            Manager = Get-ADUser -Filter  "name -like '$($User.Manager)'"  | Select-Object SamAccountName
        }
        #Create account
        New-ADUser @NewAdUserParams
        #Checks if a profile to copy can be found in AD
        if ( Get-ADUser -Filter  "name -like '$($User.ProfileToCopy)'" ) {
            #Retrieves group memberships of profil to copy and adds them to the newly created user
            $Memberships = Get-ADPrincipalGroupMembership -Identity $User.ProfileToCopy
            Add-ADPrincipalGroupMembership -Identity $Username -MemberOf $Memberships.SamAccountName
        }
        else {
            Add-ADPrincipalGroupMembership -Identity $Username -MemberOf 'AllEmps'
        }
    }
    Write-Host -Object "$($User.FirstName) $($User.LastName)'s account has been created."
    $i++ 
}
Write-Host -Object "Script has  completed"
