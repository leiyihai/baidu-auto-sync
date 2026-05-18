@echo off
chcp 65001 >nul
echo [%date% %time%] 启动百度网盘...

set BAIDU_PATH=%APPDATA%\baidu\BaiduNetdisk\BaiduNetdisk.exe

if exist "%BAIDU_PATH%" (
    start "" "%BAIDU_PATH%"
    echo [%date% %time%] 百度网盘启动成功
) else (
    echo [%date% %time%] 错误: 找不到百度网盘程序
    exit /b 1
)
