<#
.SYNOPSIS
    Disables Server Manager auto start
.DESCRIPTION
    Prevents Server Manager from starting automatically at every logon.
.EXAMPLE
    .\Disable_Server_Manager.ps1
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

# Disable Server Manager on startup
#region
Write-PSFMessage -Level Important -Message "Disabling Server Manager on startup" -Tag Info
try {
    Get-ScheduledTask -TaskName ServerManager | Disable-ScheduledTask
    Write-PSFMessage -Level Important -Message "Successfully disabled Server Manager on startup" -Tag Success
} catch {
    Write-PSFMessage -Level Warning -Message "Unable to disable Server manager on startup" -Tag Failure -ErrorRecord $_
}
#endregion
