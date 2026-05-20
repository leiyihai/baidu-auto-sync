@echo off
setlocal enabledelayedexpansion

set "LOG_FILE=%~dp0sync.log"

echo [!date! !time!] Stopping BaiduNetdisk...>>"%LOG_FILE%"

REM Graceful shutdown first
taskkill /im BaiduNetdisk.exe /t 2>nul
timeout /t 3 /nobreak >nul

REM Force kill all related processes
taskkill /f /im BaiduNetdisk.exe /t 2>nul
taskkill /f /im baidunetdiskhost.exe /t 2>nul
taskkill /f /im BaiduNetdiskUnite.exe /t 2>nul

echo [!date! !time!] BaiduNetdisk stopped>>"%LOG_FILE%"
