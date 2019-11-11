If( $null -eq ( Get-InstalledModule `
                -Name "MSOnline" `
                -ErrorAction SilentlyContinue)){
    
    Install-Module MSOnline -Force

}

Connect-MsolService

$OldDevices = Import-Csv -Path (Join-Path -Path ([Environment]::GetFolderPath("Desktop")) -ChildPath "OldDevices.csv") 

ForEach ( $Device in $OldDevices ){
    try { 
        Remove-MsolDevice -DeviceId $Device.DeviceId -Force -ErrorAction Stop
        $Device.Removed = 'True'
    }
    catch {
        $Device.Removed = 'False'
    }
}