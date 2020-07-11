<#
.SYNOPSIS
    Changes CD drive letter to X:
.DESCRIPTION
    To eliminate the usage of D: for CD drives, this script moves the CD drive letter to X: via
    several PowerShell commands & CIM.
.EXAMPLE
    .\Change_CD_DriveLetter.ps1
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

# Change CD drive to X: (via PSSession)
#region
Write-PSFMessage -Level Important -Message "Attempting to set CD drive to X:" -Tag Info
try {
    $letter = Get-CimInstance -ClassName Win32_CDROMDrive | Select-Object -ExpandProperty Drive
    Set-CimInstance -InputObject (Get-CimInstance -ClassName Win32_Volume -Filter "DriveLetter = '$letter'") -Arguments @{DriveLetter='X:'}
    Write-PSFMessage -Level Important -Message "CD drive letter has been changed to X:" -Tag Success
} catch {
    Write-PSFMessage -Level Critical -Message "Unable to change CD drive letter to X:" -Tag Failure -ErrorRecord $_
    break
}
#endregion
