@echo off
REM ============================================
REM  BaiduNetdisk Sync Configuration
REM  Run setup_tasks.ps1 after editing
REM ============================================

REM BaiduNetdisk install path
set "BAIDU_PATH=%APPDATA%\baidu\BaiduNetdisk\BaiduNetdisk.exe"

REM Sync window start (launch BaiduNetdisk)
set "START_HOUR=11"
set "START_MIN=0"

REM Sync window stop (close BaiduNetdisk)
set "STOP_HOUR=11"
set "STOP_MIN=10"
