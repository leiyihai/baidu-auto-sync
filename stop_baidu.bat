@echo off
echo [%date% %time%] Stopping BaiduNetdisk...

REM Graceful shutdown first
taskkill /im BaiduNetdisk.exe /t 2>nul
timeout /t 3 /nobreak >nul

REM Force kill all related processes
taskkill /f /im BaiduNetdisk.exe /t 2>nul
taskkill /f /im baidunetdiskhost.exe /t 2>nul
taskkill /f /im BaiduNetdiskUnite.exe /t 2>nul

echo [%date% %time%] BaiduNetdisk stopped
