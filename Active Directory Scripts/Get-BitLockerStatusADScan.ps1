#Tests for Active Directory module.
Try { Import-Module ActiveDirectory -ErrorAction Stop }
Catch { Write-Warning "Unable to load Active Directory module because $($Error[0])"; Exit }

#Script
$Path = Join-Path -Path ([Environment]::GetFolderPath("Desktop")) -ChildPath 'ADComputerBitLockerStatus.csv'
$SelectParams = @{
    Property = @{ Name = 'ComputerName'; Expression = { $_.Name }},
               @{ Name = 'UserName'; Expression = { Get-ADUser -filter " Description -Like '*$($_.name)*'" -Properties description }},
               'LastLogonDate',
               @{ Name = 'BitLockerPasswordSet'; Expression = { 
                   Get-ADObject -Filter "objectClass -eq 'msFVE-RecoveryInformation'" -SearchBase $_.distinguishedName -Properties msFVE-RecoveryPassword,whenCreated |
                   Sort-Object whenCreated -Descending |
                   Select-Object -First 1 |
                   Select-Object -ExpandProperty whenCreated 
                   }
               }
}
Write-Output 'Creating report...'
Get-ADComputer -Filter {Operatingsystem -like '*Windows 10*' } -SearchBase 'DC=sniggs,DC=corp' -Properties LastLogonDate |
Select-Object @SelectParams |
Sort-Object ComputerName |
Export-Csv $Path -NoTypeInformation
