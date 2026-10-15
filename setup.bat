@echo off
setlocal EnableExtensions
title NEXORA Local AI - Setup
color 0B
cd /d "%~dp0"

echo.
echo  ============================================================
echo                       NEXORA LOCAL AI
echo  ============================================================
echo.
echo  ©NEXORA : https://github.com/nexora-org-web/Nexora-Official
echo  Github Repository : https://github.com/nexora-org-web/NEXORA-Local-AI
echo.
echo  HOW TO USE
echo  1. Run setup.bat while connected to the internet.
echo  2. Press Y, then Enter, to download the runtime and AI model.
echo  3. Wait for [COMPLETED] to appear.
echo  4. Run start.bat to launch the local AI in your default browser.
echo  5. Keep the server window open while chatting.
echo  6. Press Ctrl+C in that window to stop the AI.
echo.
echo  REQUIREMENTS
echo  - 64-bit Windows 10/11
echo  - Internet access for setup only
echo  - Approximately 2 GB of free storage recommended
echo.
echo  PORTABLE USE
echo  You can keep this entire folder on a USB drive or copy it to a PC.
echo  Run setup.bat on each computer first. After setup, chat works offline.
echo  Do not remove or rename the runtime, models, or web folders.
echo.
echo  PRIVACY
echo  The server listens on 127.0.0.1 only and is not exposed to your network.
echo  Setup downloads llama.cpp from GitHub and the model from Hugging Face.
echo.
echo  MODEL NOTE
echo  This is a compact 0.5B model. It can make mistakes and has limited
echo  reasoning ability. Uncensored behavior does not mean reliable answers.
echo.
choice /C YN /N /M "Press Y then Enter to continue, or N to cancel: "
if errorlevel 2 goto :cancel

where powershell.exe >nul 2>&1
if errorlevel 1 (
  echo [ERROR] PowerShell was not found.
  pause
  exit /b 1
)

if not exist "runtime" mkdir "runtime"
if not exist "models" mkdir "models"

echo.
echo [1/3] Checking internet connection...
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Invoke-WebRequest -Uri 'https://api.github.com' -UseBasicParsing -TimeoutSec 15 | Out-Null; exit 0 } catch { exit 1 }"
if errorlevel 1 (
  echo [ERROR] Internet check failed. Connect to the internet and run setup again.
  pause
  exit /b 1
)

echo.
echo [2/3] Downloading llama.cpp Windows CPU runtime...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
 "$ErrorActionPreference='Stop';" ^
 "$headers=@{ 'User-Agent'='NEXORA-Local-AI' };" ^
 "$r=Invoke-RestMethod -Uri 'https://api.github.com/repos/ggml-org/llama.cpp/releases/latest' -Headers $headers;" ^
 "$a=$r.assets | Where-Object { $_.name -match 'bin-win-cpu-x64\.zip$' } | Select-Object -First 1;" ^
 "if (-not $a) { $a=$r.assets | Where-Object { $_.name -match 'bin-win-avx2-x64\.zip$' } | Select-Object -First 1 };" ^
 "if (-not $a) { throw 'No compatible Windows x64 CPU ZIP found in the latest release.' };" ^
 "$zip=Join-Path (Get-Location) 'runtime\llama-runtime.zip';" ^
 "$tmp=Join-Path (Get-Location) 'runtime\extract-temp';" ^
 "Invoke-WebRequest -Uri $a.browser_download_url -OutFile $zip -Headers $headers;" ^
 "if (Test-Path $tmp) { Remove-Item $tmp -Recurse -Force };" ^
 "New-Item -ItemType Directory -Path $tmp | Out-Null;" ^
 "Expand-Archive -LiteralPath $zip -DestinationPath $tmp -Force;" ^
 "$exe=Get-ChildItem -Path $tmp -Filter 'llama-server.exe' -Recurse | Select-Object -First 1;" ^
 "if (-not $exe) { throw 'llama-server.exe was not found in the downloaded ZIP.' };" ^
 "$src=$exe.Directory.FullName;" ^
 "Copy-Item -Path (Join-Path $src '*') -Destination (Join-Path (Get-Location) 'runtime') -Recurse -Force;" ^
 "Remove-Item -LiteralPath $zip -Force;" ^
 "Remove-Item -LiteralPath $tmp -Recurse -Force;" ^
 "Write-Host 'Runtime ready.'"
if errorlevel 1 (
  echo [ERROR] Runtime download or extraction failed.
  echo Check your internet connection and try setup.bat again.
  pause
  exit /b 1
)

echo.
echo [3/3] Downloading Qwen2.5-Coder-0.5B-Instruct-heretic Q4_K_M...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
 "$ErrorActionPreference='Stop';" ^
 "$url='https://huggingface.co/saidutta69/Qwen2.5-Coder-0.5B-Instruct-heretic/resolve/main/Qwen2.5-Coder-0.5B-Instruct-heretic-Q4_K_M.gguf';" ^
 "$out=Join-Path (Get-Location) 'models\qwen2.5-coder-0.5b-heretic-q4_k_m.gguf';" ^
 "if (Test-Path $out) { if ((Get-Item $out).Length -ge 300000000) { Write-Host 'Model already downloaded.'; exit 0 } else { Remove-Item $out -Force } };" ^
 "Invoke-WebRequest -Uri $url -OutFile $out -Headers @{ 'User-Agent'='NEXORA-Local-AI' };" ^
 "if ((Get-Item $out).Length -lt 300000000) { throw 'Model download appears incomplete.' };" ^
 "Write-Host 'Model ready.'"
if errorlevel 1 (
  echo [ERROR] Model download failed or appears incomplete.
  echo Remove the incomplete model file in the models folder and run setup.bat again.
  pause
  exit /b 1
)

if not exist "runtime\llama-server.exe" (
  echo [ERROR] llama-server.exe is missing after setup.
  pause
  exit /b 1
)
if not exist "web\index.html" (
  echo [ERROR] The web interface is missing.
  pause
  exit /b 1
)

echo.
color 0A
echo  ============================================================
echo                        [COMPLETED]
echo  ============================================================
echo.
echo  Setup finished successfully.
echo  You can now run start.bat. Internet is not needed for chatting.
echo.
pause
exit /b 0

:cancel
echo.
echo Setup cancelled by user.
pause
exit /b 0
