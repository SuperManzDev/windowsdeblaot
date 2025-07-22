# Ultimate Windows Setup & Debloat Script

This repository contains a powerful PowerShell script (`ultimate_setup.ps1`) and a batch file (`run_setup.bat`) to automate the process of setting up and debloating a new Windows installation.

## ⚠️ Critical Warning

This script makes significant and permanent changes to your system. **BACK UP ALL IMPORTANT DATA** before proceeding. Run at your own risk. You must run this as an Administrator.

## What it Does

The `ultimate_setup.ps1` script is a comprehensive tool that performs the following actions:

*   **Installs Essential Software:** It uses the Chocolatey package manager to install a wide range of popular and useful applications.
*   **Personalizes the User Interface:** It sets the system and app theme to dark mode, applies a black background, and makes the taskbar small.
*   **Disables Startup Programs:** It disables auto-start for several common applications to improve boot times.
*   **Performs System Debloat:** It attempts to remove Microsoft Edge and runs a community debloater script to remove other pre-installed Windows apps.
*   **Manages System Updates:** It installs all available Windows updates to ensure your system is up-to-date.

## What it Installs

The script installs the following software:

*   **Chocolatey:** A package manager for Windows.
*   **Essential Software:** Python, OpenJDK, Git, ADB, Brave, VSCode, Notepad++, Discord, 7-Zip.
*   **Creative & Office Tools:** GIMP, LibreOffice-Fresh, VLC, HandBrake.
*   **Gaming & Utility Software:** Parsec, Steam, Epic Games Launcher, Rufus, BalenaEtcher, CPU-Z, GPU-Z, LocalSend, MSI Afterburner, Revo Uninstaller.
*   **Manual Installations:** 3uTools, UltimMC Minecraft Launcher.
*   **System Tools:** ExplorerPatcher (for Windows 11), PSWindowsUpdate module.

## What it Changes

The script makes the following changes to your system:

*   **User Interface:** Sets the system and app theme to dark mode, applies a black background, and makes the taskbar small.
*   **Startup Programs:** Disables auto-start for Steam, Epic Games Launcher, Parsec, MSI Afterburner, and Discord.
*   **System Debloat:** Attempts to remove Microsoft Edge and runs a community debloater script to remove other pre-installed Windows apps.
*   **Execution Policy:** Temporarily bypasses the execution policy to run the script.
*   **Windows Updates:** Installs all available Windows updates.

## What it Improves

This script can improve your system in the following ways:

*   **Automation:** Automates the tedious process of setting up a new Windows installation.
*   **Consistency:** Ensures that the same set of software and settings are applied every time.
*   **Performance:** By removing bloatware and disabling unnecessary startup programs, it can potentially improve system performance and free up disk space.
*   **Convenience:** Installs a large suite of popular and useful applications without requiring manual downloads and installations.

## How to Use

1.  Download the `run_setup.bat` and `ultimate_setup.ps1` files to the same directory.
2.  Right-click on `run_setup.bat` and select "Run as administrator".
3.  Follow the on-screen prompts.

## Code Signing

The `ultimate_setup.ps1` script is signed with a self-signed certificate to help prevent it from being blocked by execution policies. The `run_setup.bat` file will automatically handle the execution policy.
