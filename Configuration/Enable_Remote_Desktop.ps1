<#
.SYNOPSIS
    Enables Remote Desktop
.DESCRIPTION
    Enables connectivity remotely via Remote Desktop (mstsc)
.EXAMPLE
    .\Enables_Remote_Desktop.ps1
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

# Enable Remote Desktop
#region
try {
    Write-PSFMessage -Level Important -Message "Enabling Remote Desktop" -Tag Info
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0 -ErrorAction Stop
    Write-PSFMessage -Level Important -Message "fsDenyTSConnections value has been set to 0" -Tag Success
    Enable-NetFirewallRule -DisplayGroup "Remote Desktop" -ErrorAction Stop
    Write-PSFMessage -Level Important -Message "Enabled firewall rule for Remote Desktop" -Tag Success
} catch {
    Write-PSFMessage -Level Important -Message "Failed to enable Remote Desktop" -Tag Info
}
#endregion
