#Tests for Active Directory module.
Try { Import-Module ActiveDirectory -ErrorAction Stop }
Catch { Write-Warning "Unable to load Active Directory module because $($Error[0])"; Exit }

#Script
$Path = Join-Path -Path ([Environment]::GetFolderPath("Desktop")) -ChildPath 'ADComputerReport.csv'
$SelectParams = @{
    Property = @{ Name = 'ComputerName'; Expression = { $_.Name }},
               @{ Name = 'UserName'; Expression = { Get-ADUser -filter " Description -Like '*$($_.name)*'" -Properties description }},
               'LastLogonDate',
               @{ Name = 'OSVersion'; Expression = { $_.OperatingSystemVersion }}
}
Write-Output 'Creating report...'
Get-ADComputer -Filter 'Operatingsystem -like '*Windows 10*'' Properties LastLogonDate,OperatingSystem,OperatingSystemVersion |
Select-Object @SelectParams |
Sort-Object ComputerName |
Export-Csv $Path -NoTypeInformation
