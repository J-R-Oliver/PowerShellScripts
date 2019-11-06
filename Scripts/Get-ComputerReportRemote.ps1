Get-Random -Minimum 1 -Maximum 60 | Start-Sleep

$ReportPath = "\\ge-filesvr\share\IT\James\ComputerReportAD.csv"

Try { $computerReport = Import-Csv -Path $ReportPath }
Catch { Write-Warning "Unable to report because $($Error[0])"; Exit }

$ComputerDetails   = Get-WmiObject -Class:Win32_ComputerSystem                                               # .Manufacturer and .Model are attributes of the $ComputerDetails object
$SerialNumber      = (Get-WmiObject -Class:Win32_BIOS).SerialNumber                                          #Serial Number
$BIOS              = Get-WmiObject  -Class Win32_BIOS                                                        #Creates $BIOS object to manipulate with .methods
$BIOSReleaseDate   = $BIOS.ConvertToDateTime($BIOS.releasedate).ToShortDateString()                          #BIOS Release Date
$OperatingSystem   = Get-WmiObject -Class Win32_OperatingSystem                                              #Creates Operating System object
$OSInstallDate     = ($OperatingSystem.ConvertToDateTime($OperatingSystem.InstallDate).ToShortDateString())  #OS Install Date
$WindowsLicenseKey = (Get-WmiObject -query ‘select * from SoftwareLicensingService’).OA3xOriginalProductKey  #Windows License Number

$UpdatedReport = ForEach ( $Computer in $computerReport ) {
    If ( $Computer.ComputerName -eq [System.Net.Dns]::GetHostName() ) {
            $Computer.Manufacturer      = $ComputerDetails.Manufacturer
            $Computer.Model             = $ComputerDetails.Model
            $Computer.ServiceTag        = $SerialNumber
            $Computer.BIOSReleaseDate   = $BIOSReleaseDate
            $Computer.OSInstallDate     = $OSInstallDate
            $Computer.WindowsLicenseKey = $WindowsLicenseKey
        }
    $Computer
    }
    
$UpdatedReport | Export-CSV -Path $ReportPath -NoTypeInformation