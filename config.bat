@echo off
REM ============================================
REM  百度网盘同步配置
REM  修改后运行 setup_tasks.ps1 即可生效
REM ============================================

REM 百度网盘安装路径
set "BAIDU_PATH=%APPDATA%\baidu\BaiduNetdisk\BaiduNetdisk.exe"

REM 夜间同步开始时间 (启动百度网盘)
set "START_HOUR=0"
set "START_MIN=0"

REM 白天暂停开始时间 (关闭百度网盘)
set "STOP_HOUR=8"
set "STOP_MIN=0"
