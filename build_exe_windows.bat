@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM Build Windows EXE for IronPulse using jpackage
REM Run this file on Windows from project root: build_exe_windows.bat

cd /d "%~dp0"

echo ================================================
echo   IronPulse - Windows EXE Packaging
echo ================================================
echo.

where jpackage >nul 2>nul
if errorlevel 1 (
  echo ERROR: jpackage not found. Install JDK 17+ and ensure it is on PATH.
  exit /b 1
)

where javac >nul 2>nul
if errorlevel 1 (
  echo ERROR: javac not found. Install JDK 17+ and ensure it is on PATH.
  exit /b 1
)

if not exist "lib\javafx-controls-21.0.5-linux.jar" (
  echo NOTE: Linux JavaFX jars are present by default in this repo.
  echo For Windows EXE, download Windows JavaFX jars and place them in lib\.
  echo Expected examples:
  echo   lib\javafx-controls-21.0.5-win.jar
  echo   lib\javafx-graphics-21.0.5-win.jar
  echo   lib\javafx-base-21.0.5-win.jar
  echo.
)

echo Cleaning old outputs...
if exist out rd /s /q out
if exist dist\app rd /s /q dist\app
mkdir out
mkdir dist\app\lib

echo Collecting Java source files...
set SOURCES=
for /r src %%f in (*.java) do (
  set SOURCES=!SOURCES! "%%f"
)

echo Compiling...
javac --module-path "lib" --add-modules javafx.controls,javafx.graphics -cp "lib/*;src" -d out !SOURCES!
if errorlevel 1 (
  echo ERROR: Compilation failed.
  exit /b 1
)

echo Creating app jar...
jar --create --file dist\app\IronPulse.jar -C out .
if errorlevel 1 (
  echo ERROR: Jar creation failed.
  exit /b 1
)

echo Copying dependencies...
copy /y lib\*.jar dist\app\lib\ >nul

echo Packaging EXE installer...
jpackage ^
  --type exe ^
  --name IronPulse ^
  --dest dist ^
  --input dist\app ^
  --main-jar IronPulse.jar ^
  --main-class ironpulse.Main ^
  --class-path "lib/*" ^
  --win-dir-chooser ^
  --win-menu ^
  --win-shortcut

if errorlevel 1 (
  echo ERROR: EXE packaging failed.
  exit /b 1
)

echo.
echo SUCCESS: EXE created in dist\
dir /b dist\*.exe
echo.
echo If app fails to launch, verify JavaFX Windows jars exist in lib\ and rebuild.
