#Gets computer account details, selects logondate and displayname, and exports to cvs
$Command = {
Get-ADComputer -filter * -Properties lastlogondate |
Sort-Object -Property lastlogondate |
Select-Object -Property name,lastlogondate | 
export-CSV -NoTypeInformation -Path '\\GE-FILESVR\share\IT\James\ComputerLastLogon.CSV'
}
#Runs command on GE-DC-York2
Invoke-Command -ComputerName 'GE-DC-York2' -ScriptBlock $Command
