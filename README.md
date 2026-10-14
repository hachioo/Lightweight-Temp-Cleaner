# Windows Auto Temp Cleaner

A lightweight, native Windows Batch utility that automatically cleans up temporary junk files from both user (`%temp%`) and system (`C:\Windows\Temp`) directories. Designed to run silently at system startup with Administrator privileges—without triggering repetitive User Account Control (UAC) prompts.

---

## Features

- **Zero Dependencies:** Written in pure Windows Batch (`.bat`)—no external runtimes or third-party installations required.
- **Built-in Admin Self-Elevation:** Automatically requests Administrator privileges via PowerShell if launched manually without elevated rights.
- **Dual-Directory Cleanup:** Purges both the current user's temporary folder (`%temp%`) and the Windows system temporary folder (`%systemroot%\Temp`).
- **Safe Execution:** Automatically skips locked files and directories currently in use by the operating system or active background applications (`>nul 2>&1`).
- **Silent Automation Ready:** Easily integrates with Windows Task Scheduler to run automatically at login, even on battery power, bypassing UAC prompts.

---

## Script Source (`CleanTemp.bat`)

Create a new file named `CleanTemp.bat` and paste the following code:

```batch
@echo off
:: Check for Administrator privileges and self-elevate if needed
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting Administrator privileges...
    powershell -Command "Start-Process -FilePath '%~dpnx0' -Verb RunAs"
    exit /b
)

title Temp Directory Cleaner (Admin Mode)
echo Cleaning temporary junk files...

:: 1. Clean current user's %temp% directory
del /f /s /q "%temp%\*" >nul 2>&1
for /d %%p in ("%temp%\*.*") do rmdir "%%p" /s /q >nul 2>&1

:: 2. Clean system C:\Windows\Temp directory
del /f /s /q "%systemroot%\Temp\*" >nul 2>&1
for /d %%p in ("%systemroot%\Temp\*.*") do rmdir "%%p" /s /q >nul 2>&1

echo Cleanup complete!
timeout /t 3 >nul
exit