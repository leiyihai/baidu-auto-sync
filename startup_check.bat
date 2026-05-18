@echo off
chcp 65001 >nul
echo [%date% %time%] 开机检查同步状态...

REM 获取当前小时(去掉前导空格)
set HOUR=%time:~0,2%
if "%HOUR:~0,1%"==" " set HOUR=%HOUR:~1,1%

REM 0:00-7:59 → 启动百度网盘(夜间同步时段)
REM 8:00-23:59 → 关闭百度网盘(白天暂停时段)
if %HOUR% lss 8 (
    echo [%date% %time%] 夜间时段, 启动百度网盘同步...
    call "%~dp0start_baidu.bat"
) else (
    echo [%date% %time%] 白天时段, 关闭百度网盘同步...
    call "%~dp0stop_baidu.bat"
)
