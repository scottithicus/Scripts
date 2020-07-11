<#
.SYNOPSIS
    Changes timezone to Eastern Standard Time
.DESCRIPTION
    All Microsoft OS's install in Pacific Standard Time. This script changes the timezone to
    Eastern Standard Time.
.EXAMPLE
    .\Change_TimeZone_To_EST.ps1
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

# Configure timezone
#region
Write-PSFMessage -Level Important -Message "Setting timezone to Eastern Standard Time" -Tag Info
try {
    Set-TimeZone -Id "Eastern Standard Time"
    Start-Service W32Time
    Write-PSFMessage -Level Important -Message "Timezone has been set to Eastern Standard Time" -Tag Success
} catch {
    Write-PSFMessage -Level Warning -Message "Unable to set timezone to Eastern Standard Time" -Tag Failure -ErrorRecord $_
}
#endregion
