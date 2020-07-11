<#
.SYNOPSIS
    Changes power plan to high performance
.DESCRIPTION
    Modifies the local power plan for high performance.
.EXAMPLE
    .\Change_Power_Plan_To_High_Performance.ps1
.INPUTS
    Not applicable
.OUTPUTS
    Not applicable
.NOTES
    Created by: Scott Cielewich
    Last modified on: 2020-07-10
#>

# Set variables for PSFramework logging

$LogFile = "Configuration-PSFLogs.log"
$LogFilePath = "C:\Support\Logs"

###### DO NOT MODIFY ANYTHING BELOW THIS LINE ######


# Check if PSFramework Module is imported; install & import PSFramework module if not imported
#region
try {
    if (!(Get-Module -ListAvailable -Name PSFramework)) {
        Install-Module -Name PSFramework -Repository PSGallery -Force -ErrorAction Stop
    } else {
        Import-Module -Name PSFramework -ErrorAction Stop}
    } catch {
        Write-Error -Message "Unable to install or import PSFramework PowerShell Module"
        break
    }
#endregion

# Test for C:\Support\Logs existence. Create if not existing.
#region
if (!(Test-Path -LiteralPath $LogFilePath)) {
    try {
        New-Item -Path $LogFilePath -ItemType Directory -ErrorAction Stop
    } catch {
        Write-Error -Message "Unable to create '$LogFilePath' for log file"
    }
}
#endregion

# For PSFramework Module: enable logfile, set logfile location.
#region
Set-PSFLoggingProvider -Name logfile -Enabled $true
Set-PSFLoggingProvider -Name logfile -FilePath $LogFilePath\$LogFile
#endregion

# Set Power Plan to High Performance
#region
Write-PSFMessage -Level Important -Message "Setting power plan to high performance and disabling monitor timeout" -Tag Info
try {
        Start-Process -FilePath C:\Windows\System32\powercfg.exe -ArgumentList "-s 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c" -ErrorAction Stop
        Start-Process -FilePath C:\Windows\System32\powercfg.exe -ArgumentList "-change -monitor-timeout-ac 0" -ErrorAction Stop
        Start-Process -FilePath C:\Windows\System32\powercfg.exe -ArgumentList "-change -standby-timeout-ac 0" -ErrorAction Stop
        Start-Process -FilePath C:\Windows\System32\powercfg.exe -ArgumentList "-change -hibernate-timeout-ac 0" -ErrorAction Stop
        Write-PSFMessage -Level Important -Message "Power plan successfully set to high performance & inserted monitor timeout settings" -Tag Success
} catch {
    Write-PSFMessage -Level Warning -Message "Unable to set high performance power plan & monitor timeout settings" -Tag Failure
}
#endregion
