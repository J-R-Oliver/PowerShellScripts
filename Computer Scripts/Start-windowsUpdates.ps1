$UpdateSession = New-Object -ComObject Microsoft.Update.Session
$UpdateSearcher = $UpdateSession.CreateUpdateSearcher()
$Updates = @($UpdateSearcher.Search("IsHidden=0").Updates)
$Updates | Where-Object { !$_.IsInstalled } | Select-Object @{N='UpdateID';E={$_.Identity.UpdateID}}, @{N='Title';E={$_.Title}}, @{N='Downloaded';E={$_.IsDownloaded}}, @{N='Installed';E={$_.IsInstalled}}, @{N='Date Published'; E={[string]::Format("{0:d}", $_.LastDeploymentChangeTime)}} 


$SelectParams = @{
        Property = 'Title',
                   'Description',
                   'IsDownloaded',
                   'IsInstalled'
}
$UpdateSession = New-Object -ComObject Microsoft.Update.Session
$UpdateSearcher = $UpdateSession.CreateUpdateSearcher()
$Updates = @($UpdateSearcher.Search("IsInstalled=0").Updates)
$Updates | Select-Object @SelectParams

#https://docs.microsoft.com/en-us/windows/win32/wua_sdk/windows-update-agent-object-model

$UpdateDownloader = $UpdateSession.CreateUpdateDownloader()
