Enter-PSSession -ComputerName ge-dc-york2 -Credential joliver-admin
Get-ADComputer -Filter {name -like "*-E*"} |
Select Name |
Export-Csv \\GE-FILESVR\share\IT\James\E-TypeLaptops.csv -NoTypeInformation