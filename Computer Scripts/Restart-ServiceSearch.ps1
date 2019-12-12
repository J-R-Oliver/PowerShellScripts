$Service = Read-Host -Prompt 'Please enter the name of service to restart'
Restart-Service -Name $Service
Write-Host -Object "`nThe current status of $Service is:"
Get-Service -Name $Service
