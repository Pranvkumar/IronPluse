@echo off
REM ============================================================================
REM IronPulse Pro - Build and Run Script (Windows)
REM ============================================================================
REM This script compiles and runs the IronPulse Pro Gym Management System
REM with MongoDB integration and HTML/CSS styling
REM ============================================================================

setlocal enabledelayedexpansion

cls
echo.
echo ╔════════════════════════════════════════════════════════════════════════╗
echo ║                    IronPulse Pro - Build ^& Run                       ║
echo ║            Gym Management System with MongoDB Integration            ║
echo ╚════════════════════════════════════════════════════════════════════════╝
echo.

REM Check if we're in the right directory
if not exist "src\ironpulse" (
    echo ❌ Error: This script must be run from the IronPluse directory
    echo    Current directory: %cd%
    echo    Expected: IronPluse\
    pause
    exit /b 1
)

REM Check Java installation
echo 🔍 Checking Java installation...
java -version >nul 2>&1
if errorlevel 1 (
    echo ❌ Error: Java is not installed or not in PATH
    echo    Please install Java JDK 11 or higher
    pause
    exit /b 1
)

for /f "tokens=3" %%g in ('java -version 2^>^&1 ^| findstr /r "version"') do (
    set JAVA_VERSION=%%g
)
echo ✅ Java found: %JAVA_VERSION%
echo.

REM Check MongoDB drivers
echo 🔍 Checking MongoDB drivers...
if not exist "lib" (
    echo ❌ Error: lib directory not found
    pause
    exit /b 1
)

set "JAR_FOUND=0"
for %%f in (lib\*.jar) do (
    set "JAR_FOUND=1"
)

if "!JAR_FOUND!"=="0" (
    echo ❌ Error: MongoDB driver JARs not found in lib directory
    echo    Please ensure these files are present:
    echo    - lib\mongodb-driver-core-5.1.4.jar
    echo    - lib\mongodb-driver-sync-5.1.4.jar
    echo    - lib\bson-5.1.4.jar
    pause
    exit /b 1
)
echo ✅ MongoDB drivers found
echo.

REM Clean previous build
echo 🧹 Cleaning previous build...
if exist "out" (
    rmdir /s /q out >nul 2>&1
    echo ✅ Cleaned out directory
)
echo.

REM Create output directory
echo 📁 Creating output directory...
if not exist "out" mkdir out
echo ✅ Output directory created
echo.

REM Compile
echo ⚙️  Compiling source files...
echo    Command: javac -cp "lib\*;src" -d out src\ironpulse\**\*.java
echo.

setlocal
for /d /r %%d in (src\ironpulse\*) do (
    if exist "%%d\*.java" (
        javac -cp "lib\*;src" -d out "%%d\*.java" 2>&1
        if errorlevel 1 (
            echo.
            echo ❌ Compilation failed!
            echo    Please check the errors above
            pause
            exit /b 1
        )
    )
)
endlocal

echo.
echo ✅ Compilation successful!
echo.

REM Ready to run
echo ════════════════════════════════════════════════════════════════════════
echo.

if "%1"=="--build-only" (
    echo Build completed successfully!
    echo To run the application manually, use:
    echo    java -cp "lib\*;out" ironpulse.Main
    echo.
) else (
    echo Would you like to run the application now? (y/n)
    set /p response="> "

    if /i "!response!"=="y" (
        echo.
        echo 🚀 Starting IronPulse Pro...
        echo.
        echo ⏳ Loading application...
        echo.
        java -cp "lib\*;out" ironpulse.Main
    ) else (
        echo.
        echo 📝 To run the application manually, use:
        echo    java -cp "lib\*;out" ironpulse.Main
        echo.
    )
)

pause
endlocal
