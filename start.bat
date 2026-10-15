@echo off
setlocal EnableExtensions
title NEXORA Local AI
color 0B
cd /d "%~dp0"

set "SERVER=%~dp0runtime\llama-server.exe"
set "MODEL=%~dp0models\qwen2.5-coder-0.5b-heretic-q4_k_m.gguf"
set "WEB=%~dp0web"

if not exist "%SERVER%" (
  echo [ERROR] Runtime not found. Run setup.bat first.
  pause
  exit /b 1
)
if not exist "%MODEL%" (
  echo [ERROR] AI model not found. Run setup.bat first.
  pause
  exit /b 1
)
if not exist "%WEB%\index.html" (
  echo [ERROR] Web interface not found.
  pause
  exit /b 1
)

echo.
echo  ============================================================
echo                       NEXORA LOCAL AI
echo  ============================================================
echo  ©NEXORA : https://github.com/nexora-org-web/Nexora-Official
echo.
echo  Starting the local AI server. The first startup can take a moment.
echo  Your chat runs locally at http://127.0.0.1:8080
echo  Keep this window open while chatting. Press Ctrl+C to stop.
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
 "$ErrorActionPreference='Stop';" ^
 "$port=8080;" ^
 "$existing=Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue;" ^
 "if ($existing) { Write-Host '[ERROR] Port 8080 is already in use. Close the other app and try again.'; exit 2 };" ^
 "$argsList=@('-m',('"' + '%MODEL%' + '"'),'--host','127.0.0.1','--port','8080','--ctx-size','4096','--n-predict','512','--path',('"' + '%WEB%' + '"'),'--cors-origin','*');" ^
 " $p=Start-Process -FilePath '%SERVER%' -ArgumentList $argsList -PassThru -NoNewWindow;" ^
 "$ready=$false;" ^
 "for ($i=0; $i -lt 120; $i++) { Start-Sleep -Seconds 1; if ($p.HasExited) { Write-Host '[ERROR] AI server exited unexpectedly.'; exit 3 }; try { $null=Invoke-WebRequest -Uri 'http://127.0.0.1:8080/health' -UseBasicParsing -TimeoutSec 2; $ready=$true; break } catch {} };" ^
 "if (-not $ready) { Write-Host '[ERROR] Server did not become ready in time.'; Stop-Process -Id $p.Id -Force -ErrorAction SilentlyContinue; exit 4 };" ^
 "Start-Process 'http://127.0.0.1:8080/index.html';" ^
 "Write-Host 'NEXORA Local AI is running. Press Ctrl+C to stop.';" ^
 "while (-not $p.HasExited) { Start-Sleep -Seconds 2 }"
if errorlevel 1 (
  echo.
  echo [ERROR] Could not start the local AI. See the message above.
  pause
  exit /b 1
)
