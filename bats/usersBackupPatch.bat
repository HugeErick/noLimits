@echo off
setlocal enabledelayedexpansion

:: Generate timestamp in format YYYYMMDD_HHMMSS
set "timeStamp=%date:~-4%%date:~3,2%%date:~0,2%_%time:~0,2%%time:~3,2%%time:~6,2%"
set "timeStamp=%timeStamp: =0%"

:: Define backup paths
set "backupRoot=Z:\backupUsers"
set "backupFolder=%backupRoot%\Backup_%timeStamp%"
set "sourceFolder=C:\Usuarios"

:: Check if Z: drive is available
if not exist "Z:\" (
    echo ERROR: Drive Z: is not available.
    exit /b 1
)

:: Ensure backup root directory exists
if not exist "%backupRoot%" mkdir "%backupRoot%"

:: Ensure backup folder exists
if not exist "%backupFolder%" mkdir "%backupFolder%"

:: Define log file path
set "logFile=%backupFolder%\backup_log.txt"

:: Log start time
echo Starting backup on %date% %time% > "%logFile%"

:: Run robocopy (fixing LOG+ issue)
robocopy "%sourceFolder%" "%backupFolder%" /E /Z /R:3 /W:10 /MT:8 /V /TEE /NP /LOG:"%logFile%"

:: Update latest backup symlink
if exist "%backupRoot%\Latest" rmdir "%backupRoot%\Latest"
mklink /D "%backupRoot%\Latest" "%backupFolder%"

:: Completion message
echo Backup completed! Check %logFile% for details.

:: Auto-close script after 180 seconds
start /b "" cmd /c timeout /t 180 ^& taskkill /fi "windowtitle eq Administrator:  %~nx0" /f

