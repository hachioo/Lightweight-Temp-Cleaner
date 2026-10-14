@echo off
:: Check and automatically request Administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting Administrator privileges...
    powershell -Command "Start-Process -FilePath '%~dpnx0' -Verb RunAs"
    exit /b
)

title Temp Folder Cleanup (Admin Mode)
echo Deleting junk files...

:: 1. Delete user %temp% files
del /f /s /q "%temp%\*" >nul 2>&1
for /d %%p in ("%temp%\*.*") do rmdir "%%p" /s /q >nul 2>&1

:: 2. Delete system C:\Windows\Temp files
del /f /s /q "%systemroot%\Temp\*" >nul 2>&1
for /d %%p in ("%systemroot%\Temp\*.*") do rmdir "%%p" /s /q >nul 2>&1

echo Cleanup complete!
timeout /t 3 >nul
exit