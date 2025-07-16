# ===================================================================================
#
#                    Ultimate Windows Setup & Debloat Script
#
#        ⚠️ CRITICAL WARNING: This script makes significant and permanent
#        changes to your system. BACK UP ALL IMPORTANT DATA before proceeding.
#        Run at your own risk. You must run this as an Administrator.
#
# ===================================================================================

# Step 1: Administrator Check
Write-Host "--- Checking for Administrator privileges..." -ForegroundColor Yellow
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "This script must be run as an Administrator. Please right-click the file and select 'Run with PowerShell'."
    Read-Host "Press Enter to exit..."
    exit
}
Write-Host "--- Administrator privileges confirmed." -ForegroundColor Green


# Step 2: System Personalization
Write-Host "--- Applying UI customizations..." -ForegroundColor Yellow
try {
    # Set Dark Mode for Apps & System
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'AppsUseLightTheme' -Value 0 -ErrorAction Stop
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'SystemUsesLightTheme' -Value 0 -ErrorAction Stop
    # Set Black Background
    Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'Wallpaper' -Value ''
    # Set Small Taskbar (0=Small, 1=Medium, 2=Large)
    Set-ItemProperty -Path 'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'TaskbarSi' -Value 0
    # Force the system to update UI settings
    RUNDLL32.EXE user32.dll, UpdatePerUserSystemParameters 1, True
    Write-Host "--- Personalization settings applied." -ForegroundColor Green
} catch {
    Write-Warning "--- Could not apply all personalization settings."
}


# Step 3: Install Chocolatey
Write-Host "--- Checking/Installing Chocolatey..." -ForegroundColor Yellow
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Set-ExecutionPolicy Bypass -Scope Process -Force;
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}
Write-Host "--- Chocolatey is ready." -ForegroundColor Green


# Step 4: Install ALL Software via Chocolatey
Write-Host "--- Installing a large list of software. THIS WILL TAKE A LONG TIME..." -ForegroundColor Yellow
$packages = @(
    "python", "openjdk", "git", "adb", "brave", "vscode", "notepadplusplus",
    "gimp", "libreoffice-fresh", "vlc", "handbrake", "parsec", "steam", "epicgameslauncher",
    "rufus", "balenaetcher", "cpu-z", "gpu-z", "localsend", "msi-afterburner", "revo-uninstaller"
)
foreach ($pkg in $packages) {
    Write-Host "Installing $pkg..." -ForegroundColor Cyan
    choco install $pkg -y --force
}
Write-Host "--- All software has been installed." -ForegroundColor Green


# Step 5: Disable Startup Programs
Write-Host "--- Disabling startup for common applications..." -ForegroundColor Yellow
$runPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
$startupApps = @("Steam", "com.epicgames.launcher", "Parsec", "MSIAfterburner")
foreach ($appName in $startupApps) {
    if (Test-Path "$runPath\$appName") {
        Remove-ItemProperty -Path $runPath -Name $appName -Force -ErrorAction SilentlyContinue
        Write-Host "--- Disabled '$appName' auto-start."
    }
}


# Step 6: Manual & OS-Specific Installations
Write-Host "--- Starting manual & OS-specific installations..." -ForegroundColor Yellow
$desktopPath = [System.Environment]::GetFolderPath('Desktop')
$tempPath = $env:TEMP

# Install 3uTools (using new URL)
try {
    Write-Host "Downloading and installing 3uTools..."
    $3uToolsUrl = "https://url2.3u.com/MNBBfyaa"
    $3uInstaller = Join-Path $tempPath "3uTools_Setup.exe"
    Invoke-WebRequest -Uri $3uToolsUrl -OutFile $3uInstaller
    Start-Process $3uInstaller -ArgumentList "/S" -Wait
    Write-Host "--- 3uTools installed successfully." -ForegroundColor Green
} catch {
    Write-Warning "--- Failed to install 3uTools."
}

