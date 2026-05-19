@echo off
call "%~dp0config.bat"

echo [%date% %time%] Starting BaiduNetdisk...

if exist "%BAIDU_PATH%" (
    start "" "%BAIDU_PATH%"
    echo [%date% %time%] BaiduNetdisk started successfully
) else (
    echo [%date% %time%] ERROR: BaiduNetdisk not found (%BAIDU_PATH%)
    exit /b 1
)
