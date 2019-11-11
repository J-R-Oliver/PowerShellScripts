If( $null -eq ( Get-InstalledModule `
                -Name "MSOnline" `
                -ErrorAction SilentlyContinue)){
    
    Install-Module MSOnline -Force

}

Connect-MsolService

$Date = [datetime]’2019/05/05’

$OldDevices = Get-MsolDevice -all -LogonTimeBefore $Date | 
            select-object -Property Enabled, DeviceId, DisplayName, DeviceTrustType, ApproximateLastLogonTimestamp, Disabled, Removed

$OldDevices | Export-Csv -NoTypeInformation -Path (Join-Path -Path ([Environment]::GetFolderPath("Desktop")) -ChildPath "OldDevices.csv")