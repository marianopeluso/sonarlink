@echo off
REM SonarLink v1.0 - Windows 32-bit Installation Script
REM Specifically for 32-bit (x86) Windows systems

echo =======================================
echo   SonarLink v1.0 - Windows 32-bit
echo =======================================
echo.

REM Check if system is 32-bit
echo [*] Checking system architecture...
python -c "import platform; arch = platform.machine(); print('Architecture:', arch); exit(0 if arch.lower() in ['x86', 'i386', 'i686'] else 1)"
if errorlevel 1 (
    echo.
    echo [WARNING] This installer is for 32-bit Windows
    echo Your system appears to be 64-bit
    echo Please use install_windows.bat instead
    echo.
    pause
    exit /b 1
)

REM Check Python installation
echo [1/5] Checking Python installation...
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python not found!
    echo.
    echo Please install Python from https://www.python.org/downloads/
    echo IMPORTANT: During installation, check "Add Python to PATH"
    echo.
    pause
    exit /b 1
)

echo [OK] Python found:
python --version
echo.

REM Detect Python version
echo [2/5] Detecting Python version...
for /f "tokens=2" %%i in ('python --version 2^>^&1') do set PYTHON_VERSION=%%i
for /f "tokens=1,2 delims=." %%a in ("%PYTHON_VERSION%") do (
    set PYTHON_MAJOR=%%a
    set PYTHON_MINOR=%%b
)

echo Python Version: %PYTHON_MAJOR%.%PYTHON_MINOR%
echo.

REM Check pip
echo [3/5] Checking pip...
python -m pip --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] pip not found!
    echo Installing pip...
    python -m ensurepip --upgrade
)

echo [OK] pip found
python -m pip --version
echo.

REM Install PyAudio for 32-bit
echo [4/5] Installing PyAudio for 32-bit Windows...
echo.

if %PYTHON_MAJOR% GEQ 3 if %PYTHON_MINOR% GEQ 13 (
    echo Detected Python 3.13+ - Using wheel for 32-bit
    echo.
    
    set "WHEEL_URL=https://github.com/intxcc/pyaudio_portaudio/releases/download/v0.2.14/PyAudio-0.2.14-cp313-cp313-win32.whl"
    set "WHEEL_FILE=PyAudio-0.2.14-cp313-cp313-win32.whl"
    
    echo Downloading PyAudio wheel for 32-bit...
    echo URL: %WHEEL_URL%
    echo File: %WHEEL_FILE%
    echo.
    
    powershell -Command "$url='%WHEEL_URL%'; $file='%WHEEL_FILE%'; [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri $url -OutFile $file"
    
    if exist "%WHEEL_FILE%" (
        echo [OK] Download successful
        echo Installing PyAudio...
        pip install "%WHEEL_FILE%"
        del "%WHEEL_FILE%"
    ) else (
        echo [WARNING] Automatic download failed
        echo.
        echo Please download PyAudio manually:
        echo 1. Visit: https://www.lfd.uci.edu/~gohlke/pythonlibs/#pyaudio
        echo 2. Download: PyAudio-0.2.14-cp313-cp313-win32.whl
        echo 3. Run: pip install PyAudio-0.2.14-cp313-cp313-win32.whl
        echo.
        pause
    )
) else (
    echo Using pipwin for Python %PYTHON_MAJOR%.%PYTHON_MINOR%...
    pip install pipwin
    pipwin install pyaudio
)

echo.

REM Install other dependencies
echo [5/5] Installing other dependencies...
pip install ggwave-wheels cryptography numpy

if errorlevel 1 (
    echo.
    echo [ERROR] Failed to install dependencies
    echo.
    pause
    exit /b 1
)

echo.
echo =======================================
echo   Verifying Installation
echo =======================================
echo.

python -c "import pyaudio; print('[OK] PyAudio:', pyaudio.__version__)" 2>nul || echo [FAILED] PyAudio
python -c "import ggwave; print('[OK] ggwave')" 2>nul || echo [FAILED] ggwave
python -c "import cryptography; print('[OK] cryptography')" 2>nul || echo [FAILED] cryptography
python -c "import numpy; print('[OK] numpy:', numpy.__version__)" 2>nul || echo [FAILED] numpy

echo.
echo =======================================
echo   Installation Complete!
echo =======================================
echo.
echo To start SonarLink:
echo   python sonarlink.py
echo.
pause
