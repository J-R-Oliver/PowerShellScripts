#Check if necessary module is installed and install not pressent
If( $null -eq ( Get-InstalledModule `
                -Name "MSOnline" `
                -ErrorAction SilentlyContinue)){
    
    Install-Module MSOnline -Force

}

#Connect to Microsoft Online Service 
Connect-MsolService

#Script
$SelectParams = @{ 
    Property = 'Enabled',
               'DeviceId',
               'DisplayName',
               'DeviceTrustType',
               'ApproximateLastLogonTimestamp',
               'Disabled',
               'Removed'
}
[datetime]$UserDate = Read-Host -Prompt 'Please enter date in american format, e.g. 2019/11/01'
$OldDevices = Get-MsolDevice -all -LogonTimeBefore $UserDate | select-object @SelectParams
$OldDevices | Export-Csv -NoTypeInformation -Path (Join-Path -Path ([Environment]::GetFolderPath("Desktop")) -ChildPath "OldDevices.csv")