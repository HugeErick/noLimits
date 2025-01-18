@echo off
setlocal enabledelayedexpansion

:: Set the date format for the backup folder
set "datestamp=%date:~-4%%date:~3,2%%date:~0,2%_%time:~0,2%%time:~3,2%%time:~6,2%"
set "datestamp=%datestamp: =0%"

:: Set your external drive path - MODIFY THIS
set "BACKUP_DRIVE=E:"
set "BACKUP_FOLDER=%BACKUP_DRIVE%\GoogleDriveBackup_%datestamp%"

:: Create backup directory
mkdir "%BACKUP_FOLDER%"

:: Log file
set "LOGFILE=%BACKUP_FOLDER%\backup_log.txt"

echo Starting backup on %date% %time% > "%LOGFILE%"

:: List of Google Drive letters to backup - MODIFY THESE based on your mounted drives
set "DRIVE_LETTERS=G: H: I: J:"

for %%d in (%DRIVE_LETTERS%) do (
    if exist %%d (
        echo Backing up drive %%d to %BACKUP_FOLDER%\%%~nd >> "%LOGFILE%"
        mkdir "%BACKUP_FOLDER%\%%~nd"
        
        :: Using robocopy for reliable file copying
        robocopy "%%d" "%BACKUP_FOLDER%\%%~nd" /E /Z /R:3 /W:10 /MT:8 /LOG+:"%LOGFILE%" /TEE
        
        echo Finished backing up %%d at %time% >> "%LOGFILE%"
    ) else (
        echo Drive %%d not found, skipping... >> "%LOGFILE%"
    )
)

echo Backup completed at %time% >> "%LOGFILE%"

:: Optional: Create a "latest" symbolic link
if exist "%BACKUP_DRIVE%\Latest_Backup" rmdir "%BACKUP_DRIVE%\Latest_Backup"
mklink /D "%BACKUP_DRIVE%\Latest_Backup" "%BACKUP_FOLDER%"

echo Backup process completed! Check %LOGFILE% for details.
pause
