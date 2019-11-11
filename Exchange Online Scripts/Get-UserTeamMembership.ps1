Connect-MicrosoftTeams
Get-Team -User ((Read-Host -Prompt 'Enter username')+'@st-annes.org.uk') | Select-Object DisplayName