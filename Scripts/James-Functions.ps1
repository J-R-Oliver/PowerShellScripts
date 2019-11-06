function DcCon {
    Enter-PSSession -ComputerName sta-rds-01.st-annes.org.uk -Credential james.oliver
    
}

function 365Con {
    $365ConSession = `
    New-PSSession -ConfigurationName Microsoft.Exchange `
    -ConnectionUri https://outlook.office365.com/powershell-liveid/ `
    -Credential james.oliver@st-annes.org.uk `
    -Authentication Basic `
    -AllowRedirection 
    
    Import-PSSession -Session $365ConSession

}

function SPOCon {
    Connect-PnPOnline -Url https://stannescommunityservices.sharepoint.com `
    -UseWebLogin   

    <# Requires installation of PnP Powershell:Install-Module SharePointPnPPowerShellOnline
       Update PnP module: Update-Module SharePointPnPPowerShell* #>

}

function AzureAD {
    Connect-AzureAD -Credential "Get-Credential"

}