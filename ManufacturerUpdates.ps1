#This script needs both Chrome installed and internet access for it to work
#If DCU/HPIA is not installed, this script will install it before silently applying updates
#This script will need to be run as admin or system for it to work correctly, with one UAC prompt if install is required

#DCU/HPIA installer URLs, test these first if the script breaks as they frequently change
$dellUrl = "https://dl.dell.com/FOLDER15013620M/1/Dell-Command-Update-Windows-Universal-Application_M9H5F_WIN64_5.7.2_A00.EXE"
$hpUrl = "https://hpia.hpcloud.hp.com/downloads/hpia/hp-hpia-5.3.4.exe"

#Dell Command Update
$DCU = "$env:SYSTEMDRIVE\Program Files\Dell\CommandUpdate\dcu-cli.exe"
#HP ImageAssistant
$HPIA = "$env:SYSTEMDRIVE\SWSetup\HPIA\HPImageAssistant.exe"
#Installer checks
$dell = Test-Path $DCU
$hp = Test-Path $HPIA
#Manufacturer Detection
$manufacturer = (Get-CimInstance -ClassName Win32_ComputerSystem).Manufacturer

#Installer check for Dell
if (-not $dell -and $manufacturer -like "*Dell*") {

    $dellInstaller = "$env:TEMP\DellCommandUpdate.exe"

    Invoke-WebRequest -Uri $dellUrl -UserAgent ([Microsoft.PowerShell.Commands.PSUserAgent]::Chrome) -OutFile $dellInstaller -UseBasicParsing
    Start-Process -FilePath $dellInstaller -ArgumentList "/s" -Wait
    Set-Service -Name "DellClientManagementService" -StartupType Manual
    Start-Process $DCU -ArgumentList "/scan -silent" -Wait -NoNewWindow
    Start-Process $DCU -ArgumentList "/applyupdates -silent -reboot=disable -forceUpdate=enable" -Wait -NoNewWindow
}

#Installer check for HP
elseif (-not $hp -and $manufacturer -like "*HP*") {

    $hpInstaller = "$env:TEMP\HPImageAssistant.exe"
    
    Invoke-WebRequest -Uri $hpUrl -OutFile $hpInstaller -UseBasicParsing
    Start-Process -FilePath $hpInstaller -ArgumentList "/s /e /f c:\SWSetup\HPIA" -Wait -NoNewWindow
    Start-Process $HPIA -ArgumentList "/Operation:Analyze /Category:All /Selection:All /Action:Install /Silent /Noninteractive" -Wait -NoNewWindow
}

#Runs DCU if installed
if ($dell) {

    if (Test-Path $DCU) {

	Set-Service -Name "DellClientManagementService" -StartupType Manual
        Start-Process $DCU -ArgumentList "/scan -silent" -Wait -NoNewWindow
        Start-Process $DCU -ArgumentList "/applyupdates -silent -reboot=disable -forceUpdate=enable" -Wait -NoNewWindow
    }
}

#Runs HPIA if installed
elseif ($hp) {

    if ($hp) {
        Start-Process $HPIA -ArgumentList "/Operation:Analyze /Category:All /Selection:All /Action:Install /Silent /Noninteractive" -Wait -NoNewWindow
    }
}
