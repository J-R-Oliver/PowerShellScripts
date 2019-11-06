If( $null -eq ( Get-InstalledModule `
                -Name "MSOnline" `
                -ErrorAction SilentlyContinue)){
    
    Install-Module MSOnline -Force

}

Connect-MsolService

$OldDevices = Import-Csv -Path (Join-Path -Path ([Environment]::GetFolderPath("Desktop")) -ChildPath "OldDevices.csv")

ForEach ( $Device in $OldDevices ){
    try {
        Disable-MsolDevice -DeviceId $Device.DeviceId -Force -ErrorAction Stop
        $Device.Disabled = 'True'
    }
    catch {
        $Device.Disabled = 'False'
    }
}