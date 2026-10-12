@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion
title SmartHome IoT
echo ========================================
echo   SmartHome IoT
echo ========================================
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
  for %%D in (
    "%ProgramFiles%\Java"
    "%ProgramFiles%\Eclipse Adoptium"
    "%ProgramFiles%\Microsoft\jdk"
    "%ProgramFiles%\Zulu"
  ) do (
    if exist "%%~D" (
      for /f "delims=" %%J in ('dir /b /ad "%%~D" 2^>nul') do (
        if exist "%%~D\%%J\bin\java.exe" set "JAVA_EXE=%%~D\%%J\bin\java.exe"
      )
    )
  )
)
if not defined JAVA_EXE (
  echo [ERROR] Java not found!
  echo Please install JDK 17+: https://adoptium.net/
  echo Or set JAVA_HOME to your JDK directory.
  pause
  exit /b 1
)
echo [OK] Java: !JAVA_EXE!

rem derive JAVA_HOME from full path if needed
set "RUN_JAVA_HOME=%JAVA_HOME%"
if /i not "!JAVA_EXE!"=="java" (
  for %%J in ("!JAVA_EXE!") do set "RUN_JAVA_HOME=%%~dpJ.."
)

rem ---- locate mysql ----
set "MYSQL_EXE="
where mysql >nul 2>&1
if not errorlevel 1 set "MYSQL_EXE=mysql"
if not defined MYSQL_EXE if exist "D:\mysql\bin\mysql.exe" set "MYSQL_EXE=D:\mysql\bin\mysql.exe"
if not defined MYSQL_EXE (
  for %%D in (
    "%ProgramFiles%\MySQL\MySQL Server 8.0\bin"
    "%ProgramFiles%\MySQL\MySQL Server 8.4\bin"
    "%ProgramFiles%\MySQL\MySQL Server 9.0\bin"
  ) do (
    if exist "%%~D\mysql.exe" set "MYSQL_EXE=%%~D\mysql.exe"
  )
)
if not defined MYSQL_EXE (
  echo [ERROR] MySQL client not found!
  echo Please install MySQL 8.0: https://dev.mysql.com/downloads/mysql/
  pause
  exit /b 1
)
echo [OK] MySQL: !MYSQL_EXE!
echo.

rem ---- init database ----
echo [1/3] Initializing database...
set "INIT_OK="
if not defined DB_PASSWORD set /p DB_PASSWORD=MySQL root password (直接回车表示空密码):
if defined DB_PASSWORD (
  "!MYSQL_EXE!" -u root -p!DB_PASSWORD! --default-character-set=utf8mb4 < "%SCRIPT_DIR%sql\init.sql" 2>nul
) else (
  "!MYSQL_EXE!" -u root --default-character-set=utf8mb4 < "%SCRIPT_DIR%sql\init.sql" 2>nul
)
if not errorlevel 1 set "INIT_OK=1"
if not defined INIT_OK (
  echo 密码不正确，请重新输入 MySQL root 密码：
  set /p DB_PASSWORD=Password:
  "!MYSQL_EXE!" -u root -p!DB_PASSWORD! --default-character-set=utf8mb4 < "%SCRIPT_DIR%sql\init.sql"
  if not errorlevel 1 set "INIT_OK=1"
)
if not defined INIT_OK (
  echo [ERROR] Database init failed.
  echo Make sure MySQL service is running and password is correct.
  echo You can also edit backend\src\main\resources\application.yml
  pause
  exit /b 1
)
echo [OK] Database ready!

rem ---- start backend ----
echo.
echo [2/3] Starting backend...
set "BACKEND_DIR=%SCRIPT_DIR%backend"
set "LAUNCH_BAT=%SCRIPT_DIR%backend\launch-backend.bat"

(
  echo @echo off
  echo set "JAVA_HOME=%RUN_JAVA_HOME%"
  echo set "PATH=%%JAVA_HOME%%\bin;%%PATH%%"
  echo set "DB_PASSWORD=%DB_PASSWORD%"
  echo cd /d "%BACKEND_DIR%"
  echo call mvnw.cmd spring-boot:run
  echo pause
) > "%LAUNCH_BAT%"

start "SmartHome" cmd /k ""%LAUNCH_BAT%""

echo [3/3] Waiting for backend (about 20 seconds)...
timeout /t 20 /nobreak >nul

echo.
echo ========================================
echo   Done!
echo   Dashboard:  http://localhost:8080
echo   Management: http://localhost:8080/pages/management.html
echo   Report:     http://localhost:8080/pages/report.html
echo ========================================
echo.

start http://localhost:8080
echo Press any key to close this window...
pause >nul
