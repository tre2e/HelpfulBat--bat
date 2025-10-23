@echo off
chcp 65001 >nul
title 端口占用诊断工具 v2.0
echo === 端口占用诊断工具 ===
echo.

set "PORT="
set /p PORT="请输入要检查的端口号（例如 3000）："
if not defined PORT (
    echo 错误：未输入端口号，请重新运行并输入有效的端口号。
    pause
    exit /b
)

echo.
echo 正在检查 %PORT% 端口占用情况...
echo.

:: 检查端口占用
netstat -aon | findstr ":%PORT%" > temp.txt

:: 查找非零PID - 修复去重逻辑
set "PIDS="
for /f "tokens=5" %%i in ('type temp.txt ^| findstr /v "0$"') do (
    call :CheckPIDExists %%i
)

if "%PIDS%"=="" (
    echo %PORT% 端口未被占用，可以正常使用。
    goto :cleanup
)

echo.
echo %PORT% 端口已被占用，以下是详细信息：
echo =========================================
type temp.txt
echo =========================================
echo.

:: 查找进程名 - 修复中文显示
echo 正在查找占用端口的进程详情...
echo =========================================
echo 进程名                    PID
echo =========================================

for %%p in (%PIDS%) do (
    call :GetProcessName %%p
)

echo =========================================
echo.

:cleanup
del temp.txt 2>nul
echo 诊断完成。
pause
exit /b

:: 子程序：检查PID是否存在（去重）
:CheckPIDExists
set "NEW_PID=%1"
set "EXISTS=0"
for %%p in (%PIDS%) do (
    if "%%p"=="%NEW_PID%" set "EXISTS=1"
)
if "%EXISTS%"=="0" (
    set "PIDS=%PIDS% %NEW_PID%"
    echo 发现占用进程 PID: %NEW_PID%
)
goto :eof

:: 子程序：获取进程名
:GetProcessName
set "PID=%1"
for /f "tokens=1" %%a in ('tasklist /fi "PID eq %PID%" /fo table /nh 2^>nul ^| findstr /v "INFO"') do (
    echo %%a                    %PID%
)
goto :eof