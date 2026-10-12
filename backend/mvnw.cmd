@echo off
setlocal
rem %~dp0 ends with backslash; strip it to avoid quote-escape issues
set "MAVEN_PROJECTBASEDIR=%~dp0"
if "%MAVEN_PROJECTBASEDIR:~-1%"=="\" set "MAVEN_PROJECTBASEDIR=%MAVEN_PROJECTBASEDIR:~0,-1%"
set "WRAPPER_JAR=%MAVEN_PROJECTBASEDIR%\.mvn\wrapper\maven-wrapper.jar"
set "WRAPPER_PROPERTIES=%MAVEN_PROJECTBASEDIR%\.mvn\wrapper\maven-wrapper.properties"

rem ---- locate java ----
set "JAVA_EXE=java"
if defined JAVA_HOME if exist "%JAVA_HOME%\bin\java.exe" set "JAVA_EXE=%JAVA_HOME%\bin\java.exe"
if "%JAVA_EXE%"=="java" (
  where java >nul 2>&1
  if errorlevel 1 (
    if exist "D:\java\bin\java.exe" set "JAVA_EXE=D:\java\bin\java.exe"
  )
)
if "%JAVA_EXE%"=="java" (
  where java >nul 2>&1
  if errorlevel 1 (
    echo [ERROR] Java not found. Install JDK 17+ or set JAVA_HOME.
    exit /b 1
  )
)

if not exist "%WRAPPER_JAR%" (
  echo Downloading Maven Wrapper...
  powershell -NoProfile -Command "try { Invoke-WebRequest -Uri 'https://repo1.maven.org/maven2/org/apache/maven/wrapper/maven-wrapper/3.2.0/maven-wrapper-3.2.0.jar' -OutFile '%MAVEN_PROJECTBASEDIR%\.mvn\wrapper\maven-wrapper.jar' -UseBasicParsing } catch { exit 1 }"
  if not exist "%WRAPPER_JAR%" (
    echo [ERROR] Failed to download maven-wrapper.jar
    exit /b 1
  )
)

rem maven-wrapper 3.2.0 has no Main-Class in manifest; invoke MavenWrapperMain directly
"%JAVA_EXE%" "-Dmaven.multiModuleProjectDirectory=%MAVEN_PROJECTBASEDIR%" -cp "%WRAPPER_JAR%" org.apache.maven.wrapper.MavenWrapperMain %*
