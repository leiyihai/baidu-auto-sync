# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This project manages the auto-start/stop of BaiduNetdisk (百度网盘) via Windows Task Scheduler for nightly file sync. The sync window runs from 0:00 to 8:00 daily.

## Project structure

| File | Role |
|------|------|
| `config.bat` | Configuration — sync window times and netdisk path |
| `start_baidu.bat` | Launches BaiduNetdisk.exe |
| `stop_baidu.bat` | Kills all BaiduNetdisk processes |
| `startup_check.bat` | Runs at logon, decides whether to start or stop based on current time |
| `setup_tasks.ps1` | Creates/updates the three Windows scheduled tasks |
| `sync.log` | Auto-generated log file recording all start/stop events |

## Scheduled tasks created

- `BaiduSyncStart` — Daily at `START_HOUR:START_MIN`, runs `start_baidu.bat`
- `BaiduSyncStop` — Daily at `STOP_HOUR:STOP_MIN`, runs `stop_baidu.bat`
- `BaiduSyncStartup` — At system logon, runs `startup_check.bat`

## Common commands

```powershell
# Install or update scheduled tasks after editing config.bat
powershell -File "E:\baidu-auto-sync\setup_tasks.ps1"

# Check scheduled task status
Get-ScheduledTask -TaskName BaiduSyncStart, BaiduSyncStop, BaiduSyncStartup | Format-Table TaskName, State
Get-ScheduledTaskInfo -TaskName BaiduSyncStart

# Manually start/stop
cmd /c "E:\baidu-auto-sync\start_baidu.bat"
cmd /c "E:\baidu-auto-sync\stop_baidu.bat"

# Uninstall all tasks
Get-ScheduledTask -TaskName BaiduSync* | Unregister-ScheduledTask -Confirm:$false

# Check if BaiduNetdisk is running
Get-Process -Name BaiduNetdisk -ErrorAction SilentlyContinue

# View sync log
Get-Content "E:\baidu-auto-sync\sync.log"
```

## Critical constraints

- **All `.bat` files MUST be ASCII-only** — no Chinese or other non-ASCII characters. Chinese Windows' cmd.exe parses batch files in the system ANSI codepage (GBK/936), so UTF-8 Chinese characters get misinterpreted as broken commands. `chcp 65001` does not fix the parsing stage.
- After editing `config.bat`, always re-run `setup_tasks.ps1` to update the scheduled tasks.
- `config.bat` uses `%APPDATA%` expansion — verify it resolves in the task scheduler's user context.
- The `start_baidu.bat` exits 0 on success, 1 if BaiduNetdisk.exe is not found at the configured path.
