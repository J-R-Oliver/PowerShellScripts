#Install module
Install-Module MSOnline -Force

#Connect to Azure Active Directory
Connect-MsolService

#Create file browser
Add-Type -AssemblyName System.Windows.Forms
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
    InitialDirectory = [Environment]::GetFolderPath('Desktop')
    Filter = 'CSV (Comma delimited) (*csv) |*.csv'
}
$FileBrowser.ShowDialog()

#Load csv 
$OldDevices = Import-Csv -Path $FileBrowser.FileName

#Script
foreach ( $Device in $OldDevices ){
    try {
        Disable-MsolDevice -DeviceId $Device.DeviceId -Force -ErrorAction Stop
        $Device.Disabled = 'True'
    }
    catch {
        $Device.Disabled = 'False'
    }
}