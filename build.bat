@echo off
setlocal

if not defined AIR_SDK_HOME (
    if defined AIR_SDK set "AIR_SDK_HOME=%AIR_SDK%"
)

if not defined AIR_SDK_HOME (
    if exist "C:\Laragon\bin\air-sdk\AIRSDK_51.3.3\bin\amxmlc.bat" (
        set "AIR_SDK_HOME=C:\Laragon\bin\air-sdk\AIRSDK_51.3.3"
    )
)

if not defined AIR_SDK_HOME (
    echo [Vortex] AIR_SDK_HOME is not configured.
    echo [Vortex] Example:
    echo     set AIR_SDK_HOME=C:\Laragon\bin\air-sdk\AIRSDK_51.3.3
    pause
    exit /b 1
)

set "AMXMLC=%AIR_SDK_HOME%\bin\amxmlc.bat"
set "CONFIG=habbo-compile-config.xml"
set "OUTPUT=bin\Habbo.swf"

if not exist "%AMXMLC%" (
    echo [Vortex] Compiler not found:
    echo     %AMXMLC%
    pause
    exit /b 1
)

if not exist "%CONFIG%" (
    echo [Vortex] Config file not found:
    echo     %CONFIG%
    pause
    exit /b 1
)

if not exist "bin" mkdir "bin"

echo [Vortex] AIR SDK: %AIR_SDK_HOME%
echo [Vortex] Config: %CONFIG%
echo [Vortex] Output: %OUTPUT%
echo [Vortex] Compiling; amxmlc may be silent for 30-60s.
echo.

call "%AMXMLC%" -load-config+="%CONFIG%"

if errorlevel 1 (
    echo.
    echo [Vortex] FAILED - see errors above
    pause
    exit /b 1
)

echo.
echo [Vortex] OK - %OUTPUT%
