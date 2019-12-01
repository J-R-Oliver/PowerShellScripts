#Note: GUI method is located in - Start >> System >> Advanced System Settings >> User Profile – Settings
#Registry locations of user accounts - HKLM\Software\Microsoft\WindowsNT\CurrentVersion\ProfileList
#Delete users files from C:\Users

#Script 
Get-LocalUser | Where-Object -Property " 'Name' - "
Read-Host -Prompt 'Please enter the username of the account you wish to remove'
Remove-LocalUser -Name $UserName 
Write-Host -Object "'n$UserName account has successfully been removed. 'n'nRemaining accounts:"
Get-LocalUser | Where-Object -Property " 'Name' - "