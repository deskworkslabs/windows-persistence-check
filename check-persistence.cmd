@echo off
REM ============================================================
REM  Windows Persistence Quick-Check  (READ-ONLY)
REM  Dumps the registry + startup locations that malware and
REM  "managed by organization" policy junk most often hide in.
REM
REM  This script ONLY READS. It changes nothing on your machine.
REM  It writes a plain-text report you can read or share.
REM
REM  Usage:  right-click -> Run as administrator
REM  Output: persistence-report-YYYY-MM-DD.txt  (in this folder)
REM ============================================================

setlocal
set "REPORT=persistence-report-%date:~-4%-%date:~4,2%-%date:~7,2%.txt"
set "REPORT=%REPORT: =0%"

echo Windows Persistence Quick-Check (read-only)
echo Writing report to: %REPORT%
echo.

(
echo ============================================================
echo  WINDOWS PERSISTENCE QUICK-CHECK  (read-only)
echo  Generated: %date% %time%
echo ============================================================
echo.
echo This report lists the common auto-start and policy locations.
echo Nothing was changed. See README for how to read it.
echo.

echo ===== [1] STARTUP (Run keys) ===============================
echo --- HKCU\...\Run
reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" 2>nul
echo --- HKLM\...\Run
reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" 2>nul
echo --- HKLM\WOW6432Node\...\Run
reg query "HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Run" 2>nul
echo --- HKCU\...\RunOnce
reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce" 2>nul
echo --- HKLM\...\RunOnce
reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce" 2>nul
echo.

echo ===== [2] WINLOGON (Shell / Userinit hijack spot) ==========
echo Shell should be   : explorer.exe
echo Userinit should be: C:\Windows\system32\userinit.exe,
reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" 2>nul
echo.

echo ===== [3] IMAGE FILE EXECUTION OPTIONS =====================
echo RED FLAG = any "Debugger" value below. MitigationOptions,
echo CFGOptions, DisableExceptionChainValidation, MaxLoaderThreads
echo and UseFilter are normal Windows settings.
reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options" /s 2>nul
echo.

echo ===== [4] BROWSER POLICIES (the "managed by org" cause) =====
echo "unable to find" here is GOOD - it means no policy lock.
reg query "HKLM\Software\Policies\Google\Chrome" /s 2>nul
reg query "HKCU\Software\Policies\Google\Chrome" /s 2>nul
reg query "HKLM\Software\Policies\Microsoft\Edge" /s 2>nul
reg query "HKCU\Software\Policies\Microsoft\Edge" /s 2>nul
reg query "HKLM\Software\Policies\BraveSoftware" /s 2>nul
reg query "HKLM\Software\Policies\Chromium" /s 2>nul
echo.

echo ===== [5] STARTUP FOLDERS ==================================
echo --- Current user Startup
dir /b "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup" 2>nul
echo --- All users Startup
dir /b "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Startup" 2>nul
echo.

echo ===== [6] SCHEDULED TASKS (non-Microsoft) ==================
echo Review anything that points at AppData, Temp, or a random name.
schtasks /query /fo LIST 2>nul | findstr /i "TaskName" | findstr /v /i "\\Microsoft\\"
echo.

echo ===== END OF REPORT ========================================
) > "%REPORT%"

echo Done. Open %REPORT% to review.
echo Nothing on your machine was changed.
endlocal
