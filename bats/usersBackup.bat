@echo off
setlocal enabledelayedexpansion

set "timeStamp=%date:~-4%%date:~3,2%%date:~0,2%_%time:~0,2%%time:~3,2%%time:~6,2%"
set "timeStamp=%timeStamp: =0%"

set "backupRoot=Z:\backupUsers"
set "backupFolder=%backupRoot%\Backup_%timeStamp%"
set "sourceFolder=C:\Usuarios"

if not exist "%backupRoot%" mkdir "%backupRoot%"
if not exist "%backupFolder%" mkdir "%backupFolder%"

set "logFile=%backupFolder%\backup_log.txt"
echo Starting backup on %date% %time% > "%logFile%"

robocopy "%sourceFolder%" "%backupFolder%" /E /Z /R:3 /W:10 /MT:8 /V /TEE /NP /LOG+:"%logFile%"

if exist "%backupRoot%\Latest" rmdir "%backupRoot%\Latest"
mklink /D "%backupRoot%\Latest" "%backupFolder%"

echo Backup completed! Check %logFile% for details.

start /b "" cmd /c timeout /t 300 ^& taskkill /fi "windowtitle eq Administrator:  %~nx0" /f
