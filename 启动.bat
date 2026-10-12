@echo off
chcp 65001 >nul
setlocal
title SmartHome IoT
echo Starting SmartHome IoT...
echo.

set "SCRIPT_DIR=%~dp0"

rem ---- locate java ----
set "JAVA_EXE="
if defined JAVA_HOME if exist "%JAVA_HOME%\bin\java.exe" set "JAVA_EXE=%JAVA_HOME%\bin\java.exe"
if not defined JAVA_EXE (
  where java >nul 2>&1
  if not errorlevel 1 set "JAVA_EXE=java"
)
if not defined JAVA_EXE if exist "D:\java\bin\java.exe" set "JAVA_EXE=D:\java\bin\java.exe"
if not defined JAVA_EXE (
  echo [ERROR] Java not found! Install JDK 17+ or set JAVA_HOME.
  pause
  exit /b 1
)
echo [OK] Java found

set "RUN_JAVA_HOME=%JAVA_HOME%"
if /i not "%JAVA_EXE%"=="java" (
  for %%J in ("%JAVA_EXE%") do set "RUN_JAVA_HOME=%%~dpJ.."
)

set "BACKEND_DIR=%SCRIPT_DIR%backend"
set "LAUNCH_BAT=%SCRIPT_DIR%backend\launch-backend.bat"
(
  echo @echo off
  echo set "JAVA_HOME=%RUN_JAVA_HOME%"
  echo set "PATH=%%JAVA_HOME%%\bin;%%PATH%%"
  echo cd /d "%BACKEND_DIR%"
  echo call mvnw.cmd spring-boot:run
  echo pause
) > "%LAUNCH_BAT%"

start "SmartHome" cmd /k ""%LAUNCH_BAT%""

echo Waiting 20 seconds...
timeout /t 20 /nobreak >nul

echo.
echo Done! Opening http://localhost:8080
start http://localhost:8080
echo.
echo Press any key to close...
pause >nul
