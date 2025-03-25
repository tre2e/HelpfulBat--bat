@echo off
chcp 65001 >nul
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

netstat -aon | findstr ":%PORT%" > temp.txt
set "PORT_IN_USE="

for /f "tokens=5 delims= " %%i in ('type temp.txt ^| findstr /v "0$"') do (
    set "PORT_IN_USE=%%i"
    echo 检查到 PID: %%i
    set "PIDS[!PORT_IN_USE!]=1"
)

if not defined PORT_IN_USE (
    echo %PORT% 端口未被占用，可以正常使用。
    goto :cleanup
)

echo %PORT% 端口已被占用，以下是详细信息：
echo.
type temp.txt
echo.

echo 正在查找占用端口的进程...
echo.
for /f "tokens=1,2" %%a in ('tasklist ^| findstr /r "^[a-zA-Z]"') do (
    for %%p in (!PIDS!) do (
        if "%%b"=="%%p" (
            echo %%a %%b
        )
    )
)

:cleanup
del temp.txt 2>nul
echo.
echo 诊断完成。
pause