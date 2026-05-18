@echo off
chcp 65001 >nul
call "%~dp0config.bat"

echo [%date% %time%] 开机检查同步状态 (同步窗口: %START_HOUR%:00 - %STOP_HOUR%:00) ...

REM 获取当前小时 (去掉前导空格)
set NOW=%time:~0,2%
if "%NOW:~0,1%"==" " set NOW=%NOW:~1,1%

REM 判断当前是否在同步时段内
REM 如果 START < STOP: 在 [START, STOP) 内启动, 否则关闭
REM 如果 START > STOP: 在 [START, 24) 或 [0, STOP) 内启动
set "START_SYNC=0"
if %START_HOUR% lss %STOP_HOUR% (
    if %NOW% geq %START_HOUR% if %NOW% lss %STOP_HOUR% set "START_SYNC=1"
) else (
    if %NOW% geq %START_HOUR% set "START_SYNC=1"
    if %NOW% lss %STOP_HOUR% set "START_SYNC=1"
)

if "%START_SYNC%"=="1" (
    echo [%date% %time%] 同步时段内, 启动百度网盘同步...
    call "%~dp0start_baidu.bat"
) else (
    echo [%date% %time%] 暂停时段内, 关闭百度网盘同步...
    call "%~dp0stop_baidu.bat"
)
