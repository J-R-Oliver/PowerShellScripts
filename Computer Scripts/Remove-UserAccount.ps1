#Note: GUI method is located in - Start >> System >> Advanced System Settings >> User Profile – Settings

#Registry locations of user accounts - Delete user folder (key)
HKLM\Software\Microsoft\WindowsNT\CurrentVersion\ProfileList

#Delete users profile from C:\Users\

Get-ChildItem -Path "C:\Users\$UserName"

#Registry locations of user accounts - Delete user folder (key)
HKLM\Software\Microsoft\WindowsNT\CurrentVersion\ProfileList

Get-ChildItem -Path HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\

Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList

HKLM:\Software\Microsoft\WindowsNT\CurrentVersion\ProfileList
<#
NOTES

https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-childitem?view=powershell-6

https://www.itechguides.com/powershell-delete-folder-or-file/

https://support.computerplan.nl/hc/nl/articles/115002481985-For-Admins-How-to-Delete-a-User-Profile-from-the-Registry
#>