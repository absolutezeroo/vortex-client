@echo off
setlocal

set "SWF=bin\Habbo.swf"

if not exist "%SWF%" (
    echo [Vortex] SWF not found: %SWF%
    echo [Vortex] Run build.bat first.
    pause
    exit /b 1
)

rem --- Locate Flash Player standalone projector ---
set "FLASH_EXE="

rem 1. Honour explicit env var
if defined FLASH_PLAYER_HOME (
    if exist "%FLASH_PLAYER_HOME%\flashplayer.exe"  set "FLASH_EXE=%FLASH_PLAYER_HOME%\flashplayer.exe"
    if exist "%FLASH_PLAYER_HOME%\FlashPlayer.exe"  set "FLASH_EXE=%FLASH_PLAYER_HOME%\FlashPlayer.exe"
)

rem 2. Same directory as this script
if not defined FLASH_EXE (
    if exist "%~dp0flashplayer.exe"  set "FLASH_EXE=%~dp0flashplayer.exe"
    if exist "%~dp0FlashPlayer.exe"  set "FLASH_EXE=%~dp0FlashPlayer.exe"
)

rem 3. Common install paths
if not defined FLASH_EXE (
    for %%P in (
        "C:\Tools\FlashPlayer\flashplayer_32_sa_debug.exe"
        "C:\Program Files (x86)\Adobe\Flash Player\flashplayer.exe"
        "C:\Program Files\Adobe\Flash Player\flashplayer.exe"
        "C:\Laragon\bin\flash\flashplayer.exe"
        "C:\Laragon\bin\flash\FlashPlayer.exe"
    ) do (
        if not defined FLASH_EXE (
            if exist %%P set "FLASH_EXE=%%~P"
        )
    )
)

if not defined FLASH_EXE (
    echo [Vortex] Flash Player standalone projector not found.
    echo [Vortex] Download flashplayer.exe from Harman ^(airsdk.harman.com^) and either:
    echo   - Place it next to run.bat, OR
    echo   - Set FLASH_PLAYER_HOME to its folder
    pause
    exit /b 1
)

echo [Vortex] Player : %FLASH_EXE%
echo [Vortex] SWF    : %SWF%
echo.

start "" "%FLASH_EXE%" "%~dp0%SWF%"
