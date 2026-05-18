@echo off
chcp 65001 >nul
call "%~dp0config.bat"

echo [%date% %time%] 启动百度网盘...

if exist "%BAIDU_PATH%" (
    start "" "%BAIDU_PATH%"
    echo [%date% %time%] 百度网盘启动成功
) else (
    echo [%date% %time%] 错误: 找不到百度网盘程序 (%BAIDU_PATH%)
    exit /b 1
)
