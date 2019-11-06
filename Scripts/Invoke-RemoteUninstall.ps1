$AppName      = Read-Host -Prompt "Please enter application name"
$ComputerName = Read-Host -Prompt "Please enter computer name"

Invoke-Command `
-Credential joliver-admin `
-ComputerName $ComputerName `
-ScriptBlock {Get-CimInstance `
    -ClassName Win32_Product `
    -Filter "name like '%$AppName%'" |
     Invoke-CimMethod -MethodName Uninstall
    }



