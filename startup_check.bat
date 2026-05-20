@echo off
setlocal enabledelayedexpansion
call "%~dp0config.bat"

set "LOG_FILE=%~dp0sync.log"

echo [!date! !time!] Startup check (sync window: %START_HOUR%:00 - %STOP_HOUR%:00) ...>>"%LOG_FILE%"

REM Get current hour (strip leading space)
set NOW=%time:~0,2%
if "%NOW:~0,1%"==" " set NOW=%NOW:~1,1%

REM Check if currently within sync window
REM If START < STOP: start if in [START, STOP), otherwise stop
REM If START > STOP: start if in [START, 24) or [0, STOP)
set "START_SYNC=0"
if %START_HOUR% lss %STOP_HOUR% (
    if %NOW% geq %START_HOUR% if %NOW% lss %STOP_HOUR% set "START_SYNC=1"
) else (
    if %NOW% geq %START_HOUR% set "START_SYNC=1"
    if %NOW% lss %STOP_HOUR% set "START_SYNC=1"
)

if "%START_SYNC%"=="1" (
    echo [!date! !time!] Within sync window, starting BaiduNetdisk...>>"%LOG_FILE%"
    call "%~dp0start_baidu.bat"
) else (
    echo [!date! !time!] Outside sync window, stopping BaiduNetdisk...>>"%LOG_FILE%"
    call "%~dp0stop_baidu.bat"
)
