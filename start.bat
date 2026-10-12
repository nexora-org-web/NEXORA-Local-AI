@echo off
chcp 65001 >nul
title NEXORA Local AI
cd /d "%~dp0"
cls

echo ==============================================
echo               N E X O R A   A I
echo        Local AI - Offline - Unlimited
echo ==============================================
echo.

set "SERVER=bin\llama-server.exe"
set "MODEL=models\gemma-3-270m-it-Q8_0.gguf"

if not exist "%SERVER%" goto :missing
if not exist "%MODEL%" goto :missing
goto :ready

:missing
echo Some required files are missing.
echo Run setup.bat once (needs internet) to download them,
echo then run start.bat again.
echo.
echo ©NEXORA - https://github.com/nexora-org-web/Nexora-Official/tree/main
echo.
pause
exit /b 1

:ready
echo Press ENTER to start the AI...
pause >nul
echo.
echo ----------------------------------------------
echo  Starting server. When you see "server is
echo  listening", open this URL in your browser:
echo.
echo        http://127.0.0.1:8080
echo.
echo  Copy and paste it into Chrome / Edge / Firefox.
echo  Close this window to stop the AI.
echo ----------------------------------------------
echo.

"%SERVER%" -m "%MODEL%" --host 127.0.0.1 --port 8080 -c 4096

echo.
echo ==============================================
echo  ©NEXORA
echo  https://github.com/nexora-org-web/Nexora-Official/tree/main
echo ==============================================
echo.
pause
