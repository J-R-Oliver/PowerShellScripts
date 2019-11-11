#Creates session to the Security and Compliance center in Office365.

$Session = New-PSSession `
-ConfigurationName Microsoft.Exchange `
-ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/ `
-Authentication Basic `
-AllowRedirection `
-Credential james.oliver@st-annes.org.uk

Import-PSSession $session

#Starts hard delete of items contained within the Content Search. 

$SearchName = Read-Host -Prompt "Enter the search name."

New-ComplianceSearchAction -SearchName $SearchName -Purge -PurgeType HardDelete