@echo off
setlocal enabledelayedexpansion

:: Set the date format for the backup folder
set "datestamp=%date:~-4%%date:~3,2%%date:~0,2%_%time:~0,2%%time:~3,2%%time:~6,2%"
set "datestamp=%datestamp: =0%"

:: Set backup location to C:\Users\erick
set "BACKUP_PATH=C:\Users\erick"
set "BACKUP_FOLDER=%BACKUP_PATH%\GoogleDriveBackup_%datestamp%"

:: Check if drive G: exists before proceeding
if not exist G:\ (
    echo Drive G: not found. Backup cannot proceed.
    pause
    exit /b 1
)

:: Create backup directory
if not exist "%BACKUP_FOLDER%" (
    mkdir "%BACKUP_FOLDER%"
)

:: Log file
set "LOGFILE=%BACKUP_FOLDER%\backup_log.txt"
echo Starting backup on %date% %time% > "%LOGFILE%"

echo Backing up drive G: to %BACKUP_FOLDER%\GoogleDrive >> "%LOGFILE%"
mkdir "%BACKUP_FOLDER%\GoogleDrive"

:: Using robocopy for reliable file copying
robocopy "G:" "%BACKUP_FOLDER%\GoogleDrive" /E /Z /R:3 /W:10 /MT:8 /LOG+:"%LOGFILE%"

echo Finished backing up G: at %time% >> "%LOGFILE%"
echo Backup completed at %time% >> "%LOGFILE%"

:: Optional: Create a "latest" symbolic link
if exist "%BACKUP_PATH%\Latest_Backup" rmdir "%BACKUP_PATH%\Latest_Backup"
mklink /D "%BACKUP_PATH%\Latest_Backup" "%BACKUP_FOLDER%"

echo Backup process completed! Check %LOGFILE% for details.
pause
