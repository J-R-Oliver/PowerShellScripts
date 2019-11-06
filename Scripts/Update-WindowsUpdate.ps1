If( $null -eq ( Get-InstalledModule `
                -Name "PSWindowsUpdate" `
                -ErrorAction SilentlyContinue)){
    
    Install-Module PSWindowsUpdate -Force

}

#Get-WindowsUpdate

Install-WindowsUpdate