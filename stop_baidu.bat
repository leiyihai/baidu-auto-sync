@echo off
chcp 65001 >nul
echo [%date% %time%] 关闭百度网盘...

REM 先正常关闭主窗口
taskkill /im BaiduNetdisk.exe /t 2>nul
timeout /t 3 /nobreak >nul

REM 强制终止所有相关进程
taskkill /f /im BaiduNetdisk.exe /t 2>nul
taskkill /f /im baidunetdiskhost.exe /t 2>nul
taskkill /f /im BaiduNetdiskUnite.exe /t 2>nul

echo [%date% %time%] 百度网盘已关闭
