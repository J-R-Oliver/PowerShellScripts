#Connect to Azure Active Directory
Connect-AzureAD

#Create file browser
Add-Type -AssemblyName System.Windows.Forms
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
    InitialDirectory = [Environment]::GetFolderPath('Desktop')
    Filter = 'CSV (Comma delimited) (*csv) |*.csv'
}
$FileBrowser.ShowDialog()

#Load csv 
$UserAccounts = Import-Csv -Path $FileBrowser.FileName

#Script
foreach ( $User in $UserAccounts ){  
    $ObjectId = ( Get-AzureADUser -ObjectId $User."Userprincipalname" ).ObjectId
    Add-AzureADGroupMember -ObjectId '522017b3-6721-4e29-ae69-2bdee2821687' -RefObjectId $ObjectId
}