@echo off

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%~dp0"
:--------------------------------------

:: -----------------------------------------------------------------
:: The actual script starts here, running with admin privileges.
:: -----------------------------------------------------------------
ECHO =======================================================
ECHO Running the PowerShell setup script with Admin rights...
ECHO This will bypass the execution policy.
ECHO =======================================================
ECHO.

powershell.exe -ExecutionPolicy Bypass -File "ultimate_setup.ps1"

ECHO.
ECHO =======================================================
ECHO The script has finished. Press any key to exit.
ECHO =======================================================
pause > nul
