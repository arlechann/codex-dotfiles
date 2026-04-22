@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "SCRIPT_DIR=%~dp0"
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"
set "CODEX_DIR=%USERPROFILE%\.codex"

for /f %%I in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd-HHmmss"') do set "TIMESTAMP=%%I"

if not exist "%CODEX_DIR%" mkdir "%CODEX_DIR%"

call :link_file "%SCRIPT_DIR%\config.toml" "%CODEX_DIR%\config.toml"
if errorlevel 1 exit /b 1

call :link_file "%SCRIPT_DIR%\AGENTS.md" "%CODEX_DIR%\AGENTS.md"
if errorlevel 1 exit /b 1

call :link_skills "%SCRIPT_DIR%\skills" "%CODEX_DIR%\skills"
if errorlevel 1 exit /b 1

echo Setup completed. 1>&2
exit /b 0

:backup_path
set "TARGET=%~1"

if exist "%TARGET%" (
  set "ATTR="
  for %%A in ("%TARGET%") do set "ATTR=%%~aA"
  if "!ATTR:~0,1!"=="l" (
    rmdir "%TARGET%" >nul 2>&1
    if exist "%TARGET%" del "%TARGET%" >nul 2>&1
    exit /b 0
  )

  set "BACKUP=%TARGET%.backup-%TIMESTAMP%"
  move "%TARGET%" "!BACKUP!" >nul
  echo Backed up %TARGET% -> !BACKUP! 1>&2
)

exit /b 0

:link_file
set "SOURCE=%~1"
set "TARGET=%~2"

call :backup_path "%TARGET%"
mklink "%TARGET%" "%SOURCE%" >nul
if errorlevel 1 (
  echo Failed to link %TARGET% -> %SOURCE% 1>&2
  echo Run this script in an elevated command prompt or enable Developer Mode. 1>&2
  exit /b 1
)

echo Linked %TARGET% -> %SOURCE% 1>&2
exit /b 0

:link_skills
set "SOURCE_DIR=%~1"
set "TARGET_DIR=%~2"

if not exist "%SOURCE_DIR%\" exit /b 0
if not exist "%TARGET_DIR%" mkdir "%TARGET_DIR%"

for /d %%D in ("%SOURCE_DIR%\*") do (
  call :link_dir "%%~fD" "%TARGET_DIR%\%%~nxD"
  if errorlevel 1 exit /b 1
)

exit /b 0

:link_dir
set "SOURCE=%~1"
set "TARGET=%~2"

call :backup_path "%TARGET%"
mklink /D "%TARGET%" "%SOURCE%" >nul
if errorlevel 1 (
  echo Failed to link %TARGET% -> %SOURCE% 1>&2
  echo Run this script in an elevated command prompt or enable Developer Mode. 1>&2
  exit /b 1
)

echo Linked %TARGET% -> %SOURCE% 1>&2
exit /b 0
