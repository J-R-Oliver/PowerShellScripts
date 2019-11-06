#Gets computer account details, selects logondate and displayname, and exports to cvs

$command = {
Get-ADComputer -filter * -Properties lastlogondate |
Sort-Object -Property lastlogondate |
select -Property name,lastlogondate | 
export-CSV \\GE-FILESVR\share\IT\James\ComputerLastLogon.CSV -NoTypeInformation
}

#Runs command on GE-DC-York2

Invoke-Command -ComputerName GE-DC-York2 -ScriptBlock $command