# Install Minecraft Launcher
# (This is unchanged from the previous version)
try {
    Write-Host "Downloading and setting up UltimMC Minecraft Launcher..."
    $minecraftFolder = Join-Path $desktopPath "Minecraft"
    $zipUrl = "https://github.com/UltimMC/Launcher/archive/refs/heads/develop.zip"
    $zipFile = Join-Path $tempPath "minecraft_launcher.zip"
    New-Item -Path $minecraftFolder -ItemType Directory -Force | Out-Null
    Invoke-WebRequest -Uri $zipUrl -OutFile $zipFile
    Expand-Archive -Path $zipFile -DestinationPath $minecraftFolder -Force
    Write-Host "--- Minecraft Launcher downloaded to Desktop/Minecraft." -ForegroundColor Green
} catch {
    Write-Warning "--- Failed to download the Minecraft Launcher."
}

# Install ExplorerPatcher on Windows 11
$isWindows11 = (Get-CimInstance Win32_OperatingSystem).Caption -like "*Windows 11*"
if ($isWindows11) {
    Write-Host "--- Windows 11 detected. Installing ExplorerPatcher..." -ForegroundColor Yellow
    try {
        $epUrl = "https://github.com/valinet/ExplorerPatcher/releases/download/22631.5335.68.2_14807a5/ep_setup.exe"
        $epInstaller = Join-Path $tempPath "ep_setup.exe"
        Invoke-WebRequest -Uri $epUrl -OutFile $epInstaller
        Start-Process $epInstaller -Wait
        Write-Host "--- ExplorerPatcher installed. Your taskbar may have restarted." -ForegroundColor Green
    } catch {
        Write-Warning "--- Failed to install ExplorerPatcher."
    }
}


# Step 7: Aggressive System Debloat
Write-Host "--- Beginning AGGRESSIVE system debloat..." -ForegroundColor Yellow

# Uninstall Microsoft Edge
Write-Host "--- ATTEMPTING TO UNINSTALL MICROSOFT EDGE ---" -ForegroundColor Red
Write-Host "This is experimental and may fail or cause issues with Windows Update." -ForegroundColor Red
Read-Host "Press Enter to continue with Edge removal, or CTRL+C to cancel."
try {
    $edgePath = "C:\Program Files (x86)\Microsoft\Edge\Application\*\Installer"
    $edgeInstaller = Get-ChildItem -Path $edgePath -Recurse -Filter "setup.exe" | Select-Object -First 1
    if ($edgeInstaller) {
        & $edgeInstaller.FullName --uninstall --system-level --verbose-logging --force-uninstall
        Write-Host "--- Edge uninstaller has been executed." -ForegroundColor Green
    } else {
        Write-Warning "--- Microsoft Edge installer not found."
    }
} catch {
    Write-Warning "--- An error occurred during Edge removal."
}

# Run Community Debloater Script
Write-Host "--- Preparing to run the community debloater script..." -ForegroundColor Red
Read-Host "This is the final major removal step. Press Enter to continue, or CTRL+C to cancel."
try {
    $debloaterUrl = "https://raw.githubusercontent.com/Sycnex/Windows10Debloater/master/Windows10Debloater.ps1"
    $debloaterScriptPath = Join-Path $tempPath "Windows10Debloater.ps1"
    Invoke-WebRequest -Uri $debloaterUrl -OutFile $debloaterScriptPath
    & $debloaterScriptPath -Debloat -Silent
    Write-Host "--- Debloater script has finished." -ForegroundColor Green
} catch {
    Write-Warning "--- Could not download or run the debloater script."
}


# Step 8: Install System & Driver Updates
Write-Host "--- Checking for and installing Windows Updates. This can take a VERY long time." -ForegroundColor Yellow
Read-Host "Press Enter to begin."
try {
    Install-Module -Name PSWindowsUpdate -Force -AcceptLicense -Confirm:$false
    Import-Module PSWindowsUpdate -Force
    Get-WindowsUpdate -Install -AcceptAll -AutoReboot
    Write-Host "--- System is up to date. A reboot might be required." -ForegroundColor Green
} catch {
    Write-Warning "--- Failed to run the Windows Update process."
}


# Final Step: Important Reminder
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host "        SETUP COMPLETE! 🎉" -ForegroundColor Cyan
Write-Host " "
Write-Host "ACTION REQUIRED: You must set your default apps manually!" -ForegroundColor Yellow
Write-Host "Go to: Settings > Apps > Default apps to set Brave, VLC, etc." -ForegroundColor Yellow
Write-Host " "
Write-Host "A system reboot is highly recommended to apply all changes." -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan
Read-Host "Press Enter to exit."
