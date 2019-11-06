try { Import-Module ActiveDirectory -ErrorAction Stop }
catch { Write-Warning "Unable to load Active Directory module because $($Error[0])"; Exit }

Write-Verbose "Getting Workstations..." -Verbose
$Computers = get-adcomputer -filter {Name -like "*GE-LT*"-or Name -like "*GE-DT*"} -Properties LastLogonDate,OperatingSystem,OperatingSystemVersion
$Count = 1
$Results = foreach ($Computer in $Computers) {
    Write-Progress -Id 0 -Activity "Searching for Computer information" -Status "$Count of $($Computers.Count)" -PercentComplete (($Count / $Computers.Count) * 100)
    New-Object PSObject -Property @{
        ComputerName = $Computer.Name
        UserName = Get-ADUser -filter " Description -Like '*$($Computer.name)*'" -Properties description | Select-Object name | Sort-Object whenCreated -Descending | Select-Object -First 1 | Select-Object -ExpandProperty name
        LastLogon = $Computer.LastLogonDate
        ComputerOS = $Computer.OperatingSystem
        OSVersion = $Computer.OperatingSystemVersion
    }
    $Count ++
}
Write-Progress -Id 0 -Activity " " -Status " " -Completed

Write-Verbose "Building the report..." -Verbose

$ReportPath = Join-Path -Path "$home\Desktop\" -ChildPath "ComputerReportAD.csv" 
$Results | Select-Object ComputerName,UserName,LastLogon,ComputerOS,OSVersion,Manufacturer,Model,ServiceTag,BIOSReleaseDate,OSInstallDate,WindowsLicenseKey | Sort-Object ComputerName | Export-Csv $ReportPath -NoTypeInformation 

Write-Verbose "Report saved at: $ReportPath" -Verbose