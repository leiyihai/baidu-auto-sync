@echo off
setlocal enabledelayedexpansion
call "%~dp0config.bat"

set "LOG_FILE=%~dp0sync.log"

echo [!date! !time!] Starting BaiduNetdisk...>>"%LOG_FILE%"

if exist "%BAIDU_PATH%" (
    start "" "%BAIDU_PATH%"
    echo [!date! !time!] BaiduNetdisk started successfully>>"%LOG_FILE%"
    exit /b 0
) else (
    echo [!date! !time!] ERROR: BaiduNetdisk not found (%BAIDU_PATH%)>>"%LOG_FILE%"
    exit /b 1
)
