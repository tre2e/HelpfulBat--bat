@echo off
setlocal EnableDelayedExpansion

:: 设置命令行代码页为 UTF-8 以支持中文
chcp 65001 >nul

:: 检查是否以管理员权限运行
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo 请以管理员权限运行此脚本！
    pause
    exit /b
)

:: 获取当前连接的WiFi名称
set "SSID="
for /f "tokens=2 delims=:" %%a in ('netsh wlan show interfaces ^| find "SSID" ^| find /v "BSSID"') do (
    set "SSID=%%a"
    set "SSID=!SSID:~1!"
)

:: 检查是否连接到WiFi
if "!SSID!"=="" (
    echo 未连接到任何WiFi网络！
    pause
    exit /b
)

:: 显示WiFi名称和密码
echo Current WiFi Is: !SSID!
netsh wlan show profile name="!SSID!" key=clear | find "Key Content"

if %errorLevel% neq 0 (
    echo 无法获取密码，请确保WiFi配置文件存在！
)


pause
