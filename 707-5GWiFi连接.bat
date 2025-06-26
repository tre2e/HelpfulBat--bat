@echo off
setlocal enabledelayedexpansion

:: 定义变量
set SSID=707-5G
set PASSWORD=18821262236
set TEMP_XML=temp_wifi_profile.xml

:: 检查是否以管理员身份运行
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Running as Admin...
) else (
    echo Eerror: Run As Admin
    pause
    exit /b 1
)

:: 创建临时 XML 文件
echo ^<?xml version="1.0"?^> > %TEMP_XML%
echo ^<WLANProfile xmlns="http://www.microsoft.com/networking/WLAN/profile/v1"^> >> %TEMP_XML%
echo     ^<name^>%SSID%^</name^> >> %TEMP_XML%
echo     ^<SSIDConfig^> >> %TEMP_XML%
echo         ^<SSID^> >> %TEMP_XML%
echo             ^<name^>%SSID%^</name^> >> %TEMP_XML%
echo         ^</SSID^> >> %TEMP_XML%
echo     ^</SSIDConfig^> >> %TEMP_XML%
echo     ^<connectionType^>ESS^</connectionType^> >> %TEMP_XML%
echo     ^<connectionMode^>auto^</connectionMode^> >> %TEMP_XML%
echo     ^<MSM^> >> %TEMP_XML%
echo         ^<security^> >> %TEMP_XML%
echo             ^<authEncryption^> >> %TEMP_XML%
echo                 ^<authentication^>WPA2PSK^</authentication^> >> %TEMP_XML%
echo                 ^<encryption^>AES^</encryption^> >> %TEMP_XML%
echo                 ^<useOneX^>false^</useOneX^> >> %TEMP_XML%
echo             ^</authEncryption^> >> %TEMP_XML%
echo             ^<sharedKey^> >> %TEMP_XML%
echo                 ^<keyType^>passPhrase^</keyType^> >> %TEMP_XML%
echo                 ^<protected^>false^</protected^> >> %TEMP_XML%
echo                 ^<keyMaterial^>%PASSWORD%^</keyMaterial^> >> %TEMP_XML%
echo             ^</sharedKey^> >> %TEMP_XML%
echo         ^</security^> >> %TEMP_XML%
echo     ^</MSM^> >> %TEMP_XML%
echo ^</WLANProfile^> >> %TEMP_XML%

echo XML File Created, adding Wi-Fi config file...

:: 添加 Wi-Fi 配置文件
netsh wlan add profile filename="%TEMP_XML%"

if %errorlevel% == 0 (
    echo Successfullly add Wi-Fi:%SSID% 
    echo Now use< netsh wlan connect name="%SSID%" > to connect it or it is already connected。
) else (
    echo Error: Check if your info was correct.
)

:: 删除临时 XML 文件
if exist %TEMP_XML% (
    del %TEMP_XML%
    echo Temp XML File has been deleted.
) else (
    echo Attension: TEMP_XML file not exists.
)

echo Done.Enjoy:)
pause
endlocal