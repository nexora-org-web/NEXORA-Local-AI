@echo off
chcp 65001 >nul
title NEXORA Local AI - Setup
cd /d "%~dp0"
cls

echo ==============================================
echo          NEXORA AI - One-time setup
echo ==============================================
echo This downloads the AI engine (llama.cpp) and the
echo Gemma 3 270M model into this folder. Needs internet
echo ONLY for this step. After it finishes, the AI runs
echo fully offline.
echo.
pause

if not exist bin mkdir bin
if not exist models mkdir models

echo.
echo [1/2] Downloading llama.cpp engine...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
 "$ErrorActionPreference='Stop';" ^
 "[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;" ^
 "$r=Invoke-RestMethod 'https://api.github.com/repos/ggml-org/llama.cpp/releases/latest' -Headers @{'User-Agent'='nexora'};" ^
 "$a=$r.assets | Where-Object { $_.name -like '*bin-win-cpu-x64*.zip' } | Select-Object -First 1;" ^
 "if(-not $a){throw 'No Windows CPU build found'};" ^
 "Write-Host ('Downloading ' + $a.name);" ^
 "Invoke-WebRequest $a.browser_download_url -OutFile 'engine.zip';" ^
 "Expand-Archive 'engine.zip' -DestinationPath 'engine_tmp' -Force;" ^
 "$s=Get-ChildItem 'engine_tmp' -Recurse -Filter 'llama-server.exe' | Select-Object -First 1;" ^
 "if(-not $s){throw 'llama-server.exe not found in archive'};" ^
 "Copy-Item (Join-Path $s.DirectoryName '*') 'bin' -Recurse -Force;" ^
 "Remove-Item 'engine_tmp','engine.zip' -Recurse -Force"
if errorlevel 1 goto :fail

echo.
echo [2/2] Downloading Gemma 3 270M model (about 300 MB)...
if exist "models\gemma-3-270m-it-Q8_0.gguf" (
  echo Model already present, skipping.
) else (
  powershell -NoProfile -ExecutionPolicy Bypass -Command ^
   "$ErrorActionPreference='Stop';" ^
   "[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;" ^
   "$ProgressPreference='SilentlyContinue';" ^
   "Invoke-WebRequest 'https://huggingface.co/ggml-org/gemma-3-270m-it-GGUF/resolve/main/gemma-3-270m-it-Q8_0.gguf' -OutFile 'models\gemma-3-270m-it-Q8_0.gguf'"
  if errorlevel 1 goto :fail
)

echo.
echo Setup complete! Now double-click start.bat
echo.
echo ©NEXORA - https://github.com/nexora-org-web/Nexora-Official/tree/main
echo.
pause
exit /b 0

:fail
echo.
echo Download failed. Check your internet connection and run
echo setup.bat again, or download the files manually (see README.md).
echo.
pause
exit /b 1
