<#
.SYNOPSIS
    根据 config.bat 配置创建/更新百度网盘同步计划任务
#>
$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  百度网盘同步计划任务配置" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 读取 config.bat
$configFile = Join-Path $scriptDir "config.bat"
if (-not (Test-Path $configFile)) {
    Write-Host "错误: 找不到 $configFile" -ForegroundColor Red
    exit 1
}

$config = @{}
Get-Content $configFile -Encoding UTF8 | ForEach-Object {
    $line = $_.Trim()
    # 格式: set "KEY=VALUE"
    if ($line -match '^set\s+"([^=]+)=(.+)"\s*$') {
        $config[$Matches[1]] = $Matches[2]
    }
}

$startHour = [int]$config["START_HOUR"]
$startMin  = [int]$config["START_MIN"]
$stopHour  = [int]$config["STOP_HOUR"]
$stopMin   = [int]$config["STOP_MIN"]

Write-Host "当前配置:" -ForegroundColor Yellow
Write-Host "  同步窗口: ${startHour}:$('{0:D2}' -f $startMin) - ${stopHour}:$('{0:D2}' -f $stopMin)" -ForegroundColor White
Write-Host "  网盘路径: $($config['BAIDU_PATH'])" -ForegroundColor White
Write-Host ""

$startTime = "{0:D2}:{1:D2}" -f $startHour, $startMin
$stopTime  = "{0:D2}:{1:D2}" -f $stopHour, $stopMin

$settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable `
    -MultipleInstances IgnoreNew

# 辅助函数
function New-BaiduTask {
    param($Name, $Desc, $BatchFile, $Time)

    # 删除旧任务
    $existing = Get-ScheduledTask -TaskName $Name -ErrorAction SilentlyContinue
    if ($existing) {
        Unregister-ScheduledTask -TaskName $Name -Confirm:$false
        Write-Host "  [删除旧任务] $Name" -ForegroundColor Yellow
    }

    $action = New-ScheduledTaskAction `
        -Execute "cmd.exe" `
        -Argument "/c `"$scriptDir\$BatchFile`""

    if ($Time) {
        $trigger = New-ScheduledTaskTrigger -Daily -At $Time
    } else {
        $trigger = New-ScheduledTaskTrigger -AtLogon
    }

    Register-ScheduledTask `
        -TaskName $Name `
        -Action $action `
        -Trigger $trigger `
        -Settings $settings `
        -Description $Desc `
        -Force | Out-Null

    Write-Host "  [创建成功] $Name" -ForegroundColor Green
}

# 创建任务
Write-Host "正在创建计划任务..." -ForegroundColor Yellow

New-BaiduTask "BaiduSyncStart" "启动百度网盘同步" "start_baidu.bat" $startTime
New-BaiduTask "BaiduSyncStop"  "关闭百度网盘同步" "stop_baidu.bat"   $stopTime
New-BaiduTask "BaiduSyncStartup" "开机检查同步状态" "startup_check.bat" $null

Write-Host ""
Write-Host "配置完成!" -ForegroundColor Green
Write-Host ""
Write-Host "修改 config.bat 后重新运行此脚本即可更新计划任务:" -ForegroundColor Gray
Write-Host "  powershell -File `"$scriptDir\setup_tasks.ps1`"" -ForegroundColor Gray
