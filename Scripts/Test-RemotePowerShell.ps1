<# Test remote computer remote powershell enable 

Command to enable remote powershell. Run powershell as administrator and enter following command:

Enable-PSRemoting -Force

#>

$TargetMachine = Read-Host -Prompt 'Input target computer'

Test-WSMan -ComputerName $TargetMachine
